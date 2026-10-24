import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../blockchain/core/focus_reward_calculator.dart';
import '../../blockchain/utils/chain_formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/duration_formatter.dart';
import '../../models/app_settings.dart';
import '../../models/focus_session.dart';
import '../../state/app_controller.dart';
import '../../widgets/app_snack_bar.dart';
import '../../widgets/page_header.dart';
import '../chain/chain_widgets.dart';
import 'focus_timer_controller.dart';

/// Pomodoro sayacını, mod seçimini ve günün odak özetini gösterir.
class FocusScreen extends StatefulWidget {
  /// Odak ekranını merkezi denetleyiciyle oluşturur.
  const FocusScreen({
    super.key,
    required this.controller,
    required this.onOpenWallet,
  });

  /// Uygulamanın merkezi durumu.
  final AppController controller;

  /// Cüzdan sekmesine geçer.
  final VoidCallback onOpenWallet;

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> with WidgetsBindingObserver {
  late final FocusTimerController _timer;
  late AppSettings _settings;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _settings = widget.controller.settings;
    _timer = FocusTimerController(
      settings: _settings,
      onSessionCompleted: _handleSessionCompleted,
    );
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timer.syncNow();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    WidgetsBinding.instance.removeObserver(this);
    _timer.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    final settings = widget.controller.settings;
    if (settings == _settings) {
      return;
    }
    _settings = settings;
    _timer.applySettings(settings);
  }

  Future<void> _handleSessionCompleted(FocusSession session) async {
    final saved = await widget.controller.recordSession(session);
    if (!mounted) {
      return;
    }
    if (!saved) {
      showAppSnackBar(
        context,
        widget.controller.lastError ?? 'Oturum kaydedilemedi.',
        tone: SnackBarTone.error,
        actionLabel: 'Tekrar dene',
        onAction: () => _retrySave(session),
      );
      return;
    }

    try {
      await HapticFeedback.mediumImpact();
    } on Object {
      // Titreşim desteklenmeyen platformlarda sessizce devam edilir.
    }
    if (!mounted) {
      return;
    }
    await _showCompletionDialog(session);
  }

  Future<void> _retrySave(FocusSession session) async {
    final saved = await widget.controller.recordSession(session);
    if (!mounted) {
      return;
    }
    if (!saved) {
      showAppSnackBar(
        context,
        widget.controller.lastError ?? 'Oturum kaydedilemedi.',
        tone: SnackBarTone.error,
      );
      return;
    }
    showAppSnackBar(context, 'Oturum kaydedildi.', tone: SnackBarTone.success);
    await _showCompletionDialog(session);
  }

  Future<void> _showCompletionDialog(FocusSession session) async {
    final isFocus = session.type.isFocus;
    final minutes = (session.actualDurationSeconds / 60).round();
    final reward = widget.controller.lastChainReward;
    final achievements = widget.controller.lastAchievements;
    final rewardConfirmed = reward?.isConfirmed ?? false;
    final totalReward = isFocus ? reward?.totalReward ?? 0 : 0;
    var openWallet = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        final scheme = theme.colorScheme;
        return AlertDialog(
          icon: isFocus && reward != null
              ? const FocusCoin(size: 62)
              : Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        scheme.primaryContainer,
                        scheme.secondaryContainer,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFocus ? Icons.check_rounded : Icons.local_cafe_outlined,
                    color: scheme.onPrimaryContainer,
                    size: 32,
                  ),
                ),
          title: Text(
            isFocus && reward != null
                ? 'Odak kanıtlandı'
                : isFocus
                ? 'Odak oturumu tamamlandı'
                : 'Mola tamamlandı',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  isFocus
                      ? '$minutes dakika boyunca odaklandın. Bu oturum '
                            'istatistiklerine eklendi.'
                      : '${session.type.label} tamamlandı. Yeni bir odak '
                            'oturumuna hazırsın.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                if (isFocus) ...<Widget>[
                  const SizedBox(height: 14),
                  if (reward != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.tokenGold.withValues(alpha: 0.11),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.tokenGold.withValues(alpha: 0.26),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          const FocusCoin(size: 34),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  rewardConfirmed
                                      ? 'Kanıt defterine işlendi'
                                      : 'İşlem sıraya alındı',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.deepChain,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  rewardConfirmed
                                      ? 'Odak +${reward.transaction.amount} • '
                                            'Blok +${reward.blockReward}'
                                      : 'Blok üretimi bekleniyor.',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '+$totalReward',
                            style: const TextStyle(
                              color: AppColors.tokenGold,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.6,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'FOCUS',
                            style: TextStyle(
                              color: AppColors.tokenGold.withValues(alpha: 0.8),
                              fontSize: 7,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.info_outline_rounded,
                            size: 17,
                            color: scheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Kanıt defteri hazır olmadığı için FOCUS ödülü '
                              'oluşturulamadı. Odak kaydın istatistiklerine '
                              'eklendi.',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (achievements.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Yeni rozetler',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    for (final achievement in achievements) ...<Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.tokenGold.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.tokenGold.withValues(alpha: 0.22),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              achievementIcon(achievement.iconName),
                              size: 18,
                              color: AppColors.tokenGold,
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    achievement.title,
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                        ),
                                  ),
                                  Text(
                                    achievement.tokenId,
                                    style: TextStyle(
                                      color: scheme.onSurfaceVariant.withValues(
                                        alpha: 0.65,
                                      ),
                                      fontFamily: 'monospace',
                                      fontSize: 7.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '+${achievement.reward} FOCUS',
                              style: const TextStyle(
                                color: AppColors.tokenGold,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                  if (reward?.block != null) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(
                      'Blok #${reward!.block!.index} • '
                      '${shortHash(reward.block!.hash)}',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant.withValues(alpha: 0.65),
                        fontFamily: 'monospace',
                        fontSize: 8,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Tamam'),
            ),
            if (isFocus && reward != null)
              TextButton(
                onPressed: () {
                  openWallet = true;
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Cüzdan'),
              ),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _timer.selectType(SessionType.focus);
              },
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: const Text('Yeni odak'),
            ),
          ],
        );
      },
    );

    if (openWallet && mounted) {
      widget.onOpenWallet();
    }
  }

