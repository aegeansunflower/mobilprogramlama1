// DART KONUSU: Metadata — `JsonConverter` sınıfları annotation olarak
// kullanılır (`@StatusConverter()`). Classes & objects — const constructor,
// generic arayüz uygulama.

/// json_serializable için özel dönüştürücüler.
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:sarkisla_yoklama/attendance/domain/attendance_status.dart';

/// `AttendanceStatus` ↔ JSON.
final class StatusConverter
    implements JsonConverter<AttendanceStatus, Map<String, Object?>> {
  const StatusConverter();

  @override
  AttendanceStatus fromJson(Map<String, Object?> json) =>
      AttendanceStatus.fromJson(json);

  @override
  Map<String, Object?> toJson(AttendanceStatus status) => status.toJson();
}

/// `DateTime` ↔ UTC milisaniye. ISO metin yerine sayı kullanılır; böylece
/// farklı saat dilimlerindeki cihazlar aynı hash'i üretir.
final class EpochMillisConverter implements JsonConverter<DateTime, int> {
  const EpochMillisConverter();

  @override
  DateTime fromJson(int json) =>
      DateTime.fromMillisecondsSinceEpoch(json, isUtc: true);

  @override
  int toJson(DateTime object) => object.toUtc().millisecondsSinceEpoch;
}
