import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_time_utils.dart';
import '../../core/utils/duration_formatter.dart';
import '../../models/focus_session.dart';
import '../../state/app_controller.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/statistic_card.dart';
import 'statistics_calculator.dart';

/// Gerçek kayıtlardan hesaplanan özetleri ve son yedi gün grafiğini gösterir.
class StatisticsScreen extends StatelessWidget {
  /// İstatistik ekranını merkezi denetleyiciyle oluşturur.
  const StatisticsScreen({super.key, required this.controller});

  /// Uygulamanın merkezi durumu.
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final weeklyDays = controller.lastSevenDays;
    final weeklyTotal = controller.lastSevenDaysFocusSeconds;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 48),
      children: <Widget>[
        Text(
          'Tüm değerler gerçek oturum, görev ve kanıt defteri '
          'kayıtlarından hesaplanır.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 18),
        _StatRow(
          first: StatisticCard(
            icon: Icons.timelapse_rounded,
            label: 'Toplam odak süresi',
            value: formatHumanDuration(controller.totalFocusSeconds),
            caption:
                '${controller.totalCompletedFocusSessionCount} tamamlanmış oturum',
            accentColor: scheme.secondary,
          ),
          second: StatisticCard(
            icon: Icons.check_circle_outline_rounded,
            label: 'Toplam odak oturumu',
            value: '${controller.totalCompletedFocusSessionCount}',
            caption: 'Tamamlanan odak',
            accentColor: AppColors.sand,
          ),
        ),
        const SizedBox(height: 12),
        _StatRow(
          first: StatisticCard(
            icon: Icons.today_outlined,
            label: 'Bugünkü odak süresi',
            value: formatHumanDuration(controller.todayFocusSeconds),
            caption: '${controller.todayFocusSessionCount} oturum',
            accentColor: AppColors.sky,
          ),
          second: StatisticCard(
            icon: Icons.task_alt_rounded,
            label: 'Bugün tamamlanan görev',
            value: '${controller.todayCompletedTaskCount}',
            caption: 'Görev kaydı',
            accentColor: AppColors.coral,
          ),
        ),
        const SizedBox(height: 12),
        _StatRow(
          first: StatisticCard(
            icon: Icons.toll_rounded,
            label: 'FOCUS bakiyesi',
            value: '${controller.focusBalance}',
            caption:
                '${controller.mintedAchievements.length} rozet • '
                '${controller.pendingChainTransactionCount} bekleyen işlem',
            accentColor: AppColors.tokenGold,
          ),
          second: StatisticCard(
            icon: Icons.verified_outlined,
            label: 'Kanıt defteri',
            value: '${controller.chainHeight}',
            caption:
                '${controller.totalMintedFocus} FOCUS basıldı • '
                'blok yüksekliği',
            accentColor: AppColors.chainTeal,
          ),
        ),
        const SizedBox(height: 16),
        _WeeklyCard(days: weeklyDays, totalSeconds: weeklyTotal),
        const SizedBox(height: 14),
        if (controller.recentFocusSessions.isEmpty)
          const EmptyState(
            icon: Icons.insights_rounded,
            title: 'Henüz odak kaydı yok',
            message:
                'Odak sekmesinden ilk oturumunu tamamladığında toplam süre, '
                'oturum sayısı ve son yedi gün grafiği burada görünecek.',
          )
        else
          _RecentSessionsCard(sessions: controller.recentFocusSessions),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.first, required this.second});

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: first),
          const SizedBox(width: 12),
          Expanded(child: second),
        ],
      ),
    );
  }
}

class _WeeklyCard extends StatelessWidget {
  const _WeeklyCard({required this.days, required this.totalSeconds});

  final List<DailyFocus> days;
  final int totalSeconds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            scheme.surfaceContainerLowest,
            scheme.primaryContainer.withValues(alpha: 0.28),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.72),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: scheme.secondary.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: scheme.secondary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Son 7 gün', style: theme.textTheme.titleMedium),
                    Text(
                      '${formatHumanDuration(totalSeconds)} toplam odak',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Bu hafta',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(height: 178, child: _WeeklyBarChart(days: days)),
          if (totalSeconds == 0) ...<Widget>[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: scheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Henüz odak kaydı yok. İlk oturumunu tamamladığında '
                      'grafik burada dolmaya başlayacak.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  const _WeeklyBarChart({required this.days});

  final List<DailyFocus> days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final maxSeconds = days.fold<int>(
      0,
      (maximum, day) => math.max(maximum, day.seconds),
    );
    final today = dateOnly(DateTime.now());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: days
          .map((day) {
            final isToday = isSameDay(day.date, today);
            final fraction = maxSeconds == 0 ? 0.0 : day.seconds / maxSeconds;
            final barHeight = day.seconds == 0 ? 7.0 : 14 + fraction * 108;

            return Expanded(
              child: Tooltip(
                message:
                    '${formatShortWeekday(day.date)} '
                    '${formatShortTurkishDate(day.date)}: '
                    '${formatHumanDuration(day.seconds)}',
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (day.seconds > 0)
                      Text(
                        '${(day.seconds / 60).round()}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isToday
                              ? scheme.primary
                              : scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                    const SizedBox(height: 5),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      width: 22,
                      height: barHeight,
                      decoration: BoxDecoration(
                        gradient: day.seconds == 0
                            ? null
                            : LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: isToday
                                    ? <Color>[
                                        scheme.primary,
                                        scheme.secondary,
                                        AppColors.lime,
                                      ]
                                    : <Color>[
                                        scheme.secondary.withValues(alpha: 0.3),
                                        scheme.secondary.withValues(alpha: 0.8),
                                      ],
                              ),
                        color: day.seconds == 0
                            ? scheme.surfaceContainer
                            : null,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatShortWeekday(day.date),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isToday
                            ? scheme.primary
                            : scheme.onSurfaceVariant,
                        fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${day.date.day}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant.withValues(alpha: 0.65),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}

class _RecentSessionsCard extends StatelessWidget {
  const _RecentSessionsCard({required this.sessions});

  final List<FocusSession> sessions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.72),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: scheme.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.history_rounded,
                  size: 19,
                  color: scheme.secondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Son odak oturumları',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${sessions.length}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (var index = 0; index < sessions.length; index++) ...<Widget>[
            _SessionRow(session: sessions[index]),
            if (index != sessions.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session});

  final FocusSession session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  scheme.secondaryContainer,
                  scheme.primaryContainer,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: scheme.onSecondaryContainer,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${formatHumanDuration(session.actualDurationSeconds)} odak',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${formatShortTurkishDate(session.effectiveDate)} • '
                  '${formatTime(session.effectiveDate)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle_rounded,
            size: 18,
            color: scheme.secondary.withValues(alpha: 0.8),
          ),
        ],
      ),
    );
  }
}