  Future<void> _confirmReset() async {
    if (!_timer.isActive) {
      _timer.reset();
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Oturumu sıfırla'),
          content: const Text(
            'Sayaç başa dönecek ve bu oturum kaydedilmeyecek. Devam etmek '
            'istiyor musun?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Sıfırla'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      _timer.reset();
    }
  }

  void _handlePrimaryAction() {
    if (_timer.status == FocusTimerStatus.running) {
      _timer.pause();
    } else {
      _timer.start();
    }
  }

  String get _primaryLabel => switch (_timer.status) {
    FocusTimerStatus.idle => 'Başlat',
    FocusTimerStatus.running => 'Duraklat',
    FocusTimerStatus.paused => 'Devam et',
    FocusTimerStatus.completed => 'Yeniden başlat',
  };

  IconData get _primaryIcon => switch (_timer.status) {
    FocusTimerStatus.idle => Icons.play_arrow_rounded,
    FocusTimerStatus.running => Icons.pause_rounded,
    FocusTimerStatus.paused => Icons.play_arrow_rounded,
    FocusTimerStatus.completed => Icons.replay_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      children: <Widget>[
        PageHeader(
          title: 'Odaklan',
          subtitle: 'Pomodoro sayacıyla sakin bir çalışma alanı aç.',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: scheme.secondaryContainer.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.7),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.spa_rounded,
                  size: 13,
                  color: scheme.onSecondaryContainer,
                ),
                const SizedBox(width: 5),
                Text(
                  'Pomodoro',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSecondaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        ListenableBuilder(
          listenable: _timer,
          builder: (context, _) {
            return Column(
              children: <Widget>[
                _ModeSelector(timer: _timer, settings: _settings),
                const SizedBox(height: 14),
                _TimerCard(
                  timer: _timer,
                  estimatedReward: FocusRewardCalculator.forMinutes(
                    _settings.focusDurationMinutes,
                  ),
                  primaryLabel: _primaryLabel,
                  primaryIcon: _primaryIcon,
                  onPrimaryPressed: _handlePrimaryAction,
                  onResetPressed: _confirmReset,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        _TodaySummaryCard(
          sessionCount: widget.controller.todayFocusSessionCount,
          focusSeconds: widget.controller.todayFocusSeconds,
        ),
        const SizedBox(height: 12),
        _FocusTipCard(),
      ],
    );
  }
}

class _ModeSelector extends StatelessWidget {
  const _ModeSelector({required this.timer, required this.settings});

  final FocusTimerController timer;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLowest.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.8),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: scheme.shadow.withValues(
                  alpha: theme.brightness == Brightness.dark ? 0.18 : 0.035,
                ),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: SessionType.values
                .map(
                  (type) => Expanded(
                    child: _ModeButton(
                      type: type,
                      selected: timer.type == type,
                      enabled: timer.canChangeType,
                      onTap: () => timer.selectType(type),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!timer.canChangeType) ...<Widget>[
              Icon(
                Icons.lock_outline_rounded,
                size: 12,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                timer.canChangeType
                    ? 'Odak ${settings.focusDurationMinutes} dk  •  '
                          'Kısa mola ${settings.shortBreakMinutes} dk  •  '
                          'Uzun mola ${settings.longBreakMinutes} dk'
                    : 'Oturum sürerken mod değiştirilemez.',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.type,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final SessionType type;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  IconData get _icon => switch (type) {
    SessionType.focus => Icons.center_focus_strong_rounded,
    SessionType.shortBreak => Icons.local_cafe_outlined,
    SessionType.longBreak => Icons.self_improvement_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = selected ? scheme.onPrimary : scheme.onSurfaceVariant;

    return Semantics(
      selected: selected,
      button: true,
      label: type.label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(19),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(19),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: enabled ? 1 : 0.7,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 11),
              decoration: BoxDecoration(
                gradient: selected
                    ? LinearGradient(
                        colors: <Color>[scheme.primary, scheme.secondary],
                      )
                    : null,
                borderRadius: BorderRadius.circular(19),
                boxShadow: selected
                    ? <BoxShadow>[
                        BoxShadow(
                          color: scheme.primary.withValues(alpha: 0.2),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(_icon, size: 16, color: foreground),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      type.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: foreground,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
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

class _TimerCard extends StatelessWidget {
  const _TimerCard({
    required this.timer,
    required this.estimatedReward,
    required this.primaryLabel,
    required this.primaryIcon,
    required this.onPrimaryPressed,
    required this.onResetPressed,
  });

  final FocusTimerController timer;
  final int estimatedReward;
  final String primaryLabel;
  final IconData primaryIcon;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onResetPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeLabel = formatClock(timer.remainingSeconds);
    final isCompleted = timer.status == FocusTimerStatus.completed;
    final gradient = AppTheme.heroGradientFor(theme.brightness);

    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.pine.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.5 : 0.26,
            ),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isCompleted ? AppColors.lime : Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          timer.type.label.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(timer.totalSeconds / 60).round()} dk',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final diameter = math.min(constraints.maxWidth - 8, 278.0);
                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: timer.progress),
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOutCubic,
                    builder: (context, progress, _) {
                      return SizedBox(
                        width: diameter,
                        height: diameter,
                        child: CustomPaint(
                          painter: _TimerRingPainter(
                            progress: progress,
                            trackColor: Colors.white.withValues(alpha: 0.13),
                            progressColors: const <Color>[
                              AppColors.mint,
                              AppColors.lime,
                              Colors.white,
                            ],
                          ),
                          child: Center(
                            child: Semantics(
                              liveRegion: true,
                              label:
                                  '${timer.type.label} sayacı, kalan süre '
                                  '$timeLabel',
                              child: ExcludeSemantics(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        timeLabel,
                                        style: theme.textTheme.displaySmall
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontSize: diameter * 0.22,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: -2.4,
                                              fontFeatures: const <FontFeature>[
                                                FontFeature.tabularFigures(),
                                              ],
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      isCompleted ? 'süre doldu' : 'kalan süre',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.62,
                                        ),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: timer.status == FocusTimerStatus.idle
                        ? null
                        : onResetPressed,
                    tooltip: 'Oturumu sıfırla',
                    style: IconButton.styleFrom(
                      minimumSize: const Size(52, 52),
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.white.withValues(
                        alpha: 0.05,
                      ),
                      disabledForegroundColor: Colors.white.withValues(
                        alpha: 0.35,
                      ),
                      shape: const CircleBorder(),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    icon: const Icon(Icons.replay_rounded, size: 22),
                  ),
                  const SizedBox(width: 14),
                  FilledButton.icon(
                    onPressed: onPrimaryPressed,
                    icon: Icon(primaryIcon, size: 20),
                    label: Text(primaryLabel),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.pine,
                      minimumSize: const Size(172, 52),
                      textStyle: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              if (timer.type.isFocus) ...<Widget>[
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.toll_rounded,
                      size: 14,
                      color: AppColors.tokenGold,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                              text: '+$estimatedReward FOCUS kazan',
                              style: const TextStyle(
                                color: AppColors.tokenGold,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: ' • blok ödülü +1',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.55),
                              ),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _TodaySummaryCard extends StatelessWidget {
  const _TodaySummaryCard({
    required this.sessionCount,
    required this.focusSeconds,
  });

  final int sessionCount;
  final int focusSeconds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.75),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: scheme.shadow.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.2 : 0.04,
            ),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  scheme.secondaryContainer,
                  scheme.primaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.today_rounded,
              color: scheme.onSecondaryContainer,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Bugünkü odak',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$sessionCount oturum tamamlandı',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatHumanDuration(focusSeconds),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusTipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withValues(
          alpha: theme.brightness == Brightness.dark ? 0.55 : 0.6,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: scheme.onSecondaryContainer,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Kalan süre hedef bitiş zamanından hesaplanır. Uygulama arka '
              'plana gitse bile sayaç kaymaz; geri döndüğünde otomatik '
              'güncellenir. Arka plan bildirimi gönderilmez.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSecondaryContainer,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  const _TimerRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColors,
  });

  final double progress;
  final Color trackColor;
  final List<Color> progressColors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - 14) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    final innerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius - 24, innerPaint);

    if (progress <= 0) {
      return;
    }

    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: progressColors,
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final sweep = 2 * math.pi * progress;
    canvas.drawArc(rect, -math.pi / 2, sweep, false, progressPaint);

    final endAngle = -math.pi / 2 + sweep;
    final dotCenter =
        center + Offset(math.cos(endAngle), math.sin(endAngle)) * radius;
    canvas.drawCircle(dotCenter, 5, Paint()..color = AppColors.lime);
  }

  @override
  bool shouldRepaint(covariant _TimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColors != progressColors;
  }
}
