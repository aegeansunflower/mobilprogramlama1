// DART KONUSU: Classes & objects — `Notifier` alt sınıfı, constructor ile
// family argümanı, const constructor + `copyWith`, private alan, static
// metot. Libraries & imports — `show`.

/// Yoklama ekranlarının durum katmanı.
library;

import 'dart:async' show Timer, unawaited;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart'
    show FutureProviderFamily, NotifierProviderFamily, StreamProviderFamily;
import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/app/providers.dart';
import 'package:sarkisla_yoklama/attendance/attendance.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/auth/presentation/auth_controller.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Yerel zincir; her blok eklendiğinde yeni liste yayınlar. Uzak zincir
/// 20 saniyede bir senkronize edilir.
final chainBlocksProvider = StreamProvider<List<Block<Record>>>((ref) async* {
  final repo = ref.watch(chainRepositoryProvider);
  yield await repo.currentBlocks();
  await repo.sync();
  final timer = Timer.periodic(
    const Duration(seconds: 20),
    (_) => unawaited(repo.sync()),
  );
  ref.onDispose(timer.cancel);
  yield* repo.watchBlocks();
});

/// Zincirdeki tüm kayıtlar.
final ledgerProvider = Provider<List<Record>>(
  (ref) => [
    for (final block
        in ref.watch(chainBlocksProvider).value ?? const <Block<Record>>[])
      ...block.transactions,
  ],
);

/// Zincir doğrulaması; zincir değiştikçe yeniden çalışır.
final chainValidationProvider = FutureProvider<ChainValidation>((ref) async {
  await ref.watch(chainBlocksProvider.future);
  return await ref.read(chainRepositoryProvider).validate();
});

final FutureProviderFamily<List<Course>, Department> instructorCoursesProvider =
    FutureProvider.family<List<Course>, Department>((ref, department) {
      final user = ref.watch(currentUserProvider);
      if (user is! Instructor) return const <Course>[];
      return ref
          .watch(attendanceRepositoryProvider)
          .coursesForInstructor(user.uid, department);
    });

final studentCoursesProvider = FutureProvider<List<Course>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user is! Student) return const <Course>[];
  return ref.watch(attendanceRepositoryProvider).coursesForStudent(user.uid);
});

final FutureProviderFamily<Course?, String> courseProvider =
    FutureProvider.family(
      (ref, id) => ref.watch(attendanceRepositoryProvider).course(id),
    );

final FutureProviderFamily<List<Student>, String> rosterProvider =
    FutureProvider.family((ref, courseId) async {
      final course = await ref.watch(courseProvider(courseId).future);
      if (course == null) return const [];
      return await ref.watch(attendanceRepositoryProvider).roster(course);
    });

final FutureProviderFamily<List<AttendanceSession>, String> sessionsProvider =
    FutureProvider.family((ref, courseId) {
      // Zincire blok eklendikçe (oturum kapandıkça) liste tazelenir.
      ref.watch(chainBlocksProvider);
      return ref.watch(attendanceRepositoryProvider).sessionsOf(courseId);
    });

final StreamProviderFamily<AttendanceSession?, String> sessionProvider =
    StreamProvider.family(
      (ref, id) => ref.watch(attendanceRepositoryProvider).watchSession(id),
    );

final StreamProviderFamily<List<PendingCheckIn>, String> checkInsProvider =
    StreamProvider.family(
      (ref, id) => ref.watch(attendanceRepositoryProvider).watchCheckIns(id),
    );

/// Ekrandaki QR ve kalan süre.
@immutable
final class LiveQrState {
  const LiveQrState({required this.token, required this.secondsLeft});

  final QrToken token;
  final int secondsLeft;

  /// Halkanın doluluk oranı (1 → 0).
  double get progress =>
      secondsLeft / QrToken.refreshInterval.inSeconds.toDouble();

  LiveQrState copyWith({int? secondsLeft}) =>
      LiveQrState(token: token, secondsLeft: secondsLeft ?? this.secondsLeft);
}

/// 15 saniyede bir yeni imzalı QR üretip nonce'unu yayınlar.
final class LiveQrController extends Notifier<LiveQrState?> {
  LiveQrController(this.sessionId);

  final String sessionId;
  Timer? _ticker;
  bool _rotating = false;

  @override
  LiveQrState? build() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    ref.onDispose(() => _ticker?.cancel());
    unawaited(_rotate());
    return null;
  }

  void _tick() {
    final s = state;
    if (s == null) return;
    if (s.secondsLeft <= 1) {
      unawaited(_rotate());
    } else {
      state = s.copyWith(secondsLeft: s.secondsLeft - 1);
    }
  }

  Future<void> _rotate() async {
    if (_rotating) return;
    _rotating = true;
    try {
      final user = ref.read(currentUserProvider);
      if (user is! Instructor) return;
      final signer = await ref.read(signerProvider(user.uid).future);
      final token = await QrToken.issue(
        sessionId: sessionId,
        signer: signer,
        now: ref.read(clockProvider).now(),
      );
      await ref
          .read(attendanceRepositoryProvider)
          .publishNonce(sessionId, token.nonce, actor: user.role);
      if (!ref.mounted) return;
      state = LiveQrState(
        token: token,
        secondsLeft: QrToken.refreshInterval.inSeconds,
      );
    } finally {
      _rotating = false;
    }
  }
}

final NotifierProviderFamily<LiveQrController, LiveQrState?, String>
liveQrProvider = NotifierProvider.autoDispose
    .family<LiveQrController, LiveQrState?, String>(LiveQrController.new);

/// Demo yardımcıları: tek cihazda iki rolü de denemek için.
abstract final class DemoActions {
  /// Görevli ekranından: henüz gelmemiş bir öğrenci, ekrandaki QR'ı
  /// taramış gibi yoklama verir.
  static Future<Result<PendingCheckIn>?> simulateStudent(
    WidgetRef ref,
    AttendanceSession session,
  ) async {
    final qr = ref.read(liveQrProvider(session.id))?.token;
    if (qr == null) return null;
    final roster = await ref.read(rosterProvider(session.courseId).future);
    final arrived = {
      for (final c
          in ref.read(checkInsProvider(session.id)).value ??
              const <PendingCheckIn>[])
        c.record.studentId,
    };
    final next = roster.where((s) => !arrived.contains(s.uid)).firstOrNull;
    if (next == null) return null;
    return await ref
        .read(checkInProvider)
        .call(rawQr: qr.encode(), student: next, deviceId: 'demo-${next.uid}');
  }

  /// Öğrenci ekranından: açık oturumun görevlisi adına taze QR üretir
  /// (demo modunda tüm anahtarlar aynı cihazdadır).
  static Future<String?> openSessionQr(WidgetRef ref, Student student) async {
    final repo = ref.read(attendanceRepositoryProvider);
    for (final course in await repo.coursesForStudent(student.uid)) {
      final open = (await repo.sessionsOf(course.id)).where((s) => s.isOpen);
      if (open.isEmpty) continue;
      final session = open.first;
      final signer = await ref.read(
        signerProvider(session.instructorId).future,
      );
      final token = await QrToken.issue(
        sessionId: session.id,
        signer: signer,
        now: ref.read(clockProvider).now(),
      );
      // Demo: görevli cihazı adına yayınlanır.
      await repo.publishNonce(session.id, token.nonce, actor: Role.instructor);
      return token.encode();
    }
    return null;
  }
}
