import 'package:flutter_test/flutter_test.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart';
import 'package:sarkisla_yoklama/core/core.dart';

import '../helpers/test_doubles.dart';

/// Kurcalama senaryoları: her saldırı, zincirin *hangi blokta* ve *neden*
/// bozulduğunu doğru raporlamalı.
void main() {
  late ({
    Ed25519Signer signer,
    InMemoryAuthorityDirectory directory,
    ProofOfAuthority poa,
  })
  auth;
  late List<Block<TestRecord>> blocks;
  late ChainValidator validate;

  setUp(() async {
    auth = await setUpAuthority();
    final chain = Blockchain<TestRecord>.genesis(consensus: auth.poa);
    for (final prefix in ['a', 'b', 'c']) {
      await chain.append(
        records(prefix, 4),
        signer: auth.signer,
        actor: Role.instructor,
        at: t0,
      );
    }
    blocks = List.of(chain.blocks);
    validate = ChainValidator(auth.poa);
  });

  List<Block<TestRecord>> replaced(int i, Block<TestRecord> block) =>
      List.of(blocks)..[i] = block;

  test('dokunulmamış zincir geçerli', () async {
    expect(await validate(blocks), isA<ChainValid>());
  });

  test('bir yoklama kaydı değiştirilirse → MerkleMismatch @2', () async {
    final tx = List.of(blocks[2].transactions)
      ..[1] = const TestRecord('b-1', 'DEĞİŞTİRİLDİ');
    final result = await validate(
      replaced(2, blocks[2].copyWith(transactions: tx)),
    );
    expect(result, isA<MerkleMismatch>());
    expect((result as ChainBroken).blockIndex, 2);
  });

  test('kayıt silinirse → MerkleMismatch @1', () async {
    final tx = blocks[1].transactions.skip(1).toList();
    final result = await validate(
      replaced(1, blocks[1].copyWith(transactions: tx)),
    );
    expect(result, isA<MerkleMismatch>());
    expect((result as ChainBroken).blockIndex, 1);
  });

  test(
    'kayıt + Merkle kökü değiştirilip hash bırakılırsa → HashMismatch',
    () async {
      final json = blocks[2].toJson();
      final tx = [
        const TestRecord('x', 'sahte'),
        ...blocks[2].transactions.skip(1),
      ];
      json['transactions'] = [for (final t in tx) t.envelope];
      json['merkleRoot'] = MerkleTree.fromRecords(tx).root.hex;
      final forged = Block<TestRecord>.fromJson(json, TestRecord.fromEnvelope);
      final result = await validate(replaced(2, forged));
      expect(result, isA<HashMismatch>());
      expect((result as ChainBroken).blockIndex, 2);
    },
  );

  test(
    'blok tamamen yeniden hesaplanırsa (imzasız) → BadSignature @2',
    () async {
      final forged = Block<TestRecord>(
        index: 2,
        timestamp: blocks[2].timestamp,
        previousHash: blocks[1].hash,
        authorityId: 'hoca-1',
        transactions: records('sahte', 4),
      );
      final result = await validate(replaced(2, forged));
      expect(result, isA<BadSignature>());
      expect((result as ChainBroken).blockIndex, 2);
    },
  );

  test(
    'yetkili bile geçmişi yeniden imzalarsa → sonraki blokta BrokenLink',
    () async {
      final rewritten = Block<TestRecord>(
        index: 2,
        timestamp: blocks[2].timestamp,
        previousHash: blocks[1].hash,
        authorityId: auth.signer.authorityId,
        transactions: records('sahte', 4),
      );
      final signed = rewritten.signedWith(
        await auth.signer.sign(rewritten.hash.bytes),
      );
      final result = await validate(replaced(2, signed));
      expect(result, isA<BrokenLink>());
      expect((result as ChainBroken).blockIndex, 3);
    },
  );

  test('previousHash değiştirilirse → HashMismatch', () async {
    final result = await validate(
      replaced(3, blocks[3].copyWith(previousHash: Hash.ofString('x'))),
    );
    expect(result, isA<HashMismatch>());
  });

  test('blok silinirse → IndexGap @2', () async {
    final result = await validate(List.of(blocks)..removeAt(2));
    expect(result, isA<IndexGap>());
    expect((result as ChainBroken).blockIndex, 2);
  });

  test('imza bozulursa → BadSignature', () async {
    final sig = List.of(blocks[1].signature!)..[0] ^= 0xff;
    final result = await validate(
      replaced(1, blocks[1].copyWith(signature: sig)),
    );
    expect(result, isA<BadSignature>());
  });

  test('sahte genesis → InvalidGenesis', () async {
    final fake = Block<TestRecord>(
      index: 0,
      timestamp: DateTime.utc(2020),
      previousHash: Hash.zero,
      authorityId: 'genesis',
      transactions: const [],
    );
    expect(await validate(replaced(0, fake)), isA<InvalidGenesis>());
  });

  test('sealed ChainValidation: switch eksiksiz (exhaustive)', () async {
    String describe(ChainValidation v) => switch (v) {
      ChainValid(:final length) => 'geçerli: $length',
      InvalidGenesis() => 'genesis',
      UnreadableBlock() => 'okunamıyor',
      IndexGap() => 'eksik blok',
      MerkleMismatch() => 'kayıt değişmiş',
      HashMismatch() => 'başlık değişmiş',
      BrokenLink() => 'bağ kopuk',
      TimestampRegression() => 'zaman',
      UnknownAuthority() => 'yetkisiz',
      BadSignature() => 'imza',
    };
    expect(describe(await validate(blocks)), 'geçerli: 4');
  });
}
