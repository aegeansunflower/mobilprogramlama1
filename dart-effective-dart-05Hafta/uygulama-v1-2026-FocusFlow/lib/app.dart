import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'features/chain/chain_screen.dart';
import 'features/chain/chain_widgets.dart';
import 'features/focus/focus_screen.dart';
import 'features/home/home_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/statistics/statistics_page.dart';
import 'features/tasks/tasks_screen.dart';
import 'features/wallet/wallet_screen.dart';
import 'state/app_controller.dart';
import 'widgets/app_background.dart';
import 'widgets/app_bottom_navigation.dart';
import 'widgets/app_logo.dart';

/// FocusFlow Proof uygulamasının kök widget'ı.
class FocusFlowApp extends StatefulWidget {
  /// Merkezi denetleyiciyle uygulamayı oluşturur.
  const FocusFlowApp({super.key, required this.controller});

  /// Uygulamanın görev, oturum, ayar ve zincir durumu.
  final AppController controller;

  @override
  State<FocusFlowApp> createState() => _FocusFlowAppState();
}

class _FocusFlowAppState extends State<FocusFlowApp> {
  @override
  void initState() {
    super.initState();
    unawaited(widget.controller.initialize());
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        return MaterialApp(
          title: 'FocusFlow Proof',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: widget.controller.settings.themeMode,
          locale: const Locale('tr', 'TR'),
          supportedLocales: const <Locale>[Locale('tr', 'TR')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          scrollBehavior: const _FocusFlowScrollBehavior(),
          home: _buildHome(),
        );
      },
    );
  }

  Widget _buildHome() {
    if (widget.controller.isLoading) {
      return const _SplashScreen();
    }
    final error = widget.controller.loadError;
    if (error != null) {
      return _LoadErrorScreen(
        message: error,
        onRetry: widget.controller.initialize,
      );
    }
    return AppShell(controller: widget.controller);
  }
}

/// Depolama başlatılamadığında gösterilen yalın hata uygulaması.
class FocusFlowStartupErrorApp extends StatelessWidget {
  /// Hata ekranı uygulamasını oluşturur.
  const FocusFlowStartupErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.storage_rounded,
                    size: 52,
                    color: AppColors.danger,
                  ),
                  SizedBox(height: 18),
                  Text(
                    'FocusFlow Proof başlatılamadı',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Cihazdaki yerel depolama açılamadı. Uygulamayı kapatıp '
                    'yeniden açmayı deneyin.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  /// Uygulama kabuğunu merkezi denetleyiciyle oluşturur.
  const AppShell({super.key, required this.controller});

  /// Uygulamanın merkezi durumu.
  final AppController controller;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  void _selectTab(int index) {
    if (index == _selectedIndex) {
      return;
    }
    setState(() => _selectedIndex = index);
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsScreen(controller: widget.controller),
      ),
    );
  }

  void _openStatistics() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StatisticsPage(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: scheme.surface,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 76,
          titleSpacing: 18,
          title: Row(
            children: <Widget>[
              const AppLogo(size: 36),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            'FocusFlow',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.7,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.chainTeal.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'PROOF',
                            style: TextStyle(
                              color: AppColors.chainTeal,
                              fontSize: 6.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: scheme.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'ODAK • KANIT • KAZAN',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontSize: 7.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            _BalanceChip(
              balance: widget.controller.focusBalance,
              onTap: () => _selectTab(4),
            ),
            const SizedBox(width: 7),
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Material(
                color: scheme.surfaceContainerLowest,
                shape: CircleBorder(
                  side: BorderSide(
                    color: scheme.outlineVariant.withValues(alpha: 0.85),
                  ),
                ),
                child: IconButton(
                  onPressed: _openSettings,
                  tooltip: 'Ayarlar',
                  icon: const Icon(Icons.settings_outlined, size: 21),
                ),
              ),
            ),
          ],
        ),
        body: AppBackground(
          child: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              HomeScreen(
                controller: widget.controller,
                onStartFocus: () => _selectTab(1),
                onOpenTasks: () => _selectTab(2),
                onOpenChain: () => _selectTab(3),
                onOpenWallet: () => _selectTab(4),
                onOpenStatistics: _openStatistics,
              ),
              FocusScreen(
                controller: widget.controller,
                onOpenWallet: () => _selectTab(4),
              ),
              TasksScreen(controller: widget.controller),
              ChainScreen(controller: widget.controller),
              WalletScreen(
                controller: widget.controller,
                onOpenChain: () => _selectTab(3),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavigation(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _selectTab,
        ),
      ),
    );
  }
}

class _BalanceChip extends StatelessWidget {
  const _BalanceChip({required this.balance, required this.onTap});

  final int balance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: scheme.surfaceContainerLowest,
      shape: StadiumBorder(
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.8)),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const FocusCoin(size: 22),
              const SizedBox(width: 5),
              Text(
                '$balance',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.cream,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const Positioned(
              top: -90,
              right: -80,
              child: _SplashOrb(
                size: 260,
                color: AppColors.mint,
                opacity: 0.55,
              ),
            ),
            const Positioned(
              bottom: -120,
              left: -100,
              child: _SplashOrb(size: 300, color: AppColors.sky, opacity: 0.28),
            ),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 34),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AppColors.forest.withValues(alpha: 0.18),
                              blurRadius: 40,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(34),
                          child: Image.asset(
                            'assets/branding/focusflow_logo.png',
                            width: 280,
                            fit: BoxFit.contain,
                            semanticLabel: 'FocusFlow Proof logosu',
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 148,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: const LinearProgressIndicator(
                            minHeight: 4,
                            backgroundColor: AppColors.softGreen,
                            color: AppColors.chainTeal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Kanıt defteri başlatılıyor...',
                        style: TextStyle(
                          color: AppColors.forest,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.paper.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.forest.withValues(alpha: 0.1),
                          ),
                        ),
                        child: const Text(
                          'FOCUS • ODAK • KAZAN',
                          style: TextStyle(
                            color: AppColors.forest,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashOrb extends StatelessWidget {
  const _SplashOrb({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    );
  }
}

class _LoadErrorScreen extends StatelessWidget {
  const _LoadErrorScreen({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: theme.colorScheme.onErrorContainer,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Veriler yüklenemedi',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Tekrar dene'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FocusFlowScrollBehavior extends MaterialScrollBehavior {
  const _FocusFlowScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const <PointerDeviceKind>{
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
  };
}
