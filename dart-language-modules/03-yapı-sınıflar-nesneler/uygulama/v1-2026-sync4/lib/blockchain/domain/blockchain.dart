// DART KONUSU: Classes & objects — generics (`Blockchain<T extends Record>`),
// factory constructor, private constructor, getter'lar, mixin
// (`with EventEmitter`), records (`({Block<T> block, T record})`). Metadata —
// `@RoleRestricted` özel annotation'ı. Class modifiers — `final class`.
// Libraries & imports — `show`.

/// Bellek içi, doğrulanan zincir.
library;

import 'dart:collection' show UnmodifiableListView;

import 'package:sarkisla_yoklama/blockchain/domain/block.dart';
import 'package:sarkisla_yoklama/blockchain/domain/chain_validation.dart';
import 'package:sarkisla_yoklama/blockchain/domain/chain_validator.dart';
import 'package:sarkisla_yoklama/blockchain/domain/consensus.dart';
import 'package:sarkisla_yoklama/blockchain/domain/merkle_tree.dart';
import 'package:sarkisla_yoklama/blockchain/domain/record.dart';
import 'package:sarkisla_yoklama/blockchain/domain/signing.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// [T] türünde kayıtları tutan, yalnızca eklemeye açık (append-only) zincir.
///
/// Zincire her blok eklendiğinde dinleyicilere `emit` ile haber verir.
///
/// `final class` seçildi: ekleme kuralları ([append], [accept]) delinemez.
final class Blockchain<T extends Record> with EventEmitter<Block<T>> {
  Blockchain._(List<Block<T>> blocks, this._validator)
    : _blocks = List.of(blocks);

  /// Yalnızca genesis bloğu içeren yeni zincir.
  factory Blockchain.genesis({required ConsensusStrategy consensus}) =>
      Blockchain._([Block<T>.genesis()], ChainValidator(consensus));

  /// Depodan okunan bloklarla zincir oluşturur. Doğrulama *yapmaz*;
  /// bozuk zincirin de açılıp kurcalama ekranında incelenebilmesi için
  /// doğrulama [validate] ile ayrıca yapılır.
  factory Blockchain.fromBlocks(
    List<Block<T>> blocks, {
    required ConsensusStrategy consensus,
  }) => blocks.isEmpty
      ? Blockchain.genesis(consensus: consensus)
      : Blockchain._(blocks, ChainValidator(consensus));

  final List<Block<T>> _blocks;
  final ChainValidator _validator;

  /// Bloklar (salt okunur görünüm).
  List<Block<T>> get blocks => UnmodifiableListView(_blocks);

  /// Son blok.
  Block<T> get head => _blocks.last;

  /// Blok sayısı (genesis dahil).
  int get length => _blocks.length;

  /// Tüm bloklardaki kayıtlar, zincir sırasıyla.
  Iterable<T> get records => _blocks.expand((b) => b.transactions);

  /// Yeni kayıtları bloğa dönüştürür, [signer] ile imzalar ve zincire ekler.
  ///
  /// Yalnızca öğretim görevlisi çağırabilir.
  @RoleRestricted(Role.instructor)
  Future<Result<Block<T>>> append(
    List<T> transactions, {
    required BlockSigner signer,
    required Role actor,
    required DateTime at,
  }) async {
    final denied = RoleGuard.ensure(Role.instructor, actor);
    if (denied != null) return Err(denied);
    final sealed = await seal(
      transactions,
      signer: signer,
      actor: actor,
      at: at,
    );
    return await sealed.then(accept);
  }

  /// Zincirin sonuna gelecek bloğu oluşturup imzalar ama **eklemez**.
  ///
  /// Uzak zincire yazmadan önce bloğu hazırlamak için kullanılır: yazma
  /// başarısız olursa (başka bir görevli araya blok eklemişse) yerel zincir
  /// değişmemiş olur.
  @RoleRestricted(Role.instructor)
  Future<Result<Block<T>>> seal(
    List<T> transactions, {
    required BlockSigner signer,
    required Role actor,
    required DateTime at,
  }) async {
    final denied = RoleGuard.ensure(Role.instructor, actor);
    if (denied != null) return Err(denied);
    if (transactions.isEmpty) {
      return const Err(ValidationFailure('Boş blok zincire eklenemez.'));
    }
    final duplicate = transactions.where((t) => locate(t.recordHash) != null);
    if (duplicate.isNotEmpty) {
      return Err(
        ValidationFailure(
          'Kayıt zaten zincirde: ${duplicate.first.recordHash.short}',
        ),
      );
    }
    // Saat geri kaymışsa blok zamanı önceki bloğun gerisine düşmez.
    final utc = at.toUtc();
    final timestamp = utc.isBefore(head.timestamp) ? head.timestamp : utc;
    final unsigned = Block<T>.next(
      head,
      transactions: transactions,
      authorityId: signer.authorityId,
      timestamp: timestamp,
    );
    return Ok(unsigned.signedWith(await signer.sign(unsigned.hash.bytes)));
  }

  /// Başka bir cihazdan gelen bloğu doğrulayıp ekler.
  Future<Result<Block<T>>> accept(Block<T> block) async {
    if (block.index != length) {
      return Err(
        ChainFailure('Blok #${block.index} beklenmiyor (beklenen #$length).'),
      );
    }
    if (block.previousHash != head.hash) {
      return const Err(ChainFailure('Blok, zincirin sonuna bağlanmıyor.'));
    }
    if (block.recomputeMerkleRoot() != block.merkleRoot ||
        block.computeHash() != block.hash) {
      return const Err(ChainFailure('Blok içeriği hash ile uyuşmuyor.'));
    }
    final issue = await _validator.consensus.check(block);
    if (issue != null) return Err(ChainFailure(issue.reason));

    _blocks.add(block);
    emit(block);
    return Ok(block);
  }

  /// Tüm zinciri doğrular.
  Future<ChainValidation> validate() => _validator(_blocks);

  /// [recordHash] kaydını ve bulunduğu bloğu döndürür.
  ({Block<T> block, T record})? locate(Hash recordHash) {
    for (final block in _blocks) {
      final i = block.indexOfRecord(recordHash);
      if (i >= 0) return (block: block, record: block.transactions[i]);
    }
    return null;
  }

  /// [recordHash] için öğrenci makbuzu (blok hash'i + Merkle kanıtı).
  ({Block<T> block, MerkleProof proof})? receiptFor(Hash recordHash) {
    final found = locate(recordHash);
    if (found == null) return null;
    return (block: found.block, proof: found.block.proofFor(recordHash)!);
  }
}
