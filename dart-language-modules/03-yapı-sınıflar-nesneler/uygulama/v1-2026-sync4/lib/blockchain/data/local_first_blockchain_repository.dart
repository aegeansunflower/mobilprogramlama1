// DART KONUSU: Class modifiers — `final class` ile `abstract interface`
// sözleşmesini uygulama. Classes & objects — generics, private alanlar,
// `late`, record dönüş tipi. Metadata — `@override`, `@RoleRestricted`.
// Libraries & imports — `show` / `hide`.

/// Yerel SQLite + uzak zincir senkronizasyonu.
library;

import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:sarkisla_yoklama/blockchain/data/local/chain_database.dart'
    hide StoredBlocks;
import 'package:sarkisla_yoklama/blockchain/data/remote/remote_chain_source.dart';
import 'package:sarkisla_yoklama/blockchain/domain/block.dart';
import 'package:sarkisla_yoklama/blockchain/domain/blockchain.dart';
import 'package:sarkisla_yoklama/blockchain/domain/blockchain_repository.dart';
import 'package:sarkisla_yoklama/blockchain/domain/chain_receipt.dart';
import 'package:sarkisla_yoklama/blockchain/domain/chain_validation.dart';
import 'package:sarkisla_yoklama/blockchain/domain/chain_validator.dart';
import 'package:sarkisla_yoklama/blockchain/domain/consensus.dart';
import 'package:sarkisla_yoklama/blockchain/domain/record.dart';
import 'package:sarkisla_yoklama/blockchain/domain/signing.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Önce yerel veritabanına bakan, uzak zincirle senkronize olan depo.
///
/// Blok ekleme akışı:
/// 1. Uzaktaki yeni blokları çek ve doğrula ([sync]).
/// 2. Yeni bloğu yerel başın (head) üzerine kur ve imzala (`seal`).
/// 3. Uzak zincire "uzunluk hâlâ N ise" koşuluyla yaz.
/// 4. Başka görevli araya girdiyse 1. adıma dön (en fazla [maxAttempts]).
final class LocalFirstBlockchainRepository<T extends Record>
    implements BlockchainRepository<T> {
  LocalFirstBlockchainRepository({
    required this._database,
    required this._remote,
    required this._consensus,
    required this._decode,
    this._clock = const Clock(),
    this.maxAttempts = 3,
  });

  final ChainDatabase _database;
  final RemoteChainSource _remote;
  final ConsensusStrategy _consensus;
  final RecordDecoder<T> _decode;
  final Clock _clock;

  /// Eşzamanlı ekleme çakışmasında en fazla deneme sayısı.
  final int maxAttempts;

  Blockchain<T>? _chain;

  Block<T> _fromRow(StoredBlock row) =>
      Block<T>.fromJson(jsonDecode(row.json) as Map<String, Object?>, _decode);

  Future<Blockchain<T>> _ensureLoaded() async {
    final loaded = _chain;
    if (loaded != null) return loaded;
    final rows = await _database.allBlocks();
    if (rows.isEmpty) {
      final genesis = Block<T>.genesis();
      await _store(genesis);
      return _chain = Blockchain.fromBlocks([genesis], consensus: _consensus);
    }
    return _chain = Blockchain.fromBlocks([
      for (final row in rows) _fromRow(row),
    ], consensus: _consensus);
  }

  Future<void> _store(Block<T> block) => _database.insertBlock(
    block.index,
    block.hash.hex,
    jsonEncode(block.toJson()),
  );

  @override
  Stream<List<Block<T>>> watchBlocks() => _database.watchAll().map(
    (rows) => [for (final row in rows) _fromRow(row)],
  );

  @override
  Future<List<Block<T>>> currentBlocks() async =>
      (await _ensureLoaded()).blocks;

  @override
  Future<Result<int>> sync() async {
    final chain = await _ensureLoaded();
    try {
      final incoming = await _remote.fetchFrom(chain.length);
      for (final json in incoming) {
        final accepted = await chain.accept(Block<T>.fromJson(json, _decode));
        switch (accepted) {
          case Ok(:final value):
            await _store(value);
          case Err(:final failure):
            return Err(failure);
        }
      }
      return Ok(incoming.length);
    } on Exception catch (e) {
      return Err(NetworkFailure('Zincir senkronize edilemedi.', cause: e));
    }
  }

  @override
  @RoleRestricted(Role.instructor)
  Future<Result<Block<T>>> appendBlock(
    List<T> transactions, {
    required BlockSigner signer,
    required Role actor,
  }) async {
    final denied = RoleGuard.ensure(Role.instructor, actor);
    if (denied != null) return Err(denied);

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final synced = await sync();
      if (synced case Err(:final failure)) return Err(failure);

      final chain = await _ensureLoaded();
      final sealed = await chain.seal(
        transactions,
        signer: signer,
        actor: actor,
        at: _clock.now(),
      );
      final Block<T> block;
      switch (sealed) {
        case Ok(:final value):
          block = value;
        case Err(:final failure):
          return Err(failure);
      }

      final written = await _remote.tryAppend(
        block.toJson(),
        expectedLength: block.index,
      );
      if (!written) continue; // Araya başka blok girdi; yeniden dene.

      final accepted = await chain.accept(block);
      if (accepted case Ok(:final value)) await _store(value);
      return accepted;
    }
    return const Err(
      ChainFailure('Zincir şu an yoğun, lütfen tekrar deneyin.'),
    );
  }

  /// Doğrulama **veritabanından yeniden okunarak** yapılır. Bellekteki kopya
  /// değil, diskteki veri denetlenir; böylece depoya doğrudan yapılan
  /// müdahaleler de yakalanır.
  @override
  Future<ChainValidation> validate() async {
    final rows = await _database.allBlocks();
    final blocks = <Block<T>>[];
    for (final row in rows) {
      try {
        blocks.add(_fromRow(row));
      } on Object catch (e) {
        return UnreadableBlock(row.blockIndex, error: e);
      }
    }
    return await ChainValidator(_consensus)(blocks);
  }

  @override
  Future<ChainReceipt?> receiptFor(Hash recordHash) async {
    final found = (await _ensureLoaded()).receiptFor(recordHash);
    if (found == null) return null;
    return ChainReceipt(
      recordHash: recordHash,
      blockIndex: found.block.index,
      blockHash: found.block.hash,
      merkleRoot: found.block.merkleRoot,
      proof: found.proof,
    );
  }

  /// **Yalnızca demo:** [blockIndex] bloğunun saklanan JSON'unu [mutate] ile
  /// değiştirir. Kurcalama ekranında zincirin nerede bozulduğunu göstermek
  /// için kullanılır.
  Future<void> simulateTamper(
    int blockIndex,
    Map<String, Object?> Function(Map<String, Object?> json) mutate,
  ) async {
    final rows = await _database.allBlocks();
    final row = rows.firstWhere((r) => r.blockIndex == blockIndex);
    final json = jsonDecode(row.json) as Map<String, Object?>;
    await _database.overwriteJson(blockIndex, jsonEncode(mutate(json)));
  }
}
