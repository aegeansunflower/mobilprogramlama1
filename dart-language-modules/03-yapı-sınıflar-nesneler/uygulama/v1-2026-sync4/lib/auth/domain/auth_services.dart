// DART KONUSU: Class modifiers — `abstract interface class` sözleşmeleri.
// Metadata — `///` dokümantasyon yorumları.

/// Kimlik doğrulama sözleşmeleri.
library;

import 'package:sarkisla_yoklama/auth/domain/app_user.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Kullanıcı hesabı işlemleri (Firebase Auth veya demo).
abstract interface class AuthRepository {
  /// Öğretim görevlisi girişi: e-posta + şifre.
  Future<Result<Instructor>> signInInstructor({
    required String email,
    required String password,
  });

  /// Öğrenci girişi: okul numarası + şifre. [deviceId] hesabın eşleştiği
  /// cihazla karşılaştırılır; hesap henüz eşleşmemişse bu cihaza bağlanır.
  Future<Result<Student>> signInStudent({
    required String studentNumber,
    required String password,
    required String deviceId,
  });

  /// Oturumu kapatır.
  Future<void> signOut();
}

/// Parmak izi / yüz tanıma.
abstract interface class BiometricAuthenticator {
  /// Cihazda biyometrik doğrulama kullanılabilir mi?
  Future<bool> isAvailable();

  /// Kullanıcıdan biyometrik doğrulama ister.
  Future<Result<void>> authenticate(String reason);
}

/// Bu kurulumun kalıcı cihaz kimliği.
abstract interface class DeviceIdentity {
  /// Uygulama ilk açıldığında üretilip güvenli depoda saklanan kimlik.
  Future<String> deviceId();

  /// Arayüzde gösterilecek cihaz adı (ör. "Samsung SM-A546").
  Future<String> deviceLabel();
}
