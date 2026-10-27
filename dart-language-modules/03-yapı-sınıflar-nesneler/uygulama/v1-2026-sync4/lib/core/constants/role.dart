// DART KONUSU: Classes & objects — enhanced enum (const constructor, alanlar,
// getter, static üye).

/// Uygulamadaki iki kullanıcı rolü.
library;

/// Kullanıcı rolü. Rol bazlı yönlendirme ve `@RoleRestricted` denetimi bu
/// enum üzerinden yapılır.
enum Role {
  /// Öğretim görevlisi: oturum başlatır, blok imzalar (yetkili düğüm).
  instructor(firestoreValue: 'instructor', label: 'Öğretim Görevlisi'),

  /// Öğrenci: QR tarar, kendi kayıtlarını doğrular.
  student(firestoreValue: 'student', label: 'Öğrenci');

  const Role({required this.firestoreValue, required this.label});

  /// Firestore `users/{uid}.role` alanındaki karşılığı.
  final String firestoreValue;

  /// Arayüzde gösterilen Türkçe ad.
  final String label;

  /// Firestore değerinden rol üretir; bilinmeyen değerde `null` döner.
  static Role? tryParse(String? value) {
    for (final role in values) {
      if (role.firestoreValue == value) return role;
    }
    return null;
  }
}
