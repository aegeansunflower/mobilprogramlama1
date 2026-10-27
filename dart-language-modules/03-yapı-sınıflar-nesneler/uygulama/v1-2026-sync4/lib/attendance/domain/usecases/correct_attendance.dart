// DART KONUSU: Metadata — `@RoleRestricted`. Classes & objects — callable
// class. Class modifiers — `final class`.

/// Geçmiş bir yoklamayı düzeltme bloğuyla düzeltir.
library;

import 'package:sarkisla_yoklama/attendance/domain/attendance_ledger.dart';
import 'package:sarkisla_yoklama/attendance/domain/attendance_status.dart';
import 'package:sarkisla_yoklama/attendance/domain/correction_record.dart';
import 'package:sarkisla_yoklama/auth/domain/app_user.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Düzeltme hiçbir zaman eski kaydı silmez veya değiştirmez. Eski kaydın
/// hash'ine işaret eden bir `CorrectionRecord` yeni bir blok olarak eklenir;
/// zincir geçmişi aynen korunur.
final class CorrectAttendance {
  const CorrectAttendance({required this.chain, required this.clock});

  final BlockchainRepository<Record> chain;
  final Clock clock;

  @RoleRestricted(Role.instructor)
  Future<Result<CorrectionRecord>> call({
    required EffectiveAttendance target,
    required AttendanceStatus newStatus,
    required String reason,
    required Instructor instructor,
    required BlockSigner signer,
  }) async {
    final denied = RoleGuard.ensure(Role.instructor, instructor.role);
    if (denied != null) return Err(denied);
    if (reason.trim().length < 5) {
      return const Err(
        ValidationFailure('Düzeltme gerekçesi en az 5 karakter olmalı.'),
      );
    }
    if (newStatus == target.status) {
      return const Err(ValidationFailure('Durum zaten bu şekilde.'));
    }
    final correction = CorrectionRecord(
      correctsRecordHash: target.recordHash.hex,
      sessionId: target.sessionId,
      courseId: target.original.courseId,
      studentId: target.studentId,
      newStatus: newStatus,
      reason: reason.trim(),
      correctedBy: instructor.uid,
      timestamp: clock.now(),
    );
    final appended = await chain.appendBlock(
      [correction],
      signer: signer,
      actor: instructor.role,
    );
    return appended.map((_) => correction);
  }
}
