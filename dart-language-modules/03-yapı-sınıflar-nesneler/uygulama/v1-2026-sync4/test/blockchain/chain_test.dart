import 'package:flutter_test/flutter_test.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart';
import 'package:sarkisla_yoklama/core/core.dart';

import '../helpers/test_doubles.dart';

void main() {
  group('Genesis bloğu', () {
    test('deterministiktir: her cihazda aynı hash', () {
      final a = Block<TestRecord>.genesis();
      final b = Block<TestRecord>.genesis();
      expect(a.hash, b.hash);
      expect(a.index, 0);
      expect(a.previousHash, Hash.zero);
      expect(a.transactions, isEmpty);
      expect(a.isSigned, isFalse);
    });

    test('yalnızca genesis içeren zincir geçerlidir', () async {
      final auth = await setUpAuthority();
      final chain = Blockchain<TestRecord>.genesis(consensus: auth.poa);
      final result = await chain.validate();
      expect(result, isA<ChainValid>());
      expect((result as ChainValid).length, 1);
    });
  });

  group('Zincir bütünlüğü', () {
    late ({
      Ed25519Signer signer,
      InMemoryAuthorityDirectory directory,
      ProofOfAuthority poa,
    })
    auth;
    late Blockchain<TestRecord> chain;

    setUp(() async {
      auth = await setUpAuthority();
      chain = Blockchain<TestRecord>.genesis(consensus: auth.poa);
    });

    Future<Block<TestRecord>> append(
      List<TestRecord> txs, {
      DateTime? at,
    }) async {
      final result = await chain.append(
        txs,
        signer: auth.signer,
        actor: Role.instructor,
        at: at ?? t0,
      );
      return result.valueOrNull!;
    }

    test('bloklar öncekinin hash’ine bağlanır ve imzalıdır', () async {
      final b1 = await append(records('a', 3));
      final b2 = await append(records('b', 2));
      expect(b1.previousHash, chain.blocks[0].hash);
      expect(b2.previousHash, b1.hash);
      expect(b2.index, 2);
      expect(b1.isSigned && b2.isSigned, isTrue);
      expect(await chain.validate(), isA<ChainValid>());
    });

    test(
      'blok eklenince dinleyiciler haberdar edilir (EventEmitter)',
      () async {
        final seen = <int>[];
        final cancel = chain.listen((b) => seen.add(b.index));
        await append(records('a', 1));
        cancel();
        await append(records('b', 1));
        expect(seen, [1]);
      },
    );

    test('JSON gidiş-dönüşü hash’i ve imzayı korur', () async {
      final b1 = await append(records('a', 4));
      final decoded = Block<TestRecord>.fromJson(
        b1.toJson(),
        TestRecord.fromEnvelope,
      );
      expect(decoded, b1);
      expect(decoded.computeHash(), b1.hash);
      expect(decoded.signature, b1.signature);
      expect(decoded.recomputeMerkleRoot(), b1.merkleRoot);
    });

    test('makbuz: kayıt Merkle kanıtıyla blok köküne ulaşır', () async {
      final txs = records('a', 5);
      final block = await append(txs);
      final receipt = chain.receiptFor(txs[3].recordHash)!;
      expect(receipt.block, block);
      expect(
        MerkleTree.verify(txs[3].recordHash, receipt.proof, block.merkleRoot),
        isTrue,
      );
      expect(chain.receiptFor(Hash.ofString('yok')), isNull);
    });

    test('aynı kayıt ikinci kez zincire yazılamaz', () async {
      final txs = records('a', 2);
      await append(txs);
      final again = await chain.append(
        [txs.first],
        signer: auth.signer,
        actor: Role.instructor,
        at: t0,
      );
      expect(again.failureOrNull, isA<ValidationFailure>());
    });

    test('boş blok eklenemez', () async {
      final result = await chain.append(
        const [],
        signer: auth.signer,
        actor: Role.instructor,
        at: t0,
      );
      expect(result.failureOrNull, isA<ValidationFailure>());
    });

    test('saat geri giderse blok zamanı geriye düşmez', () async {
      final b1 = await append(records('a', 1), at: t0);
      final b2 = await append(
        records('b', 1),
        at: t0.subtract(const Duration(hours: 1)),
      );
      expect(b2.timestamp, b1.timestamp);
      expect(await chain.validate(), isA<ChainValid>());
    });
  });

  group('Proof of Authority ve roller', () {
    test('@RoleRestricted: öğrenci blok ekleyemez', () async {
      final auth = await setUpAuthority();
      final chain = Blockchain<TestRecord>.genesis(consensus: auth.poa);
      final result = await chain.append(
        records('a', 1),
        signer: auth.signer,
        actor: Role.student,
        at: t0,
      );
      expect(result.failureOrNull, isA<PermissionFailure>());
      expect(chain.length, 1);
    });

    test('dizinde olmayan yetkilinin bloğu reddedilir', () async {
      final auth = await setUpAuthority();
      final intruder = await Ed25519Signer.fromSeed(
        'sahte',
        List.filled(32, 9),
      );
      final chain = Blockchain<TestRecord>.genesis(consensus: auth.poa);
      final result = await chain.append(
        records('a', 1),
        signer: intruder,
        actor: Role.instructor,
        at: t0,
      );
      expect(result.failureOrNull, isA<ChainFailure>());
      expect(chain.length, 1);
    });

    test('başkasının anahtarıyla imzalanan blok reddedilir', () async {
      final auth = await setUpAuthority();
      // Kimliği "hoca-1" diyen ama farklı anahtarı olan imzalayıcı.
      final impostor = await Ed25519Signer.fromSeed(
        'hoca-1',
        List.filled(32, 42),
      );
      final chain = Blockchain<TestRecord>.genesis(consensus: auth.poa);
      final result = await chain.append(
        records('a', 1),
        signer: impostor,
        actor: Role.instructor,
        at: t0,
      );
      expect(result.failureOrNull?.message, contains('imzası'));
    });

    test('iki farklı yetkili aynı zincire blok ekleyebilir', () async {
      final a = await setUpAuthority();
      final b = await Ed25519Signer.fromSeed('hoca-2', List.filled(32, 3));
      await a.directory.register('hoca-2', await b.publicKey());
      final chain = Blockchain<TestRecord>.genesis(consensus: a.poa);
      await chain.append(
        records('a', 1),
        signer: a.signer,
        actor: Role.instructor,
        at: t0,
      );
      await chain.append(
        records('b', 1),
        signer: b,
        actor: Role.instructor,
        at: t0,
      );
      expect(await chain.validate(), isA<ChainValid>());
      expect(chain.blocks.map((x) => x.authorityId), [
        'genesis',
        'hoca-1',
        'hoca-2',
      ]);
    });

    test('anahtar depoda saklanır ve yeniden yüklenir', () async {
      final store = InMemoryKeyValueStore();
      final first = await Ed25519Signer.loadOrCreate(
        authorityId: 'hoca-9',
        store: store,
      );
      final again = await Ed25519Signer.loadOrCreate(
        authorityId: 'hoca-9',
        store: store,
      );
      expect(await again.publicKey(), await first.publicKey());
      expect(await store.read(Ed25519Signer.storageKey('hoca-9')), isNotNull);
    });
  });
}
