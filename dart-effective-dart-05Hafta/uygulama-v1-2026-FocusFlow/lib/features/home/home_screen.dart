import 'package:flutter/material.dart';

import '../../blockchain/core/focus_chain_network.dart';
import '../../blockchain/core/focus_reward_calculator.dart';
import '../../blockchain/utils/chain_formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_time_utils.dart';
import '../../core/utils/duration_formatter.dart';
import '../../models/study_task.dart';
import '../../state/app_controller.dart';
import '../../widgets/app_snack_bar.dart';
import '../../widgets/empty_state.dart';
import '../chain/chain_widgets.dart';
import '../tasks/task_form_dialog.dart';

/// Günün odak özetini, görev ilerlemesini ve hızlı eylemleri gösterir.
class HomeScreen extends StatelessWidget {
  /// Ana sayfayı denetleyici ve sekme geri çağrılarıyla oluşturur.
  const HomeScreen({
    super.key,
    required this.controller,
    required this.onStartFocus,
    required this.onOpenTasks,
    required this.onOpenChain,
    required this.onOpenWallet,
    required this.onOpenStatistics,
  });

  /// Uygulamanın merkezi durumu.
  final AppController controller;

  /// Odak sekmesine geçer.
  final VoidCallback onStartFocus;

  /// Görevler sekmesine geçer.
  final VoidCallback onOpenTasks;

  /// Kanıt defteri sekmesine geçer.
  final VoidCallback onOpenChain;

  /// Cüzdan sekmesine geçer.
  final VoidCallback onOpenWallet;

