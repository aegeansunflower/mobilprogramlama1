// DART KONUSU: Libraries & imports — bu kütüphane router'da
// `deferred as reports` ile tembel yüklenir (fl_chart + pdf ağır
// bağımlılıklardır). `as` önekleri ve `show`. Classes & objects —
// `ConsumerWidget`, records.

/// Rapor ekranı: oturum grafiği, öğrenci tablosu, PDF/CSV paylaşımı.
library;

import 'dart:convert' show utf8;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show FutureProviderFamily;
import 'package:sarkisla_yoklama/app/providers.dart';
import 'package:sarkisla_yoklama/attendance/presentation/attendance_providers.dart';
import 'package:sarkisla_yoklama/attendance/presentation/reports/course_report.dart';
import 'package:sarkisla_yoklama/attendance/presentation/shared_widgets.dart';
import 'package:sarkisla_yoklama/ui/ui.dart';
import 'package:share_plus/share_plus.dart' show ShareParams, SharePlus, XFile;

/// Zincir ya da oturumlar değişince rapor yeniden hesaplanır.
final FutureProviderFamily<CourseReport?, String> _reportProvider =
    FutureProvider.family((ref, courseId) async {
      final course = await ref.watch(courseProvider(courseId).future);
      if (course == null) return null;
      return CourseReport.build(
        course: course,
        roster: await ref.watch(rosterProvider(courseId).future),
        sessions: await ref.watch(sessionsProvider(courseId).future),
        ledger: ref.watch(ledgerProvider),
        now: ref.read(clockProvider).now(),
      );
    });

/// Rapor ekranı.
final class ReportPage extends ConsumerWidget {
  const ReportPage({required this.courseId, super.key});

  final String courseId;

  Future<void> _sharePdf(WidgetRef ref, CourseReport report) async {
    final bytes = await report.toPdf(
      regularFont: await rootBundle.load('assets/fonts/Inter-Regular.ttf'),
      boldFont: await rootBundle.load('assets/fonts/Inter-SemiBold.ttf'),
    );
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            bytes,
            mimeType: 'application/pdf',
            name: '${report.course.code}_yoklama.pdf',
          ),
        ],
        subject: '${report.course.code} yoklama raporu',
      ),
    );
  }

  Future<void> _shareCsv(CourseReport report) => SharePlus.instance.share(
    ShareParams(
      files: [
        XFile.fromData(
          utf8.encode(report.toCsv()),
          mimeType: 'text/csv',
          name: '${report.course.code}_yoklama.csv',
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return AppScaffold(
      title: l10n.reports,
      body: AsyncValueView(
        value: ref.watch(_reportProvider(courseId)),
        data: (report) {
          if (report == null) return const SizedBox.shrink();
          return ListView(
            padding: const EdgeInsets.all(Space.lg),
            children: [
              Text(
                '${report.course.code} · ${report.course.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SectionHeader(l10n.weeklyTrend),
              SurfaceCard(
                child: SizedBox(
                  height: 220,
                  child: report.sessions.isEmpty
                      ? EmptyState(
                          icon: Icons.bar_chart_rounded,
                          message: l10n.noHistory,
                        )
                      : _SessionChart(report: report),
                ),
              ).enter(context),
              const SizedBox(height: Space.md),
              const _Legend(),
              SectionHeader(l10n.studentStats),
              for (final (i, (:student, :summary)) in report.rows.indexed)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: RateRing(rate: summary.rate, size: 44),
                  title: Text(student.displayName),
                  subtitle: Text(student.studentNumber),
                  trailing: Text(
                    '${summary.absent}/${report.course.maxAbsences}',
                  ),
                ).enter(context, index: i),
              const SizedBox(height: Space.xl),
              PrimaryButton(
                label: l10n.exportPdf,
                icon: Icons.picture_as_pdf_rounded,
                onPressed: () => _sharePdf(ref, report),
              ),
              const SizedBox(height: Space.md),
              OutlinedButton.icon(
                onPressed: () => _shareCsv(report),
                icon: const Icon(Icons.table_view_rounded),
                label: Text(l10n.exportCsv),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Oturum başına yığılmış çubuk grafik.
final class _SessionChart extends StatelessWidget {
  const _SessionChart({required this.report});

  final CourseReport report;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return BarChart(
      duration: context.reduceMotion ? Duration.zero : MotionDurations.slow,
      BarChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                meta: meta,
                child: Text('${value.toInt() + 1}'),
              ),
            ),
          ),
        ),
        barGroups: [
          for (final (i, t) in report.sessions.indexed)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: (t.present + t.late + t.excused + t.absent).toDouble(),
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                  rodStackItems: [
                    BarChartRodStackItem(0, t.present.toDouble(), p.present),
                    BarChartRodStackItem(
                      t.present.toDouble(),
                      (t.present + t.late).toDouble(),
                      p.late,
                    ),
                    BarChartRodStackItem(
                      (t.present + t.late).toDouble(),
                      (t.present + t.late + t.excused).toDouble(),
                      p.excused,
                    ),
                    BarChartRodStackItem(
                      (t.present + t.late + t.excused).toDouble(),
                      (t.present + t.late + t.excused + t.absent).toDouble(),
                      p.absent,
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Renk + metin göstergesi (bilgi yalnızca renkle verilmez).
final class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final p = context.palette;
    return Wrap(
      spacing: Space.lg,
      runSpacing: Space.sm,
      children: [
        for (final (color, label) in [
          (p.present, l10n.statusPresent),
          (p.late, l10n.statusLate(0).split(' ').first),
          (p.excused, l10n.statusExcused),
          (p.absent, l10n.statusAbsent),
        ])
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: Space.xs),
              Text(label),
            ],
          ),
      ],
    );
  }
}
