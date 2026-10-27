// DART KONUSU: Classes & objects — const constructor + initializer list
// (`assert`), getter, factory `fromJson`, `operator ==` / `hashCode`,
// `toString`. Class modifiers — `final class`. Metadata — `@immutable`.

/// Ders modeli.
library;

import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Bir bölümdeki ders.
@immutable
final class Course {
  const Course({
    required this.id,
    required this.code,
    required this.name,
    required this.department,
    required this.instructorId,
    required this.studentIds,
    this.plannedSessions = 14,
    this.absenceLimitRatio = 0.3,
  }) : assert(plannedSessions > 0, 'Planlanan oturum sayısı pozitif olmalı'),
       assert(
         absenceLimitRatio >= 0 && absenceLimitRatio <= 1,
         'Devamsızlık oranı 0–1 arasında olmalı',
       );

  factory Course.fromJson(String id, Map<String, Object?> json) => Course(
    id: id,
    code: json['code']! as String,
    name: json['name']! as String,
    department: Department.fromCode(json['department']! as String),
    instructorId: json['instructorId']! as String,
    studentIds: [
      for (final s in json['studentIds']! as List<Object?>) s! as String,
    ],
    plannedSessions: json['plannedSessions'] as int? ?? 14,
    absenceLimitRatio: (json['absenceLimitRatio'] as num?)?.toDouble() ?? 0.3,
  );

  final String id;

  /// Ders kodu (ör. `BST205`).
  final String code;
  final String name;
  final Department department;
  final String instructorId;

  /// Derse kayıtlı öğrencilerin uid'leri.
  final List<String> studentIds;

  /// Dönem boyunca planlanan oturum sayısı.
  final int plannedSessions;

  /// İzin verilen en fazla devamsızlık oranı (YÖK: %30).
  final double absenceLimitRatio;

  /// İzin verilen en fazla devamsız oturum sayısı.
  int get maxAbsences => (plannedSessions * absenceLimitRatio).floor();

  Map<String, Object?> toJson() => {
    'code': code,
    'name': name,
    'department': department.code,
    'instructorId': instructorId,
    'studentIds': studentIds,
    'plannedSessions': plannedSessions,
    'absenceLimitRatio': absenceLimitRatio,
  };

  @override
  bool operator ==(Object other) => other is Course && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Course($code $name)';
}
