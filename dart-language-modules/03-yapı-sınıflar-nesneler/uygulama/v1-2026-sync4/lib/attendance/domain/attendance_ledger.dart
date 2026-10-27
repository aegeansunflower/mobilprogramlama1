// DART KONUSU: Classes & objects — extension methods (`Iterable<Record>`
// üzerine), records, getter'lar, const constructor. Class modifiers —
// `final class`. Pattern matching ile tür ayrımı.

/// Zincirdeki kayıtlardan devam istatistiği.
library;

import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/attendance/domain/attendance_record.dart';
import 'package:sarkisla_yoklama/attendance/domain/attendance_status.dart';
import 'package:sarkisla_yoklama/attendance/domain/correction_record.dart';
import 'package:sarkisla_yoklama/attendance/domain/course.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart' show Record;
import 'package:sarkisla_yoklama/core/core.dart';

/// Bir öğrencinin bir oturumdaki geçerli kaydı (düzeltmeler uygulanmış).
@immutable
final class EffectiveAttendance {
  const EffectiveAttendance({
    required this.original,
    required this.status,
    this.correction,
  });

  /// Zincirdeki asıl kayıt.
  final AttendanceRecord original;

  /// Geçerli durum (varsa son düzeltme).
  final AttendanceStatus status;

  /// Uygulanan son düzeltme.
  final CorrectionRecord? correction;

  bool get isCorrected => correction != null;
  String get sessionId => original.sessionId;
  String get studentId => original.studentId;
  Hash get recordHash => original.recordHash;
}

/// Öğrencinin bir dersteki devam özeti.
@immutable
final class AttendanceSummary {
  const AttendanceSummary({
    required this.course,
    required this.present,
    required this.late,
    required this.absent,
    required this.excused,
  });

  final Course course;
  final int present;
  final int late;
  final int absent;
  final int excused;

  int get held => present + late + absent + excused;

  /// Katılım oranı (0–1). Hiç oturum yoksa 1.
  double get rate => held == 0 ? 1 : (held - absent) / held;

  /// Devamsızlık hakkından kalan.
  int get remainingAbsences => course.maxAbsences - absent;

  /// Sınırı aştı mı? (Devamsızlıktan kalma)
  bool get isOverLimit => absent > course.maxAbsences;

  /// Son bir hak kaldı mı? (Uyarı gösterilir)
  bool get isNearLimit => !isOverLimit && remainingAbsences <= 1;
}

/// Zincir kayıtları üzerinde yoklama sorguları.
extension AttendanceLedgerX on Iterable<Record> {
  /// [courseId] dersinin düzeltmeler uygulanmış kayıtları.
  List<EffectiveAttendance> effectiveFor(String courseId) {
    final originals = <String, AttendanceRecord>{};
    final corrections = <String, CorrectionRecord>{};
    for (final record in this) {
      switch (record) {
        case AttendanceRecord(courseId: final c) when c == courseId:
          originals[record.recordHash.hex] = record;
        case CorrectionRecord(courseId: final c) when c == courseId:
          // Zincir sırası = zaman sırası; sonraki düzeltme öncekini ezer.
          corrections[record.correctsRecordHash] = record;
        default:
          break;
      }
    }
    return [
      for (final MapEntry(key: hash, value: original) in originals.entries)
        EffectiveAttendance(
          original: original,
          status: corrections[hash]?.newStatus ?? original.status,
          correction: corrections[hash],
        ),
    ];
  }

  /// [studentId] öğrencisinin [course] dersindeki özeti.
  AttendanceSummary summaryFor(Course course, String studentId) {
    var present = 0;
    var late = 0;
    var absent = 0;
    var excused = 0;
    for (final e in effectiveFor(course.id)) {
      if (e.studentId != studentId) continue;
      switch (e.status) {
        case Present():
          present++;
        case Late():
          late++;
        case Absent():
          absent++;
        case Excused():
          excused++;
      }
    }
    return AttendanceSummary(
      course: course,
      present: present,
      late: late,
      absent: absent,
      excused: excused,
    );
  }

  /// Kaydı oturum + öğrenciyle bulur.
  AttendanceRecord? attendanceOf(String sessionId, String studentId) {
    for (final record in this) {
      if (record case AttendanceRecord(sessionId: final s, studentId: final st)
          when s == sessionId && st == studentId) {
        return record;
      }
    }
    return null;
  }
}
