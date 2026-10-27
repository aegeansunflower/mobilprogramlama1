// DART KONUSU: Libraries & imports — `show` ile yalnızca kullanılan
// sınıflar. Class modifiers — `final class`.

/// `local_auth` tabanlı biyometrik doğrulama.
library;

import 'package:local_auth/local_auth.dart'
    show LocalAuthException, LocalAuthentication;
import 'package:sarkisla_yoklama/auth/domain/auth_services.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Parmak izi / yüz tanıma. Biyometrik kayıtlı değilse cihaz PIN'ine düşer
/// (`biometricOnly: false`).
final class LocalBiometricAuthenticator implements BiometricAuthenticator {
  LocalBiometricAuthenticator([LocalAuthentication? auth])
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  /// Cihazda ekran kilidi (biyometrik ya da PIN) tanımlı mı? Eklenti
  /// bulunamazsa (ör. masaüstü) `false`.
  @override
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported();
    } on Exception {
      return false;
    }
  }

  @override
  Future<Result<void>> authenticate(String reason) async {
    try {
      final ok = await _auth.authenticate(localizedReason: reason);
      return ok
          ? const Ok(null)
          : const Err(AuthFailure('Biyometrik doğrulama iptal edildi.'));
    } on LocalAuthException catch (e) {
      return Err(AuthFailure('Biyometrik doğrulama başarısız.', cause: e));
    }
  }
}

/// Demo modunda biyometrik adımı kısa bir gecikmeyle onaylar.
final class DemoBiometricAuthenticator implements BiometricAuthenticator {
  const DemoBiometricAuthenticator();

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<Result<void>> authenticate(String reason) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return const Ok(null);
  }
}
