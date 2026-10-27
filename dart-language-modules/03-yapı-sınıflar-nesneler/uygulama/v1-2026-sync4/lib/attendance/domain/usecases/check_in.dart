// DART KONUSU: Classes & objects — callable class (`checkIn(...)`), const
// constructor, private yardımcı. Class modifiers — `final class`.

/// Öğrencinin QR tarayarak yoklama vermesi.
library;

import 'package:sarkisla_yoklama/attendance/domain/attendance_record.dart';
import 'package:sarkisla_yoklama/attendance/domain/attendance_repository.dart';
import 'package:sarkisla_yoklama/attendance/domain/attendance_session.dart';
import 'package:sarkisla_yoklama/attendance/domain/geofence.dart';
import 'package:sarkisla_yoklama/attendance/domain/qr_token.dart';
import 'package:sarkisla_yoklama/auth/domain/app_user.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Hile önleme kurallarının hepsini sırayla uygular:
///
/// 1. QR biçimi, imzası ve 15 sn tazeliği ([QrTokenValidator]).
/// 2. Cihaz eşleşmesi (bir cihaz = bir öğrenci).
/// 3. Oturum açık mı, öğrenci derse kayıtlı mı?
/// 4. İsteğe bağlı kampüs coğrafi sınırı.
/// 5. Depo: nonce hâlâ geçerli mi, öğrenci bu oturumda zaten var mı?
final class CheckIn {
  const CheckIn({
    required this.repository,
    required this.validateQr,
    required this.clock,
    this.geofence = GeofencePolicy.sarkislaCampus,
    this.location,
  });

  final AttendanceRepository repository;
  final QrTokenValidator validateQr;
  final Clock clock;
  final GeofencePolicy geofence;
  final LocationProvider? location;

  Future<Result<PendingCheckIn>> call({
    required String rawQr,
    required Student student,
    required String deviceId,
  }) async {
    final validated = await validateQr(rawQr);
    final QrToken token;
    switch (validated) {
      case Ok(:final value):
        token = value;
      case Err(:final failure):
        return Err(failure);
    }

    if (student.boundDeviceId case final bound? when bound != deviceId) {
      return const Err(
        ValidationFailure(
          'Yoklama yalnızca hesabınıza bağlı cihazdan verilebilir.',
        ),
      );
    }

    final session = await repository.session(token.sessionId);
    if (session == null || !session.isOpen) {
      return const Err(ValidationFailure('Bu yoklama oturumu kapanmış.'));
    }
    final course = await repository.course(session.courseId);
    if (course == null || !course.studentIds.contains(student.uid)) {
      return const Err(ValidationFailure('Bu derse kayıtlı değilsiniz.'));
    }

    if (session.requireLocation) {
      final failure = await _checkLocation();
      if (failure != null) return Err(failure);
    }

    final now = clock.now();
    return await repository.submitCheckIn(
      PendingCheckIn(
        record: AttendanceRecord(
          sessionId: session.id,
          courseId: course.id,
          studentId: student.uid,
          studentNumber: student.studentNumber,
          status: session.statusAt(now),
          timestamp: now,
          deviceId: deviceId,
        ),
        studentName: student.displayName,
        nonce: token.nonce,
      ),
    );
  }

  Future<Failure?> _checkLocation() async {
    final provider = location;
    if (provider == null) {
      return const ValidationFailure('Bu oturum konum doğrulaması istiyor.');
    }
    final here = await provider.current();
    return switch (here) {
      Err(:final failure) => failure,
      Ok(:final value) when !geofence.contains(value) => ValidationFailure(
        'Kampüs dışındasınız '
        '(${geofence.distanceTo(value).round()} m uzaktasınız).',
      ),
      Ok() => null,
    };
  }
}