  /// İstatistik sayfasını açar.
  final VoidCallback onOpenStatistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final now = DateTime.now();
    final upcomingTasks = controller.upcomingTasks;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      children: <Widget>[
        _GreetingHeader(now: now, onOpenStatistics: onOpenStatistics),
        const SizedBox(height: 20),
        _TodayFocusCard(
          focusSeconds: controller.todayFocusSeconds,
          sessionCount: controller.todayFocusSessionCount,
          estimatedReward: FocusRewardCalculator.forMinutes(
            controller.settings.focusDurationMinutes,
          ),
          onStartFocus: onStartFocus,
        ),
        const SizedBox(height: 14),
        Row(
          children: <Widget>[
            Expanded(
              child: _SummaryTile(
                icon: Icons.task_alt_rounded,
                value: '${controller.todayCompletedTaskCount}',
                label: 'Bugün tamamlanan',
                accent: scheme.secondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryTile(
                icon: Icons.pending_actions_rounded,
                value: '${controller.pendingTaskCount}',
                label: 'Bekleyen görev',
                accent: AppColors.sand,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _ProofSummaryCard(
          controller: controller,
          onOpenChain: onOpenChain,
          onOpenWallet: onOpenWallet,
        ),
        const SizedBox(height: 28),
        _SectionHeader(
          title: 'Sıradaki görevler',
          count: upcomingTasks.length,
          actionLabel: 'Tümünü gör',
          onAction: onOpenTasks,
        ),
        const SizedBox(height: 12),
        if (upcomingTasks.isEmpty)
          EmptyState(
            icon: Icons.spa_outlined,
            title: 'Görev listesi sakin',
            message:
                'Bugün için planlanmış bir görev yok. İlk görevini ekleyerek '
                'güne küçük bir adımla başla.',
            actionLabel: 'Görev ekle',
            onAction: () => _openTaskForm(context),
          )
        else ...<Widget>[
          for (final task in upcomingTasks) ...<Widget>[
            _HomeTaskTile(
              task: task,
              rewarded: controller.hasRewardForTask(task.id),
              onToggle: () => _toggleTask(context, task),
              onTap: () => _openTaskForm(context, task: task),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: () => _openTaskForm(context),
            icon: const Icon(Icons.add_rounded, size: 19),
            label: const Text('Yeni görev ekle'),
          ),
        ],
      ],
    );
  }

  Future<void> _openTaskForm(BuildContext context, {StudyTask? task}) {
    return showTaskFormDialog(context, controller: controller, task: task);
  }

  Future<void> _toggleTask(BuildContext context, StudyTask task) async {
    final wasCompleted = task.isCompleted;
    final saved = await controller.setTaskCompleted(
      task,
      isCompleted: !task.isCompleted,
    );
    if (!context.mounted) {
      return;
    }
    if (!saved) {
      showAppSnackBar(
        context,
        controller.lastError ?? 'Görev güncellenemedi.',
        tone: SnackBarTone.error,
      );
      return;
    }
    if (!wasCompleted) {
      final reward = controller.lastChainReward;
      if (reward != null) {
        showAppSnackBar(
          context,
          'Görev tamamlandı • +${reward.totalReward} FOCUS kazanıldı.',
          tone: SnackBarTone.success,
        );
      }
    }
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.now, required this.onOpenStatistics});

  final DateTime now;
  final VoidCallback onOpenStatistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                greetingFor(now).toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.secondary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Bugün neler yapacaksın?',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 27,
                  letterSpacing: -0.9,
                ),
              ),
              const SizedBox(height: 9),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLowest.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: scheme.outlineVariant.withValues(alpha: 0.7),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        formatTurkishDateWithWeekday(now),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onOpenStatistics,
            customBorder: const CircleBorder(),
            child: Ink(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    scheme.primaryContainer,
                    scheme.secondaryContainer.withValues(alpha: 0.75),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: scheme.outlineVariant.withValues(alpha: 0.6),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.insights_rounded,
                color: scheme.onPrimaryContainer,
                size: 25,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TodayFocusCard extends StatelessWidget {
  const _TodayFocusCard({
    required this.focusSeconds,
    required this.sessionCount,
    required this.estimatedReward,
    required this.onStartFocus,
  });

  final int focusSeconds;
  final int sessionCount;
  final int estimatedReward;
  final VoidCallback onStartFocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = AppTheme.heroGradientFor(theme.brightness);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.pine.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.45 : 0.24,
            ),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -70,
            right: -48,
            child: _DecorativeCircle(
              size: 200,
              color: Colors.white.withValues(alpha: 0.055),
            ),
          ),
          Positioned(
            bottom: -88,
            right: 46,
            child: _DecorativeCircle(
              size: 170,
              color: AppColors.mint.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            top: 28,
            right: 120,
            child: _DecorativeCircle(
              size: 10,
              color: AppColors.lime.withValues(alpha: 0.75),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.lime,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'BUGÜNÜN ODAĞI',
                            style: TextStyle(
                              color: AppColors.mint,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              formatHumanDuration(focusSeconds),
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontSize: 45,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            sessionCount == 0
                                ? 'Bugün henüz odak oturumu tamamlamadın.'
                                : 'Bugün $sessionCount odak oturumu tamamladın.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.76),
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _FocusOrb(sessionCount: sessionCount),
                  ],
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: onStartFocus,
                  icon: const Icon(Icons.play_arrow_rounded, size: 21),
                  label: Text(
                    sessionCount == 0
                        ? 'Odaklanmaya başla'
                        : 'Yeni bir oturum başlat',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.pine,
                    minimumSize: const Size(0, 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 13,
                    ),
                    textStyle: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
                              text: 'Bu oturum +$estimatedReward FOCUS',
                              style: const TextStyle(
                                color: AppColors.tokenGold,
                                fontWeight: FontWeight.w700,
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
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProofSummaryCard extends StatelessWidget {
  const _ProofSummaryCard({
    required this.controller,
    required this.onOpenChain,
    required this.onOpenWallet,
  });

  final AppController controller;
  final VoidCallback onOpenChain;
  final VoidCallback onOpenWallet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final chain = controller.chain;
    if (chain == null) {
      return _ProofUnavailableCard(controller: controller);
    }

    final validation = controller.lastChainValidation;
    final statusColor = validation == null
        ? AppColors.sand
        : validation.isValid
        ? AppColors.lime
        : scheme.error;
    final statusLabel = validation == null
        ? 'DOĞRULA'
        : validation.isValid
        ? 'GEÇERLİ'
        : 'HATALI';

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppTheme.chainGradientFor(theme.brightness),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.deepChain.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.42 : 0.2,
            ),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ChainPattern(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(17, 16, 17, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _ProofDot(),
                        SizedBox(width: 5),
                        Text(
                          'KANIT DEFTERİ',
                          style: TextStyle(
                            color: AppColors.mint,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ChainStatusPill(
                    label: statusLabel,
                    color: statusColor,
                    icon: validation?.isValid == true
                        ? Icons.verified_rounded
                        : Icons.shield_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  const FocusCoin(size: 30),
                  const SizedBox(width: 9),
                  Text(
                    '${controller.focusBalance}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      'FOCUS',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'SON BLOK',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 7.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        shortHash(chain.latestHash, head: 8, tail: 6),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.78),
                          fontFamily: 'monospace',
                          fontSize: 8.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _ProofMetric(
                        label: 'BLOK',
                        value: '${controller.chainHeight}',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    Expanded(
                      child: _ProofMetric(
                        label: 'BEKLEYEN',
                        value: '${controller.pendingChainTransactionCount}',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    Expanded(
                      child: _ProofMetric(
                        label: 'ROZET',
                        value: '${controller.mintedAchievements.length}',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onOpenWallet,
                      icon: const Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 16,
                      ),
                      label: const Text('Cüzdan'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.deepChain,
                        minimumSize: const Size(0, 42),
                        textStyle: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onOpenChain,
                      icon: const Icon(Icons.verified_outlined, size: 16),
                      label: const Text('Defteri aç'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.26),
                        ),
                        minimumSize: const Size(0, 42),
                        textStyle: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProofUnavailableCard extends StatelessWidget {
  const _ProofUnavailableCard({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(Icons.link_off_rounded, color: scheme.error, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Kanıt defteri kapalı',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.chainError ??
                      'Yerel defter yüklenemedi. Yeniden deneyerek devam et.',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 5),
                TextButton.icon(
                  onPressed: controller.retryChainInitialization,
                  icon: const Icon(Icons.refresh_rounded, size: 15),
                  label: const Text('Yeniden dene'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProofDot extends StatelessWidget {
  const _ProofDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: AppColors.lime,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ProofMetric extends StatelessWidget {
  const _ProofMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 7,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
      ],
    );
  }
}

class _FocusOrb extends StatelessWidget {
  const _FocusOrb({required this.sessionCount});

  final int sessionCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 94,
      height: 94,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            Colors.white.withValues(alpha: 0.17),
            Colors.white.withValues(alpha: 0.04),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
          width: 1.2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.mint.withValues(alpha: 0.12),
            blurRadius: 22,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.eco_rounded,
            color: AppColors.mint.withValues(alpha: 0.95),
            size: 21,
          ),
          const SizedBox(height: 2),
          Text(
            '$sessionCount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
              height: 1,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'OTURUM',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            scheme.surfaceContainerLowest,
            accent.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.10 : 0.055,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.72),
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
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent, size: 21),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.count,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final int count;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Text(title, style: theme.textTheme.titleLarge),
              if (count > 0) ...<Widget>[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$count',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSecondaryContainer,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: scheme.secondary,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(actionLabel),
              const SizedBox(width: 2),
              const Icon(Icons.arrow_forward_rounded, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeTaskTile extends StatelessWidget {
  const _HomeTaskTile({
    required this.task,
    required this.rewarded,
    required this.onToggle,
    required this.onTap,
  });

  final StudyTask task;
  final bool rewarded;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: scheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.72),
            ),
          ),
          child: Row(
            children: <Widget>[
              _TaskCheck(completed: task.isCompleted, onTap: onToggle),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? scheme.onSurfaceVariant
                            : scheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: <Widget>[
                        if (task.category != null)
                          _MetaChip(
                            icon: Icons.school_outlined,
                            label: task.category!,
                          ),
                        if (task.dueDate != null)
                          _MetaChip(
                            icon: Icons.event_outlined,
                            label: formatDueDate(task.dueDate!),
                            color: _isOverdue(task)
                                ? scheme.error
                                : scheme.onSurfaceVariant,
                          ),
                        _MetaChip(
                          icon: Icons.toll_rounded,
                          label: task.isCompleted
                              ? rewarded
                                    ? 'Ödendi'
                                    : 'Ödül bekliyor'
                              : '+${FocusChainNetwork.taskReward} FOCUS',
                          color: rewarded
                              ? scheme.secondary
                              : AppColors.tokenGold,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isOverdue(StudyTask task) {
    final dueDate = task.dueDate;
    if (dueDate == null || task.isCompleted) {
      return false;
    }
    return dateOnly(dueDate).isBefore(dateOnly(DateTime.now()));
  }
}

class _TaskCheck extends StatelessWidget {
  const _TaskCheck({required this.completed, required this.onTap});

  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      button: true,
      label: completed
          ? 'Tamamlanmadı olarak işaretle'
          : 'Tamamlandı olarak işaretle',
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: completed ? scheme.secondary : scheme.surfaceContainerLow,
            shape: BoxShape.circle,
            border: Border.all(
              color: completed ? scheme.secondary : scheme.outlineVariant,
              width: 1.4,
            ),
          ),
          child: Icon(
            completed ? Icons.check_rounded : Icons.circle_outlined,
            size: 18,
            color: completed ? scheme.onSecondary : scheme.outline,
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final effectiveColor = color ?? scheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 11, color: effectiveColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: effectiveColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
