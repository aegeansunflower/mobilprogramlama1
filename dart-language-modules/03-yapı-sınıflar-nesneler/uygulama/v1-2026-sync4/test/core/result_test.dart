import 'package:flutter_test/flutter_test.dart';
import 'package:sarkisla_yoklama/core/core.dart';

void main() {
  group('Result<T>', () {
    test('redirecting factory constructor’lar doğru alt türü üretir', () {
      expect(const Result.ok(1), isA<Ok<int>>());
      expect(const Result<int>.err(ValidationFailure('x')), isA<Err<int>>());
    });

    test('map / fold / valueOrNull', () {
      const ok = Result.ok(2);
      expect(ok.map((v) => v * 10), const Ok(20));
      expect(ok.fold((v) => 'ok $v', (f) => 'err'), 'ok 2');

      const Result<int> err = Err(AuthFailure('şifre'));
      expect(err.map((v) => v * 10).failureOrNull, isA<AuthFailure>());
      expect(err.valueOrNull, isNull);
      expect(err.isOk, isFalse);
    });

    test('then zincirlemesi hatada durur', () async {
      final r = await const Result.ok(1).then((v) async => Result.ok(v + 1));
      expect(r, const Ok(2));
      final e = await const Result<int>.err(NetworkFailure('ağ'))
          .then((v) async => Result.ok(v + 1));
      expect(e.failureOrNull, isA<NetworkFailure>());
    });

    test('sealed Failure: switch eksiksiz', () {
      String kind(Failure f) => switch (f) {
        AuthFailure() => 'auth',
        PermissionFailure() => 'izin',
        ValidationFailure() => 'doğrulama',
        ChainFailure() => 'zincir',
        StorageFailure() => 'depo',
        NetworkFailure() => 'ağ',
      };
      expect(kind(const ChainFailure('x')), 'zincir');
    });
  });

  group('Extension’lar ve RoleGuard', () {
    test('StringX', () {
      expect('0123456789abcdef0123'.shortened(), '01234567…ef0123');
      expect('kısa'.shortened(), 'kısa');
      expect('202612345'.isValidStudentNumber, isTrue);
      expect('12ab'.isValidStudentNumber, isFalse);
      expect('0aff'.hexToBytes, [0x0a, 0xff]);
      expect([0x0a, 0xff].toHex, '0aff');
    });

    test('DateTimeX.isWithin', () {
      final t = DateTime.utc(2026);
      expect(
        t.isWithin(
          const Duration(seconds: 15),
          t.add(const Duration(seconds: 10)),
        ),
        isTrue,
      );
      expect(
        t.isWithin(
          const Duration(seconds: 15),
          t.add(const Duration(seconds: 16)),
        ),
        isFalse,
      );
    });

    test('RoleGuard', () {
      expect(RoleGuard.ensure(Role.instructor, Role.instructor), isNull);
      expect(
        RoleGuard.ensure(Role.instructor, Role.student),
        isA<PermissionFailure>(),
      );
      expect(RoleGuard.ensure(Role.instructor, null), isA<PermissionFailure>());
    });

    test('mixin class EventEmitter tek başına sınıf olarak da kullanılır', () {
      final emitter = EventEmitter<String>();
      final seen = <String>[];
      final cancel = emitter.listen(seen.add);
      emitter.emit('blok');
      cancel();
      emitter.emit('görülmez');
      expect(seen, ['blok']);
      expect(emitter.listenerCount, 0);
    });

    test('Department / Role enum', () {
      expect(Department.fromCode('YZM'), Department.artificialIntelligence);
      expect(() => Department.fromCode('??'), throwsArgumentError);
      expect(Role.tryParse('student'), Role.student);
      expect(Role.tryParse('admin'), isNull);
    });
  });
}
