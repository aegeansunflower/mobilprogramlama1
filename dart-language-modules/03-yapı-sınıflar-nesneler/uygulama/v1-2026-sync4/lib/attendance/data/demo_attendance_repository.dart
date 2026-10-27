// DART KONUSU: Class modifiers — `final class` uygulama. Classes & objects —
// private alanlar, `StreamController`, `Map` tabanlı bellek içi depo.
// Metadata — `@override`, `@RoleRestricted`.

/// Firebase olmadan çalışan bellek içi yoklama deposu.
library;

import 'dart:async' show StreamController;

import 'package:sarkisla_yoklama/attendance/domain/attendance_repository.dart';
import 'package:sarkisla_yoklama/attendance/domain/attendance_session.dart';
import 'package:sarkisla_yoklama/attendance/domain/course.dart';
import 'package:sarkisla_yoklama/auth/domain/app_user.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Demo modu ve testler için yoklama deposu. Firestore uygulamasıyla aynı
/// kuralları (nonce, mükerrer katılım) uygular.
final class DemoAttendanceRepository implements AttendanceRepository {
  DemoAttendanceRepository({
    required List<Course> courses,
    required List<Student> students,
  }) : _courses = {for (final c in courses) c.id: c},
       _students = {for (final s in students) s.uid: s};

  final Map<String, Course> _courses;
  final Map<String, Student> _students;
  final Map<String, AttendanceSession> _sessions = {};
  final Map<String, Map<String, PendingCheckIn>> _checkIns = {};
  final StreamController<String> _changes = StreamController.broadcast();
  var _sequence = 0;

  void _changed(String sessionId) => _changes.add(sessionId);

  @override
  Future<List<Course>> coursesForInstructor(
    String instructorId,
    Department department,
  ) async => [
    for (final c in _courses.values)
      if (c.instructorId == instructorId && c.department == department) c,
  ];

  @override
  Future<List<Course>> coursesForStudent(String studentId) async => [
    for (final c in _courses.values)
      if (c.studentIds.contains(studentId)) c,
  ];

  @override
  Future<Course?> course(String courseId) async => _courses[courseId];

  @override
  Future<List<Student>> roster(Course course) async => [
    for (final id in course.studentIds) ?_students[id],
  ];

  @override
  @RoleRestricted(Role.instructor)
  Future<Result<AttendanceSession>> startSession({
    required Course course,
    required Instructor instructor,
    required DateTime at,
    bool requireLocation = false,
  }) async {
    final denied = RoleGuard.ensure(Role.instructor, instructor.role);
    if (denied != null) return Err(denied);
    final open = _sessions.values.where(
      (s) => s.courseId == course.id && s.isOpen,
    );
    if (open.isNotEmpty) return Ok(open.first);
    final session = AttendanceSession(
      id: '${course.code}-${at.millisecondsSinceEpoch}-${_sequence++}',
      courseId: course.id,
      instructorId: instructor.uid,
      startedAt: at.toUtc(),
      requireLocation: requireLocation,
    );
    _sessions[session.id] = session;
    _checkIns[session.id] = {};
    _changed(session.id);
    return Ok(session);
  }

  @override
  @RoleRestricted(Role.instructor)
  Future<Result<void>> publishNonce(
    String sessionId,
    String nonce, {
    required Role actor,
  }) async {
    final denied = RoleGuard.ensure(Role.instructor, actor);
    if (denied != null) return Err(denied);
    final s = _sessions[sessionId];
    if (s == null) return const Err(ValidationFailure('Oturum bulunamadı.'));
    final recent = [...s.activeNonces, nonce];
    _sessions[sessionId] = s.copyWith(
      activeNonces: recent.sublist(recent.length > 2 ? recent.length - 2 : 0),
    );
    return const Ok(null);
  }

  @override
  Future<AttendanceSession?> session(String sessionId) async =>
      _sessions[sessionId];

  @override
  Stream<AttendanceSession?> watchSession(String sessionId) async* {
    yield _sessions[sessionId];
    await for (final changed in _changes.stream) {
      if (changed == sessionId) yield _sessions[sessionId];
    }
  }

  @override
  Future<List<AttendanceSession>> sessionsOf(String courseId) async =>
      _sessions.values.where((s) => s.courseId == courseId).toList()
        ..sort((a, b) => b.startedAt.compareTo(a.startedAt));

  @override
  Stream<List<PendingCheckIn>> watchCheckIns(String sessionId) async* {
    yield await checkIns(sessionId);
    await for (final changed in _changes.stream) {
      if (changed == sessionId) yield await checkIns(sessionId);
    }
  }

  @override
  Future<List<PendingCheckIn>> checkIns(String sessionId) async =>
      (_checkIns[sessionId]?.values.toList() ?? [])
        ..sort((a, b) => a.record.timestamp.compareTo(b.record.timestamp));

  @override
  Future<Result<PendingCheckIn>> submitCheckIn(PendingCheckIn checkIn) async {
    final sessionId = checkIn.record.sessionId;
    final session = _sessions[sessionId];
    if (session == null || !session.isOpen) {
      return const Err(ValidationFailure('Bu yoklama oturumu kapanmış.'));
    }
    if (!session.activeNonces.contains(checkIn.nonce)) {
      return const Err(
        ValidationFailure('QR kodu artık geçerli değil. Yeni kodu tarayın.'),
      );
    }
    final existing = _checkIns[sessionId]!;
    if (existing.containsKey(checkIn.record.studentId)) {
      return const Err(
        ValidationFailure('Bu oturumda yoklamanız zaten alındı.'),
      );
    }
    final deviceUsed = existing.values.any(
      (c) =>
          c.record.deviceId != null &&
          c.record.deviceId == checkIn.record.deviceId,
    );
    if (deviceUsed) {
      return const Err(
        ValidationFailure('Bu cihazdan bu oturumda zaten yoklama verildi.'),
      );
    }
    existing[checkIn.record.studentId] = checkIn;
    _changed(sessionId);
    return Ok(checkIn);
  }

  @override
  @RoleRestricted(Role.instructor)
  Future<Result<AttendanceSession>> closeSession(
    String sessionId, {
    required Role actor,
    required DateTime at,
    required int blockIndex,
  }) async {
    final denied = RoleGuard.ensure(Role.instructor, actor);
    if (denied != null) return Err(denied);
    final s = _sessions[sessionId];
    if (s == null) return const Err(ValidationFailure('Oturum bulunamadı.'));
    final closed = s.copyWith(
      endedAt: at.toUtc(),
      blockIndex: blockIndex,
      activeNonces: const [],
    );
    _sessions[sessionId] = closed;
    _changed(sessionId);
    return Ok(closed);
  }
}
