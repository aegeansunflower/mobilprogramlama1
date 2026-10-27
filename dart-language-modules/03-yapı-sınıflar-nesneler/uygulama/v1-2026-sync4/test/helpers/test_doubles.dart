// Test yardımcıları: basit kayıt türü, sabit saat ve PoA kurulumu.

import 'package:sarkisla_yoklama/blockchain/blockchain.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Testlerde kullanılan en basit zincir kaydı.
final class TestRecord extends Record {
  const TestRecord(this.id, this.value);

  factory TestRecord.fromEnvelope(Map<String, Object?> envelope) {
    final data = Map<String, Object?>.from(envelope['data']! as Map);
    return TestRecord(data['id']! as String, data['value']! as String);
  }

  final String id;
  final String value;

  @override
  String get recordType => 'test';

  @override
  String get recordId => id;

  @override
  Map<String, Object?> toJson() => {'id': id, 'value': value};
}

/// `interface class Clock` yalnızca `implements` ile taklit edilebilir.
final class FixedClock implements Clock {
  FixedClock(this.current);

  DateTime current;

  void advance(Duration d) => current = current.add(d);

  @override
  DateTime now() => current;

  @override
  DateTime call() => current;
}

/// Bilinen tohumla üretilmiş yetkili + dizin + PoA.
Future<
  ({
    Ed25519Signer signer,
    InMemoryAuthorityDirectory directory,
    ProofOfAuthority poa,
  })
>
setUpAuthority({String id = 'hoca-1', int seedByte = 7}) async {
  final signer = await Ed25519Signer.fromSeed(id, List.filled(32, seedByte));
  final directory = InMemoryAuthorityDirectory();
  await directory.register(id, await signer.publicKey());
  return (
    signer: signer,
    directory: directory,
    poa: ProofOfAuthority(directory: directory),
  );
}

List<TestRecord> records(String prefix, int count) => [
  for (var i = 0; i < count; i++) TestRecord('$prefix-$i', 'v$i'),
];

final DateTime t0 = DateTime.utc(2026, 10, 7, 9);
