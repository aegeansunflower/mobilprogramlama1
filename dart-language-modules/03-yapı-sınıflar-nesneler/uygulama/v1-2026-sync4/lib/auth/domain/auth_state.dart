// DART KONUSU: Class modifiers — `sealed class AuthState` (kapalı durum
// makinesi). Classes & objects — const constructor'lar, getter.

/// Oturum durumu.
library;

import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/auth/domain/app_user.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Kimlik doğrulama akışının durumları:
///
/// `SignedOut → Authenticating → AwaitingBiometric → SignedIn`
///
/// `sealed` seçildi: router guard'ı ve giriş ekranı her durumu `switch` ile
/// ele alır. Yeni bir durum eklenirse unutulan yerler derleme hatası verir.
@immutable
sealed class AuthState {
  const AuthState();

  /// Oturum tamamen açık mı? (Şifre + biyometrik)
  bool get isSignedIn => this is SignedIn;

  /// Varsa kullanıcı.
  AppUser? get user => switch (this) {
    AwaitingBiometric(:final user) || SignedIn(:final user) => user,
    SignedOut() || Authenticating() || AuthError() => null,
  };
}

/// Oturum kapalı.
final class SignedOut extends AuthState {
  const SignedOut();
}

/// Şifre doğrulanıyor.
final class Authenticating extends AuthState {
  const Authenticating(this.role);

  final Role role;
}

/// Şifre doğru; biyometrik doğrulama bekleniyor.
final class AwaitingBiometric extends AuthState {
  const AwaitingBiometric(this.user, {this.failure, this.inProgress = false});

  @override
  final AppUser user;

  /// Son biyometrik denemenin hatası (tekrar denenebilir).
  final Failure? failure;

  /// Sistem biyometrik penceresi açık mı?
  final bool inProgress;
}

/// Oturum açık.
final class SignedIn extends AuthState {
  const SignedIn(this.user);

  @override
  final AppUser user;
}

/// Giriş hatası.
final class AuthError extends AuthState {
  const AuthError(this.failure, {required this.role});

  final Failure failure;
  final Role role;
}
