// DART KONUSU: Libraries & imports — `as fs` öneki. Class modifiers —
// `final class`. Metadata — `@override`, `@RoleRestricted`.

/// Firestore tabanlı yoklama deposu.
library;

import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:sarkisla_yoklama/attendance/domain/attendance_repository.dart';
import 'package:sarkisla_yoklama/attendance/domain/attendance_session.dart';
import 'package:sarkisla_yoklama/attendance/domain/course.dart';
import 'package:sarkisla_yoklama/auth/domain/app_user.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Firestore düzeni:
/// * `courses/{id}`
/// * `users/{uid}`
/// * `sessions/{id}`
/// * `sessions/{id}/checkins/{studentUid}`: belge kimliği öğrenci uid'i
///   olduğu ve kural `allow create: if !exists` dediği için aynı oturumda
///   ikinci yoklama sunucu tarafında da engellenir (`firestore.rules`).
final class FirestoreAttendanceRepository implements AttendanceRepository {
  FirestoreAttendanceRepository([fs.FirebaseFirestore? db])
    : _db = db ?? fs.FirebaseFirestore.instance;

  final fs.FirebaseFirestore _db;

  fs.CollectionReference<Map<String, dynamic>> get _courses =>
      _db.collection('courses');
  fs.CollectionReference<Map<String, dynamic>> get _sessions =>
      _db.collection('sessions');
  fs.CollectionReference<Map<String, dynamic>> _checkInsOf(String id) =>
      _sessions.doc(id).collection('checkins');

  @override
  Future<List<Course>> coursesForInstructor(
    String instructorId,
    Department department,
  ) async {
    final snap = await _courses
        .where('instructorId', isEqualTo: instructorId)
        .where('department', isEqualTo: department.code)
        .get();
    return [for (final d in snap.docs) Course.fromJson(d.id, d.data())];
  }

  @override
  Future<List<Course>> coursesForStudent(String studentId) async {
    final snap = await _courses
        .where('studentIds', arrayContains: studentId)
        .get();
    return [for (final d in snap.docs) Course.fromJson(d.id, d.data())];
  }

  @override
  Future<Course?> course(String courseId) async {
    final d = await _courses.doc(courseId).get();
    final data = d.data();
    return data == null ? null : Course.fromJson(d.id, data);
  }

  @override
  Future<List<Student>> roster(Course course) async {
    final users = _db.collection('users');
    final result = <Student>[];
    // Firestore `whereIn` en fazla 30 değer alır.
    for (var i = 0; i < course.studentIds.length; i += 30) {
      final chunk = course.studentIds.skip(i).take(30).toList();
      final snap = await users
          .where(fs.FieldPath.documentId, whereIn: chunk)
          .get();
      for (final d in snap.docs) {
        if (AppUser.fromJson(d.id, d.data()) case final Student s) {
          result.add(s);
        }
      }
    }
    return result;
  }

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
    try {
      final open = await _sessions
          .where('courseId', isEqualTo: course.id)
          .where('endedAt', isNull: true)
          .limit(1)
          .get();
      if (open.docs.isNotEmpty) {
        final d = open.docs.first;
        return Ok(AttendanceSession.fromJson(d.id, d.data()));
      }
      final ref = _sessions.doc();
      final session = AttendanceSession(
        id: ref.id,
        courseId: course.id,
        instructorId: instructor.uid,
        startedAt: at.toUtc(),
        requireLocation: requireLocation,
      );
      await ref.set(session.toJson());
      return Ok(session);
    } on fs.FirebaseException catch (e) {
      return Err(NetworkFailure('Oturum başlatılamadı.', cause: e));
    }
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
    await _db.runTransaction((tx) async {
      final ref = _sessions.doc(sessionId);
      final snap = await tx.get(ref);
      final current = [
        for (final n in snap.data()?['activeNonces'] as List<Object?>? ?? [])
          n! as String,
      ];
      final next = [...current, nonce];
      tx.update(ref, {
        'activeNonces': next.sublist(next.length > 2 ? next.length - 2 : 0),
      });
    });
    return const Ok(null);
  }

  @override
  Future<AttendanceSession?> session(String sessionId) async {
    final d = await _sessions.doc(sessionId).get();
    final data = d.data();
    return data == null ? null : AttendanceSession.fromJson(d.id, data);
  }

  @override
  Stream<AttendanceSession?> watchSession(String sessionId) =>
      _sessions.doc(sessionId).snapshots().map((d) {
        final data = d.data();
        return data == null ? null : AttendanceSession.fromJson(d.id, data);
      });

  @override
  Future<List<AttendanceSession>> sessionsOf(String courseId) async {
    final snap = await _sessions
        .where('courseId', isEqualTo: courseId)
        .orderBy('startedAt', descending: true)
        .get();
    return [
      for (final d in snap.docs) AttendanceSession.fromJson(d.id, d.data()),
    ];
  }

  @override
  Stream<List<PendingCheckIn>> watchCheckIns(String sessionId) =>
      _checkInsOf(sessionId)
          .orderBy('record.timestamp')
          .snapshots()
          .map(
            (s) => [for (final d in s.docs) PendingCheckIn.fromJson(d.data())],
          );

  @override
  Future<List<PendingCheckIn>> checkIns(String sessionId) async {
    final snap = await _checkInsOf(sessionId).get();
    return [for (final d in snap.docs) PendingCheckIn.fromJson(d.data())];
  }

  @override
  Future<Result<PendingCheckIn>> submitCheckIn(PendingCheckIn checkIn) async {
    final sessionId = checkIn.record.sessionId;
    try {
      return await _db.runTransaction((tx) async {
        final session = await tx.get(_sessions.doc(sessionId));
        final data = session.data();
        if (data == null || data['endedAt'] != null) {
          return const Err(ValidationFailure('Bu yoklama oturumu kapanmış.'));
        }
        final nonces = data['activeNonces'] as List<Object?>? ?? const [];
        if (!nonces.contains(checkIn.nonce)) {
          return const Err(
            ValidationFailure(
              'QR kodu artık geçerli değil. Yeni kodu tarayın.',
            ),
          );
        }
        final ref = _checkInsOf(sessionId).doc(checkIn.record.studentId);
        if ((await tx.get(ref)).exists) {
          return const Err(
            ValidationFailure('Bu oturumda yoklamanız zaten alındı.'),
          );
        }
        tx.set(ref, checkIn.toJson());
        return Ok(checkIn);
      });
    } on fs.FirebaseException catch (e) {
      return Err(NetworkFailure('Yoklama gönderilemedi.', cause: e));
    }
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
    final ref = _sessions.doc(sessionId);
    await ref.update({
      'endedAt': at.toUtc().millisecondsSinceEpoch,
      'blockIndex': blockIndex,
      'activeNonces': <String>[],
    });
    final s = await session(sessionId);
    return s == null
        ? const Err(ValidationFailure('Oturum bulunamadı.'))
        : Ok(s);
  }
}
