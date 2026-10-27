// DART KONUSU: Metadata — `@RoleRestricted`. Classes & objects — callable
// class, records ile özet dönüşü. Class modifiers — `final class`.

/// Oturumu bitirip kayıtları imzalı bir bloğa dönüştürür.
library;

import 'package:sarkisla_yoklama/attendance/domain/attendance_record.dart';
import 'package:sarkisla_yoklama/attendance/domain/attendance_repository.dart';
import 'package:sarkisla_yoklama/attendance/domain/attendance_status.dart';
import 'package:sarkisla_yoklama/auth/domain/app_user.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Oturum kapanış özeti.
typedef EndSessionSummary = ({
  Block<Record> block,
  int present,
  int late,
  int absent,
});

/// Oturumu bitirir:
/// 1. QR ile gelen katılımları alır; durumu oturum saatine göre yeniden
///    hesaplar (öğrenci cihazına güvenilmez).
/// 2. Listede olup gelmeyenler için "Devamsız" kaydı üretir.
/// 3. Kayıtları bloğa dönüştürür, imzalar ve zincire ekler.
/// 4. Oturumu blok numarasıyla kapatır.
final class EndSession {
  const EndSession({
    required this.attendance,
    required this.chain,
    required this.clock,
  });

  final AttendanceRepository attendance;
  final BlockchainRepository<Record> chain;
  final Clock clock;

  @RoleRestricted(Role.instructor)
  Future<Result<EndSessionSummary>> call({
    required String sessionId,
    required Instructor instructor,
    required BlockSigner signer,
  }) async {
    final denied = RoleGuard.ensure(Role.instructor, instructor.role);
    if (denied != null) return Err(denied);

    final session = await attendance.session(sessionId);
    if (session == null || !session.isOpen) {
      return const Err(ValidationFailure('Oturum zaten kapalı.'));
    }
    if (session.instructorId != instructor.uid) {
      return const Err(
        PermissionFailure('Bu oturumu yalnızca açan görevli kapatabilir.'),
      );
    }
    final course = await attendance.course(session.courseId);
    if (course == null) return const Err(ValidationFailure('Ders bulunamadı.'));

    final now = clock.now();
    final checkIns = await attendance.checkIns(sessionId);
    final arrived = {for (final c in checkIns) c.record.studentId};
    final records = <AttendanceRecord>[
      for (final c in checkIns)
        c.record.copyWith(status: session.statusAt(c.record.timestamp)),
      for (final student in await attendance.roster(course))
        if (!arrived.contains(student.uid))
          AttendanceRecord(
            sessionId: session.id,
            courseId: course.id,
            studentId: student.uid,
            studentNumber: student.studentNumber,
            status: const Absent(),
            timestamp: now,
          ),
    ]..sort((a, b) => a.studentNumber.compareTo(b.studentNumber));

    if (records.isEmpty) {
      return const Err(ValidationFailure('Derse kayıtlı öğrenci yok.'));
    }

    final appended = await chain.appendBlock(
      records,
      signer: signer,
      actor: instructor.role,
    );
    final Block<Record> block;
    switch (appended) {
      case Ok(:final value):
        block = value;
      case Err(:final failure):
        return Err(failure);
    }

    final closed = await attendance.closeSession(
      sessionId,
      actor: instructor.role,
      at: now,
      blockIndex: block.index,
    );
    if (closed case Err(:final failure)) return Err(failure);

    int count(bool Function(AttendanceStatus) test) =>
        records.where((r) => test(r.status)).length;
    return Ok((
      block: block,
      present: count((s) => s is Present),
      late: count((s) => s is Late),
      absent: count((s) => s is Absent),
    ));
  }
}
