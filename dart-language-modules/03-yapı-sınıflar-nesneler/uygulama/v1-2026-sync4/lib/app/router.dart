// DART KONUSU: Libraries & imports — `deferred as` ile tembel yüklenen ağır
// modüller (QR tarayıcı, raporlar) ve `loadLibrary()`. Class modifiers —
// sealed `AppUser` ile rol bazlı yönlendirme (eksiksiz switch).
// Classes & objects — `StatefulWidget` + `late final Future`.

/// Rol bazlı guard'lı go_router yapılandırması.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sarkisla_yoklama/attendance/attendance.dart';
import 'package:sarkisla_yoklama/attendance/presentation/instructor/chain_page.dart';
import 'package:sarkisla_yoklama/attendance/presentation/instructor/course_detail_page.dart';
import 'package:sarkisla_yoklama/attendance/presentation/instructor/instructor_pages.dart';
import 'package:sarkisla_yoklama/attendance/presentation/instructor/live_session_page.dart';
import 'package:sarkisla_yoklama/attendance/presentation/reports/report_page.dart'
    deferred as reports;
import 'package:sarkisla_yoklama/attendance/presentation/student/scanner_page.dart'
    deferred as scanner;
import 'package:sarkisla_yoklama/attendance/presentation/student/student_pages.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/auth/presentation/auth_controller.dart';
import 'package:sarkisla_yoklama/auth/presentation/login_page.dart';
import 'package:sarkisla_yoklama/auth/presentation/role_select_page.dart';
import 'package:sarkisla_yoklama/core/core.dart';
import 'package:sarkisla_yoklama/ui/ui.dart';

/// Uygulama yönlendiricisi.
///
/// Guard kuralı:
/// * Oturum kapalı → yalnızca `/giris/...`
/// * Öğretim görevlisi → yalnızca `/ogretim/...`
/// * Öğrenci → yalnızca `/ogrenci/...`
final routerProvider = Provider<GoRouter>((ref) {
  final auth = ValueNotifier<AuthState>(ref.read(authControllerProvider));
  ref
    ..listen(authControllerProvider, (_, next) => auth.value = next)
    ..onDispose(auth.dispose);

  GoRoute route(String path, Widget Function(GoRouterState s) build) => GoRoute(
    path: path,
    pageBuilder: (context, state) => motionPage(context, state, build(state)),
  );

  return GoRouter(
    initialLocation: '/giris',
    refreshListenable: auth,
    redirect: (context, state) {
      final current = auth.value;
      final user = current is SignedIn ? current.user : null;
      final loc = state.matchedLocation;
      return switch (user) {
        null => loc.startsWith('/giris') ? null : '/giris',
        Instructor() => loc.startsWith('/ogretim') ? null : '/ogretim',
        Student() => loc.startsWith('/ogrenci') ? null : '/ogrenci',
      };
    },
    routes: [
      route('/giris', (_) => const RoleSelectPage()),
      route('/giris/ogretim', (_) => const LoginPage(role: Role.instructor)),
      route('/giris/ogrenci', (_) => const LoginPage(role: Role.student)),

      // Öğretim görevlisi
      route('/ogretim', (_) => const InstructorHomePage()),
      route(
        '/ogretim/bolum/:code',
        (s) => CourseListPage(
          department: Department.fromCode(s.pathParameters['code']!),
        ),
      ),
      route(
        '/ogretim/ders/:id',
        (s) => CourseDetailPage(courseId: s.pathParameters['id']!),
      ),
      route(
        '/ogretim/ders/:id/rapor',
        (s) => DeferredPage(
          load: reports.loadLibrary,
          builder: (_) => reports.ReportPage(courseId: s.pathParameters['id']!),
        ),
      ),
      route(
        '/ogretim/oturum/:id',
        (s) => LiveSessionPage(sessionId: s.pathParameters['id']!),
      ),
      route('/ogretim/zincir', (_) => const ChainPage()),

      // Öğrenci
      route('/ogrenci', (_) => const StudentHomePage()),
      route(
        '/ogrenci/tara',
        (_) => DeferredPage(
          load: scanner.loadLibrary,
          builder: (_) => scanner.ScannerPage(),
        ),
      ),
      GoRoute(
        path: '/ogrenci/makbuz',
        redirect: (_, state) =>
            state.extra is PendingCheckIn ? null : '/ogrenci',
        pageBuilder: (context, state) => motionPage(
          context,
          state,
          ReceiptPage(checkIn: state.extra! as PendingCheckIn),
        ),
      ),
      route(
        '/ogrenci/ders/:id',
        (s) => StudentCoursePage(courseId: s.pathParameters['id']!),
      ),
    ],
  );
});

/// `deferred` kütüphaneyi yükleyip ardından sayfayı gösterir.
final class DeferredPage extends StatefulWidget {
  const DeferredPage({required this.load, required this.builder, super.key});

  /// `kutuphane.loadLibrary` fonksiyonu.
  final Future<void> Function() load;
  final WidgetBuilder builder;

  @override
  State<DeferredPage> createState() => _DeferredPageState();
}

final class _DeferredPageState extends State<DeferredPage> {
  // Kütüphane yalnızca bir kez yüklenir.
  late final Future<void> _loaded = widget.load();

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: _loaded,
    builder: (context, snapshot) => switch (snapshot) {
      AsyncSnapshot(connectionState: ConnectionState.done, :final error?) =>
        AppScaffold(body: ErrorBanner('${context.l10n.genericError}: $error')),
      AsyncSnapshot(connectionState: ConnectionState.done) => widget.builder(
        context,
      ),
      _ => AppScaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: Space.md),
              Text(context.l10n.loadingModule),
            ],
          ),
        ),
      ),
    },
  );
}
