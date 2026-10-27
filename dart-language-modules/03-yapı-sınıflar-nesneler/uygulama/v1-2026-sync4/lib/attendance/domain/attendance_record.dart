// DART KONUSU: Metadata — özel `@OnChainRecord` annotation'ı ve paket
// annotation'ları (`@JsonSerializable`, `@StatusConverter`). Libraries &
// imports — `part` ile json_serializable'ın ürettiği dosya. Classes &
// objects — const / factory constructor, mixin (`with Timestamped`), static
// const, `copyWith`, `toString`. Class modifiers — `final class` (abstract
// `Record`'dan türer).

/// Zincire yazılan yoklama kaydı.
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:sarkisla_yoklama/attendance/domain/attendance_status.dart';
import 'package:sarkisla_yoklama/attendance/domain/json_converters.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart' show Record;
import 'package:sarkisla_yoklama/core/core.dart';

part 'attendance_record.g.dart';

/// Bir öğrencinin bir oturumdaki yoklama kaydı (blok işlemi).
@OnChainRecord(type: AttendanceRecord.kind)
@JsonSerializable()
@StatusConverter()
@EpochMillisConverter()
final class AttendanceRecord extends Record with Timestamped {
  const AttendanceRecord({
    required this.sessionId,
    required this.courseId,
    required this.studentId,
    required this.studentNumber,
    required this.status,
    required this.timestamp,
    this.deviceId,
  });

  /// json_serializable'ın ürettiği `_$AttendanceRecordFromJson` kullanılır.
  factory AttendanceRecord.fromJson(Map<String, Object?> json) =>
      _$AttendanceRecordFromJson(json);

  /// Zincirdeki kayıt türü adı.
  static const String kind = 'attendance';

  final String sessionId;
  final String courseId;
  final String studentId;
  final String studentNumber;
  final AttendanceStatus status;

  /// Yoklamanın alındığı an (QR tarama ya da oturum kapanışı).
  @override
  final DateTime timestamp;

  /// Yoklamanın alındığı cihaz (devamsızlarda `null`).
  final String? deviceId;

  @override
  String get recordType => kind;

  @override
  String get recordId => '$sessionId:$studentId';

  @override
  Map<String, Object?> toJson() => _$AttendanceRecordToJson(this);

  AttendanceRecord copyWith({AttendanceStatus? status, DateTime? timestamp}) =>
      AttendanceRecord(
        sessionId: sessionId,
        courseId: courseId,
        studentId: studentId,
        studentNumber: studentNumber,
        status: status ?? this.status,
        timestamp: timestamp ?? this.timestamp,
        deviceId: deviceId,
      );

  @override
  String toString() => 'AttendanceRecord($studentNumber @ $sessionId: $status)';
}
