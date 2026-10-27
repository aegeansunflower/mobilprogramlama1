// DART KONUSU: Classes & objects — `ConsumerWidget`, extension
// (`AttendanceLedgerX.summaryFor`), records. Class modifiers — `final class`.

/// Öğrenci: ana sayfa, makbuz ve ders geçmişi.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sarkisla_yoklama/attendance/attendance.dart';
import 'package:sarkisla_yoklama/attendance/presentation/attendance_providers.dart';
import 'package:sarkisla_yoklama/attendance/presentation/instructor/instructor_pages.dart'
    show CourseCodeBadge, CourseTile;
import 'package:sarkisla_yoklama/attendance/presentation/shared_widgets.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/auth/presentation/auth_controller.dart';
import 'package:sarkisla_yoklama/core/core.dart';
import 'package:sarkisla_yoklama/ui/ui.dart';

/// Öğrenci ana sayfası.
final class StudentHomePage extends ConsumerWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(currentUserProvider);
    if (user is! Student) return const SizedBox.shrink();
    final courses = ref.watch(studentCoursesProvider);
    final ledger = ref.watch(ledgerProvider);

    return AppScaffold(
      floating: FloatingActionButton.extended(
        onPressed: () => context.push('/ogrenci/tara'),
        icon: const Icon(Icons.qr_code_scanner_rounded),
        label: Text(l10n.scanQr),
      ).pop(context, delay: MotionDurations.slow),
      body: AsyncValueView(
        value: courses,
        data: (list) {
          final summaries = [
            for (final c in list) ledger.summaryFor(c, user.uid),
          ];
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              Space.lg,
              Space.lg,
              Space.lg,
              96, // FAB için boşluk
            ),
            children: [
              UserHeader(
                subtitle: '${user.studentNumber} · ${user.department.code}',
              ).enter(context),
              const SizedBox(height: Space.md),
              Row(
                children: [
                  Icon(
                    Icons.phonelink_lock_rounded,
                    size: Sizes.iconSm,
                    color: context.palette.textMuted,
                  ),
                  const SizedBox(width: Space.xs),
                  Text(
                    l10n.deviceBound,
                    style: TextStyle(color: context.palette.textMuted),
                  ),
                ],
              ),
              for (final s in summaries)
                if (s.isOverLimit || s.isNearLimit)
                  Padding(
                    padding: const EdgeInsets.only(top: Space.md),
                    child: ErrorBanner(
                      s.isOverLimit
                          ? l10n.absenceOver(s.course.code)
                          : l10n.absenceWarning(
                              s.course.code,
                              s.remainingAbsences,
                            ),
                    ).enter(context, index: 1),
                  ),
              const SizedBox(height: Space.lg),
              const ChainStatusCard().enter(context, index: 2),
              SectionHeader(l10n.myCourses),
              for (final (i, s) in summaries.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.md),
                  child: CourseTile(
                    course: s.course,
                    onTap: () => context.push('/ogrenci/ders/${s.course.id}'),
                    trailing: Column(
                      children: [
                        RateRing(rate: s.rate),
                        const SizedBox(height: Space.xs),
                        Text(
                          l10n.remainingAbsences(s.remainingAbsences),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ).enter(context, index: 3 + i),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Yoklama makbuzu: işlem hash'i, ardından blok + "Doğrulandı ✓".
final class ReceiptPage extends ConsumerWidget {
  const ReceiptPage({required this.checkIn, super.key});

  final PendingCheckIn checkIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final p = context.palette;
    final state = verificationOf(ref, checkIn.transactionHash);
    final receipt = ref
        .watch(receiptProvider(checkIn.transactionHash.hex))
        .value;
    return AppScaffold(
      title: l10n.receiptTitle,
      body: ListView(
        padding: const EdgeInsets.all(Space.lg),
        children: [
          const SizedBox(height: Space.lg),
          Center(child: SuccessCheck(semanticLabel: l10n.receiptTitle)),
          const SizedBox(height: Space.lg),
          Text(
            l10n.receiptTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ).enter(context, index: 2),
          const SizedBox(height: Space.sm),
          Center(child: StatusChip(checkIn.record.status))
              .enter(context, index: 3),
          const SizedBox(height: Space.xl),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HashText(
                  checkIn.transactionHash,
                  label: l10n.transactionHash,
                  full: true,
                ),
                const Divider(height: Space.xl),
                VerifiedBadge(state),
                const SizedBox(height: Space.sm),
                Text(
                  receipt == null
                      ? l10n.blockPending
                      : l10n.verifiedDetail(receipt.blockIndex),
                  style: TextStyle(color: p.textMuted),
                ),
                if (receipt != null)
                  HashText(receipt.blockHash, label: l10n.blockHash),
              ],
            ),
          ).enter(context, index: 4),
          const SizedBox(height: Space.xl),
          PrimaryButton(
            label: l10n.close,
            onPressed: () => context.go('/ogrenci'),
          ),
        ],
      ),
    );
  }
}

/// Öğrencinin bir dersteki geçmişi.
final class StudentCoursePage extends ConsumerWidget {
  const StudentCoursePage({required this.courseId, super.key});

  final String courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(currentUserProvider);
    final course = ref.watch(courseProvider(courseId));
    final ledger = ref.watch(ledgerProvider);
    return AppScaffold(
      title: l10n.history,
      body: AsyncValueView(
        value: course,
        data: (c) {
          if (c == null || user == null) return const SizedBox.shrink();
          final summary = ledger.summaryFor(c, user.uid);
          final records = ledger
              .effectiveFor(c.id)
              .where((e) => e.studentId == user.uid)
              .toList()
              .reversed
              .toList();
          return ListView(
            padding: const EdgeInsets.all(Space.lg),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CourseCodeBadge(course: c),
                        const SizedBox(height: Space.sm),
                        Text(
                          c.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(l10n.remainingAbsences(summary.remainingAbsences)),
                      ],
                    ),
                  ),
                  RateRing(rate: summary.rate, size: 72),
                ],
              ),
              SectionHeader(l10n.history),
              if (records.isEmpty)
                EmptyState(icon: Icons.history_rounded, message: l10n.noHistory)
              else
                for (final (i, e) in records.indexed)
                  _RecordTile(entry: e).enter(context, index: i),
            ],
          );
        },
      ),
    );
  }
}

final class _RecordTile extends ConsumerWidget {
  const _RecordTile({required this.entry});

  final EffectiveAttendance entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(entry.original.timestamp.trDateTime)),
                StatusChip(entry.status, dense: true),
              ],
            ),
            if (entry.correction case final fix?)
              Text(
                '${l10n.corrected}: ${fix.reason}',
                style: TextStyle(color: context.palette.textMuted),
              ),
            HashText(entry.recordHash, label: l10n.transactionHash),
            VerifiedBadge(verificationOf(ref, entry.recordHash)),
          ],
        ),
      ),
    );
  }
}
