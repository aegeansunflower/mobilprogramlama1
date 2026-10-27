import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart';
import 'package:sarkisla_yoklama/core/core.dart';

import '../helpers/test_doubles.dart';

/// İki "cihaz" (iki öğretim görevlisi) aynı uzak zinciri paylaşır; her biri
/// kendi bellek içi SQLite veritabanını kullanır.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late InMemoryRemoteChainSource remote;
  late InMemoryAuthorityDirectory directory;
  late Ed25519Signer hoca1;
  late Ed25519Signer hoca2;
  final databases = <ChainDatabase>[];

  LocalFirstBlockchainRepository<TestRecord> device() {
    final db = ChainDatabase(NativeDatabase.memory());
    databases.add(db);
    return LocalFirstBlockchainRepository<TestRecord>(
      database: db,
      remote: remote,
      consensus: ProofOfAuthority(directory: directory),
      decode: TestRecord.fromEnvelope,
      clock: FixedClock(t0),
    );
  }

  setUp(() async {
    remote = InMemoryRemoteChainSource();
    final auth = await setUpAuthority();
    directory = auth.directory;
    hoca1 = auth.signer;
    hoca2 = await Ed25519Signer.fromSeed('hoca-2', List.filled(32, 2));
    await directory.register('hoca-2', await hoca2.publicKey());
  });

  tearDown(() async {
    for (final db in databases) {
      await db.close();
    }
    databases.clear();
  });

  test('ilk açılışta genesis veritabanına yazılır', () async {
    final repo = device();
    final blocks = await repo.currentBlocks();
    expect(blocks.single.isGenesis, isTrue);
    expect(await repo.validate(), isA<ChainValid>());
  });

  test(
    'blok ekleme yerel ve uzak zincire yazar; öteki cihaz senkronize olur',
    () async {
      final a = device();
      final b = device();
      final added = await a.appendBlock(
        records('a', 3),
        signer: hoca1,
        actor: Role.instructor,
      );
      expect(added.isOk, isTrue);

      expect(await b.sync(), const Ok(1));
      final onB = await b.currentBlocks();
      expect(onB.last.hash, added.valueOrNull!.hash);
      expect(await b.validate(), isA<ChainValid>());
    },
  );

  test(
    'eşzamanlı ekleme: geride kalan cihaz yeni başa göre yeniden kurar',
    () async {
      final a = device();
      final b = device();
      await a.currentBlocks();
      await b.currentBlocks();

      await a.appendBlock(
        records('a', 2),
        signer: hoca1,
        actor: Role.instructor,
      );
      // b henüz senkronize olmadı ama ekleme sırasında kendisi senkronize olur
      // ve bloğunu a'nın bloğunun üzerine kurar.
      final second = await b.appendBlock(
        records('b', 2),
        signer: hoca2,
        actor: Role.instructor,
      );
      expect(second.valueOrNull!.index, 2);

      await a.sync();
      final onA = await a.currentBlocks();
      final onB = await b.currentBlocks();
      expect(onA.map((x) => x.hash), onB.map((x) => x.hash));
      expect(await a.validate(), isA<ChainValid>());
    },
  );

  test('öğrenci rolü depo üzerinden de blok ekleyemez', () async {
    final result = await device().appendBlock(
      records('a', 1),
      signer: hoca1,
      actor: Role.student,
    );
    expect(result.failureOrNull, isA<PermissionFailure>());
  });

  test('makbuz: kayıt hangi blokta, kanıt geçerli mi', () async {
    final repo = device();
    final txs = records('a', 6);
    await repo.appendBlock(txs, signer: hoca1, actor: Role.instructor);
    final receipt = await repo.receiptFor(txs[4].recordHash);
    expect(receipt, isNotNull);
    expect(receipt!.blockIndex, 1);
    expect(receipt.isValid, isTrue);
    final restored = ChainReceipt.fromJson(receipt.toJson());
    expect(restored.isValid, isTrue);
    expect(await repo.receiptFor(Hash.ofString('yok')), isNull);
  });

  test(
    'veritabanında kayıt değiştirilirse doğrulama bozulan bloğu bulur',
    () async {
      final repo = device();
      for (final p in ['a', 'b', 'c']) {
        await repo.appendBlock(
          records(p, 3),
          signer: hoca1,
          actor: Role.instructor,
        );
      }
      expect(await repo.validate(), isA<ChainValid>());

      await repo.simulateTamper(2, (json) {
        final txs = List<Object?>.from(json['transactions']! as List);
        txs[0] = const TestRecord('b-0', 'DEVAMSIZ→VAR').envelope;
        return {...json, 'transactions': txs};
      });

      final result = await repo.validate();
      expect(result, isA<MerkleMismatch>());
      expect((result as ChainBroken).blockIndex, 2);
    },
  );

  test('bozuk JSON → UnreadableBlock', () async {
    final repo = device();
    await repo.appendBlock(
      records('a', 1),
      signer: hoca1,
      actor: Role.instructor,
    );
    await repo.simulateTamper(1, (json) => {...json, 'hash': 'bozuk'});
    final result = await repo.validate();
    expect(result, isA<UnreadableBlock>());
    expect((result as ChainBroken).blockIndex, 1);
  });

  test('watchBlocks yeni blokları yayınlar', () async {
    final repo = device();
    await repo.currentBlocks();
    final lengths = repo.watchBlocks().map((b) => b.length);
    final expectation = expectLater(lengths, emitsThrough(2));
    await repo.appendBlock(
      records('a', 1),
      signer: hoca1,
      actor: Role.instructor,
    );
    await expectation;
  });
}
