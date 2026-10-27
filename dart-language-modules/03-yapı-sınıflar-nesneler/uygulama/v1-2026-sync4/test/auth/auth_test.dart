import 'package:flutter_test/flutter_test.dart';
import 'package:sarkisla_yoklama/app/demo_seed.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/core/core.dart';

void main() {
  late DemoAuthRepository repo;

  setUp(() {
    repo = DemoAuthRepository(users: DemoSeed.users, latency: Duration.zero);
  });

  group('Öğretim görevlisi girişi', () {
    test('doğru e-posta ve şifre', () async {
      final r = await repo.signInInstructor(
        email: ' Adem.Karakas@sarkisla.edu.tr ',
        password: 'demo1234',
      );
      expect(r.valueOrNull?.uid, 'hoca-adem');
      expect(r.valueOrNull?.role, Role.instructor);
    });

    test('yanlış şifre', () async {
      final r = await repo.signInInstructor(
        email: 'adem.karakas@sarkisla.edu.tr',
        password: 'x',
      );
      expect(r.failureOrNull, isA<AuthFailure>());
    });

    test('öğrenci e-postasıyla görevli girişi yapılamaz', () async {
      final r = await repo.signInInstructor(
        email: '2024481004@ogrenci.sarkisla.edu.tr',
        password: 'demo1234',
      );
      expect(r.isOk, isFalse);
    });
  });

  group('Öğrenci girişi ve cihaz eşleştirme', () {
    test('ilk giriş hesabı cihaza bağlar', () async {
      final r = await repo.signInStudent(
        studentNumber: '2024481004',
        password: 'demo1234',
        deviceId: 'cihaz-A',
      );
      expect(r.valueOrNull?.boundDeviceId, 'cihaz-A');
    });

    test('bir cihaz = bir öğrenci: başka cihazdan giriş reddedilir', () async {
      await repo.signInStudent(
        studentNumber: '2024481004',
        password: 'demo1234',
        deviceId: 'cihaz-A',
      );
      final again = await repo.signInStudent(
        studentNumber: '2024481004',
        password: 'demo1234',
        deviceId: 'cihaz-B',
      );
      expect(again.failureOrNull?.message, contains('başka bir cihaza'));
      final same = await repo.signInStudent(
        studentNumber: '2024481004',
        password: 'demo1234',
        deviceId: 'cihaz-A',
      );
      expect(same.isOk, isTrue);
    });
  });

  group('AppUser (sealed)', () {
    test('JSON gidiş-dönüşü ve rol', () {
      for (final user in DemoSeed.users) {
        final back = AppUser.fromJson(user.uid, user.toJson());
        expect(back, user);
        expect(back.role, user.role);
      }
    });

    test('AuthState.user ve isSignedIn', () {
      const user = DemoSeed.ademHoca;
      expect(const SignedOut().user, isNull);
      expect(const AwaitingBiometric(user).isSignedIn, isFalse);
      expect(const SignedIn(user).user, user);
      expect(user.initials, 'AK');
      expect(DemoSeed.bstStudents.first.initials, '04');
    });
  });

  test('cihaz kimliği kalıcıdır', () async {
    final store = InMemoryKeyValueStore();
    final a = await SecureDeviceIdentity(store).deviceId();
    final b = await SecureDeviceIdentity(store).deviceId();
    expect(a, b);
    expect(a, hasLength(36));
  });
}
