// DART KONUSU: Class modifiers — `sealed class AppUser` (yalnızca iki tür
// kullanıcı olabilir) ve `final class` alt türler. Classes & objects —
// `super` parametreleri, getter, `copyWith`, `operator ==` / `hashCode`,
// `toString`, factory `fromJson`. Metadata — `@immutable`.

/// Oturum açmış kullanıcı modelleri.
library;

import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Uygulama kullanıcısı.
///
/// `sealed` seçildi: router ve ana ekran `switch (user)` ile rol bazlı
/// yönlendirme yapar. Derleyici her iki rolün de ele alındığını garanti eder.
@immutable
sealed class AppUser {
  const AppUser({
    required this.uid,
    required this.displayName,
    required this.email,
  });

  /// Firestore `users/{uid}` belgesinden kullanıcı üretir.
  factory AppUser.fromJson(String uid, Map<String, Object?> json) {
    final role = Role.tryParse(json['role'] as String?);
    final name = json['displayName']! as String;
    final email = json['email']! as String;
    return switch (role) {
      Role.instructor => Instructor(
        uid: uid,
        displayName: name,
        email: email,
        departments: {
          for (final c in (json['departments'] as List<Object?>? ?? const []))
            Department.fromCode(c! as String),
        },
        title: json['title'] as String? ?? 'Öğr. Gör.',
      ),
      Role.student => Student(
        uid: uid,
        displayName: name,
        email: email,
        studentNumber: json['studentNumber']! as String,
        department: Department.fromCode(json['department']! as String),
        boundDeviceId: json['boundDeviceId'] as String?,
      ),
      null => throw FormatException('Bilinmeyen rol', json['role']),
    };
  }

  final String uid;
  final String displayName;
  final String email;

  /// Kullanıcının rolü.
  Role get role => switch (this) {
    Instructor() => Role.instructor,
    Student() => Role.student,
  };

  /// Ad soyadın baş harfleri (avatar için).
  String get initials => displayName
      .split(' ')
      .where((p) => p.isNotEmpty)
      .take(2)
      .map((p) => p[0].toUpperTr)
      .join();

  Map<String, Object?> toJson();

  @override
  bool operator ==(Object other) =>
      other is AppUser && other.uid == uid && other.role == role;

  @override
  int get hashCode => Object.hash(uid, role);
}

/// Öğretim görevlisi: blok imzalayan yetkili.
final class Instructor extends AppUser {
  const Instructor({
    required super.uid,
    required super.displayName,
    required super.email,
    required this.departments,
    this.title = 'Öğr. Gör.',
  });

  /// Ders verdiği bölümler.
  final Set<Department> departments;

  /// Unvan.
  final String title;

  /// Unvanla birlikte tam ad.
  String get formalName => '$title $displayName';

  @override
  Map<String, Object?> toJson() => {
    'role': Role.instructor.firestoreValue,
    'displayName': displayName,
    'email': email,
    'title': title,
    'departments': [for (final d in departments) d.code],
  };

  @override
  String toString() => 'Instructor($uid, $formalName)';
}

/// Öğrenci.
final class Student extends AppUser {
  const Student({
    required super.uid,
    required super.displayName,
    required super.email,
    required this.studentNumber,
    required this.department,
    this.boundDeviceId,
  });

  /// Okul numarası.
  final String studentNumber;

  /// Kayıtlı olduğu bölüm.
  final Department department;

  /// Hesabın eşleştiği cihaz (bir cihaz = bir öğrenci). İlk girişte atanır.
  final String? boundDeviceId;

  Student copyWith({String? boundDeviceId}) => Student(
    uid: uid,
    displayName: displayName,
    email: email,
    studentNumber: studentNumber,
    department: department,
    boundDeviceId: boundDeviceId ?? this.boundDeviceId,
  );

  @override
  Map<String, Object?> toJson() => {
    'role': Role.student.firestoreValue,
    'displayName': displayName,
    'email': email,
    'studentNumber': studentNumber,
    'department': department.code,
    'boundDeviceId': boundDeviceId,
  };

  @override
  String get initials {
    final trimmed = studentNumber.trim();
    if (trimmed.length >= 2) {
      return trimmed.substring(trimmed.length - 2);
    }
    return super.initials;
  }

  @override
  String toString() => 'Student($studentNumber, $displayName)';
}
