// DART KONUSU: Class modifiers — `sealed class` (kapalı hata hiyerarşisi) ve
// `final class` alt türler. Classes & objects — const constructor, toString.

/// Uygulama genelindeki hata türleri.
library;

import 'package:meta/meta.dart';

/// Tüm hataların ortak üst türü.
///
/// `sealed` seçildi: alt türler yalnızca bu dosyada tanımlanabilir, böylece
/// arayüzdeki `switch (failure)` ifadeleri derleyici tarafından *exhaustive*
/// (eksiksiz) denetlenir. Yeni bir hata türü eklenince eksik dallar derleme
/// hatası verir.
@immutable
sealed class Failure {
  const Failure(this.message, {this.cause});

  /// Kullanıcıya gösterilebilecek Türkçe açıklama.
  final String message;

  /// Altta yatan istisna (günlükleme için).
  final Object? cause;

  @override
  String toString() => 'Failure($message)';
}

/// Kimlik doğrulama hataları (yanlış şifre, biyometrik başarısız …).
/// `final`: hata türleri daha fazla alt sınıflanmaz.
final class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.cause});
}

/// Rol yetkisi olmayan işlem denemesi.
final class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.cause});
}

/// Girdi veya iş kuralı ihlali (süresi dolmuş QR, mükerrer yoklama …).
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.cause});
}

/// Zincir bütünlüğü veya konsensüs hatası.
final class ChainFailure extends Failure {
  const ChainFailure(super.message, {super.cause});
}

/// Yerel depolama hatası.
final class StorageFailure extends Failure {
  const StorageFailure(super.message, {super.cause});
}

/// Ağ / Firebase hatası.
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.cause});
}
