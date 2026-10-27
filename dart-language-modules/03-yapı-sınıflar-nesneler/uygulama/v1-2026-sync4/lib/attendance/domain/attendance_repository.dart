// DART KONUSU: Class modifiers — `abstract interface class`. Metadata —
// `@RoleRestricted` ile işaretli sözleşme metotları.

/// Yoklama oturumu deposu sözleşmesi.
library;

import 'package:sarkisla_yoklama/attendance/domain/attendance_session.dart';
import 'package:sarkisla_yoklama/attendance/domain/course.dart';
import 'package:sarkisla_yoklama/auth/domain/app_user.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Ders, oturum ve henüz bloğa girmemiş katılımların deposu.
///
/// Kalıcı yoklama kayıtları burada değil, `BlockchainRepository`'dedir. Bu
/// depo yalnızca oturumun "canlı" kısmını tutar.
///
/// `abstract interface class` seçildi: Firestore ve demo uygulamaları
/// birbirinden bağımsızdır, ortak kod içermez.
abstract interface class AttendanceRepository {
  /// Görevlinin [department] bölümündeki dersleri.
  Future<List<Course>> coursesForInstructor(
    String instructorId,
    Department department,
  );

  /// Öğrencinin kayıtlı olduğu dersler.
  Future<List<Course>> coursesForStudent(String studentId);

  Future<Course?> course(String courseId);

  /// Dersin öğrenci listesi.
  Future<List<Student>> roster(Course course);

  /// Yeni oturum açar.
  @RoleRestricted(Role.instructor)
  Future<Result<AttendanceSession>> startSession({
    required Course course,
    required Instructor instructor,
    required DateTime at,
    bool requireLocation = false,
  });

  /// Ekrandaki yeni QR'ın nonce değerini yayınlar. Son iki nonce geçerlidir.
  @RoleRestricted(Role.instructor)
  Future<Result<void>> publishNonce(
    String sessionId,
    String nonce, {
    required Role actor,
  });

  Future<AttendanceSession?> session(String sessionId);

  Stream<AttendanceSession?> watchSession(String sessionId);

  /// Dersin tüm oturumları (yeniden eskiye).
  Future<List<AttendanceSession>> sessionsOf(String courseId);

  /// Canlı katılımcı listesi.
  Stream<List<PendingCheckIn>> watchCheckIns(String sessionId);

  Future<List<PendingCheckIn>> checkIns(String sessionId);

  /// Öğrencinin QR katılımını kaydeder. Aynı oturumda ikinci katılımı ve
  /// geçersiz nonce'u reddeder.
  Future<Result<PendingCheckIn>> submitCheckIn(PendingCheckIn checkIn);

  /// Oturumu kapatır ve kayıtların yazıldığı bloğu not eder.
  @RoleRestricted(Role.instructor)
  Future<Result<AttendanceSession>> closeSession(
    String sessionId, {
    required Role actor,
    required DateTime at,
    required int blockIndex,
  });
}
