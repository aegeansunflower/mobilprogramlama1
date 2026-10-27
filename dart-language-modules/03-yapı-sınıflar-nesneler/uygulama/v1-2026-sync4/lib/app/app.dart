// DART KONUSU: Classes & objects — `ConsumerWidget`, sealed `AuthState`
// üzerinden rol rengi seçimi. Libraries & imports — `show`.

/// Uygulama kökü: tema (rol + açık/koyu), yerelleştirme, yönlendirici.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show
        GlobalCupertinoLocalizations,
        GlobalMaterialLocalizations,
        GlobalWidgetsLocalizations;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sarkisla_yoklama/app/router.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/auth/presentation/auth_controller.dart';
import 'package:sarkisla_yoklama/l10n/generated/app_localizations.dart';
import 'package:sarkisla_yoklama/ui/ui.dart';

/// Kök widget.
final class SarkislaApp extends ConsumerWidget {
  const SarkislaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    // Rol bazlı renk dili: giriş akışında seçilen rolün rengi hemen uygulanır.
    final role = switch (auth) {
      SignedIn(:final user) || AwaitingBiometric(:final user) => user.role,
      Authenticating(:final role) || AuthError(:final role) => role,
      SignedOut() => null,
    };
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
      theme: AppTheme.build(Brightness.light, role),
      darkTheme: AppTheme.build(Brightness.dark, role),
      themeMode: ref.watch(themeModeProvider),
      themeAnimationDuration: MotionDurations.slow,
      locale: const Locale('tr'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
