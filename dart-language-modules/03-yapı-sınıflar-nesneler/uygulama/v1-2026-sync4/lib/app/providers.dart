// DART KONUSU: Libraries & imports — çoklu barrel import, `show` ile drift
// içinden tek sınıf. Classes & objects — top-level `final` provider'lar,
// closure'lar. Clean Architecture'ın bağımlılık enjeksiyonu katmanı.

/// Uygulama genelindeki bağımlılıklar (Riverpod).
///
/// Sunum katmanı yalnızca arayüzleri (`AuthRepository`,
/// `BlockchainRepository`, `AttendanceRepository`) görür; demo ya da
/// Firebase seçimi yalnızca bu dosyada yapılır.
library;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show FutureProviderFamily;
import 'package:sarkisla_yoklama/app/config.dart';
import 'package:sarkisla_yoklama/app/demo_database.dart';
import 'package:sarkisla_yoklama/app/demo_seed.dart';
import 'package:sarkisla_yoklama/attendance/attendance.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart';
import 'package:sarkisla_yoklama/core/core.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

final clockProvider = Provider<Clock>((ref) => const Clock());

/// Demo modunda anahtarlar bellekte, gerçek modda Keystore/Keychain'de.
final keyStoreProvider = Provider<KeyValueStore>(
  (ref) => ref.watch(appConfigProvider).isDemo
      ? InMemoryKeyValueStore()
      : const SecureKeyValueStore(),
);

final deviceIdentityProvider = Provider<DeviceIdentity>(
  (ref) => SecureDeviceIdentity(ref.watch(keyStoreProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => ref.watch(appConfigProvider).isDemo
      ? DemoAuthRepository(users: DemoSeed.users)
      : FirebaseAuthRepository(),
);

/// Telefonda gerçek Face ID / parmak izi (demo modunda da). Tarayıcıda
/// biyometrik API olmadığı için web'de demo onayı kullanılır.
final biometricProvider = Provider<BiometricAuthenticator>(
  (ref) => kIsWeb
      ? const DemoBiometricAuthenticator()
      : LocalBiometricAuthenticator(),
);

final authorityDirectoryProvider = Provider<AuthorityDirectory>(
  (ref) => ref.watch(appConfigProvider).isDemo
      ? InMemoryAuthorityDirectory()
      : FirestoreAuthorityDirectory(),
);

final _chainDatabaseProvider = Provider<ChainDatabase>((ref) {
  final db = ref.watch(appConfigProvider).isDemo
      // Demo: uzak zincir de bellekte olduğu için yerel kopya da her
      // açılışta sıfırdan başlar.
      ? ChainDatabase(openDemoDatabase())
      : ChainDatabase.onDevice();
  ref.onDispose(db.close);
  return db;
});

final _remoteChainProvider = Provider<RemoteChainSource>(
  (ref) => ref.watch(appConfigProvider).isDemo
      ? InMemoryRemoteChainSource()
      : FirestoreChainSource(),
);

/// Somut depo (kurcalama demosu `simulateTamper` için gerekir).
final localChainProvider = Provider<LocalFirstBlockchainRepository<Record>>(
  (ref) => LocalFirstBlockchainRepository<Record>(
    database: ref.watch(_chainDatabaseProvider),
    remote: ref.watch(_remoteChainProvider),
    consensus: ProofOfAuthority(
      directory: ref.watch(authorityDirectoryProvider),
    ),
    decode: ledgerDecoder,
    clock: ref.watch(clockProvider),
  ),
);

/// Uygulamanın kullandığı soyut zincir deposu.
final chainRepositoryProvider = Provider<BlockchainRepository<Record>>(
  (ref) => ref.watch(localChainProvider),
);

final attendanceRepositoryProvider = Provider<AttendanceRepository>(
  (ref) => ref.watch(appConfigProvider).isDemo
      ? DemoAttendanceRepository(
          courses: DemoSeed.courses,
          students: DemoSeed.students,
        )
      : FirestoreAttendanceRepository(),
);

final locationProvider = Provider<LocationProvider>(
  (ref) => ref.watch(appConfigProvider).isDemo
      // Demo: yerleşkenin ortası.
      ? FixedLocationProvider((
          latitude: GeofencePolicy.sarkislaCampus.latitude,
          longitude: GeofencePolicy.sarkislaCampus.longitude,
        ))
      : const DeviceLocationProvider(),
);

final qrValidatorProvider = Provider<QrTokenValidator>(
  (ref) => QrTokenValidator(
    directory: ref.watch(authorityDirectoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

final checkInProvider = Provider<CheckIn>(
  (ref) => CheckIn(
    repository: ref.watch(attendanceRepositoryProvider),
    validateQr: ref.watch(qrValidatorProvider),
    clock: ref.watch(clockProvider),
    location: ref.watch(locationProvider),
  ),
);

final endSessionProvider = Provider<EndSession>(
  (ref) => EndSession(
    attendance: ref.watch(attendanceRepositoryProvider),
    chain: ref.watch(chainRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

final correctAttendanceProvider = Provider<CorrectAttendance>(
  (ref) => CorrectAttendance(
    chain: ref.watch(chainRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

/// `authorityId` görevlisinin imza anahtarı. Yoksa üretilir ve açık
/// anahtar yetkili dizinine yazılır.
final FutureProviderFamily<Ed25519Signer, String> signerProvider =
    FutureProvider.family((ref, authorityId) async {
      final signer = await Ed25519Signer.loadOrCreate(
        authorityId: authorityId,
        store: ref.watch(keyStoreProvider),
      );
      await ref
          .read(authorityDirectoryProvider)
          .register(authorityId, await signer.publicKey());
      return signer;
    });
