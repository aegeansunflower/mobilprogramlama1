// DART KONUSU: Classes & objects — const constructor, `copyWith`, getter,
// mixin (`with Timestamped`), factory `fromJson`. Class modifiers —
// `final class`. Metadata — `@immutable`.

/// Yoklama oturumu ve QR ile alınmış, henüz bloğa girmemiş katılım.
library;

import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/attendance/domain/attendance_record.dart';
import 'package:sarkisla_yoklama/attendance/domain/attendance_status.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Bir dersin tek bir yoklama oturumu.
@immutable
final class AttendanceSession with Timestamped {
  const AttendanceSession({
    required this.id,
    required this.courseId,
    required this.instructorId,
    required this.startedAt,
    this.lateAfter = const Duration(minutes: 10),
    this.requireLocation = false,
    this.activeNonces = const [],
    this.endedAt,
    this.blockIndex,
  });

  factory AttendanceSession.fromJson(String id, Map<String, Object?> json) =>
      AttendanceSession(
        id: id,
        courseId: json['courseId']! as String,
        instructorId: json['instructorId']! as String,
        startedAt: DateTime.fromMillisecondsSinceEpoch(
          json['startedAt']! as int,
          isUtc: true,
        ),
        lateAfter: Duration(minutes: json['lateAfterMinutes'] as int? ?? 10),
        requireLocation: json['requireLocation'] as bool? ?? false,
        activeNonces: [
          for (final n in json['activeNonces'] as List<Object?>? ?? const [])
            n! as String,
        ],
        endedAt: switch (json['endedAt']) {
          final int ms => DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true),
          _ => null,
        },
        blockIndex: json['blockIndex'] as int?,
      );

  final String id;
  final String courseId;
  final String instructorId;
  final DateTime startedAt;

  /// Bu süreden sonra taranan QR "Geç" sayılır.
  final Duration lateAfter;

  /// Kampüs coğrafi sınırı denetlensin mi?
  final bool requireLocation;

  /// Ekrandaki son iki QR'ın tek kullanımlık değerleri (nonce). Bir öğrenci
  /// yalnızca bunlardan biriyle yoklama verebilir; 15 saniyede bir
  /// yenilendiği için eski ekran görüntüleri işe yaramaz.
  final List<String> activeNonces;

  final DateTime? endedAt;

  /// Oturum kapandığında kayıtların yazıldığı blok.
  final int? blockIndex;

  @override
  DateTime get timestamp => startedAt;

  bool get isOpen => endedAt == null;

  /// [at] anında taranan QR için yoklama durumu.
  AttendanceStatus statusAt(DateTime at) {
    final late = at.difference(startedAt) - lateAfter;
    return late > Duration.zero
        ? Late(late.inMinutes < 1 ? 1 : late.inMinutes)
        : const Present();
  }

  AttendanceSession copyWith({
    List<String>? activeNonces,
    DateTime? endedAt,
    int? blockIndex,
  }) => AttendanceSession(
    id: id,
    courseId: courseId,
    instructorId: instructorId,
    startedAt: startedAt,
    lateAfter: lateAfter,
    requireLocation: requireLocation,
    activeNonces: activeNonces ?? this.activeNonces,
    endedAt: endedAt ?? this.endedAt,
    blockIndex: blockIndex ?? this.blockIndex,
  );

  Map<String, Object?> toJson() => {
    'courseId': courseId,
    'instructorId': instructorId,
    'startedAt': startedAt.millisecondsSinceEpoch,
    'lateAfterMinutes': lateAfter.inMinutes,
    'requireLocation': requireLocation,
    'activeNonces': activeNonces,
    'endedAt': endedAt?.millisecondsSinceEpoch,
    'blockIndex': blockIndex,
  };

  @override
  bool operator ==(Object other) =>
      other is AttendanceSession &&
      other.id == id &&
      other.endedAt == endedAt &&
      other.blockIndex == blockIndex;

  @override
  int get hashCode => Object.hash(id, endedAt, blockIndex);

  @override
  String toString() => 'AttendanceSession($id, ${isOpen ? 'açık' : 'kapalı'})';
}

/// QR ile alınmış ama oturum kapanmadığı için henüz bloğa girmemiş katılım.
@immutable
final class PendingCheckIn {
  const PendingCheckIn({
    required this.record,
    required this.studentName,
    required this.nonce,
  });

  factory PendingCheckIn.fromJson(Map<String, Object?> json) => PendingCheckIn(
    record: AttendanceRecord.fromJson(
      Map<String, Object?>.from(json['record']! as Map),
    ),
    studentName: json['studentName']! as String,
    nonce: json['nonce']! as String,
  );

  /// Bloğa girecek kayıt. İşlem hash'i öğrenciye ilk makbuz olarak
  /// gösterilir.
  final AttendanceRecord record;
  final String studentName;
  final String nonce;

  Hash get transactionHash => record.recordHash;

  Map<String, Object?> toJson() => {
    'record': record.toJson(),
    'studentName': studentName,
    'nonce': nonce,
  };

  @override
  bool operator ==(Object other) =>
      other is PendingCheckIn && other.record.recordId == record.recordId;

  @override
  int get hashCode => record.recordId.hashCode;
}
