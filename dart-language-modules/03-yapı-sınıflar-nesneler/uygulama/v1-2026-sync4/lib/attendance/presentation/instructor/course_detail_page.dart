// DART KONUSU: Classes & objects — `ConsumerStatefulWidget`, records,
// extension (`AttendanceLedgerX`) kullanımı, private yardımcı sınıflar.
// Metadata — `@RoleRestricted` metotları çağıran arayüz.

/// Ders detayı: oturum başlat, öğrenci bazlı devam, düzeltme, geçmiş.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sarkisla_yoklama/app/providers.dart';
import 'package:sarkisla_yoklama/attendance/attendance.dart';
import 'package:sarkisla_yoklama/attendance/presentation/attendance_providers.dart';
import 'package:sarkisla_yoklama/attendance/presentation/instructor/instructor_pages.dart'
    show CourseCodeBadge;
import 'package:sarkisla_yoklama/attendance/presentation/shared_widgets.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/auth/presentation/auth_controller.dart';
import 'package:sarkisla_yoklama/core/core.dart';
import 'package:sarkisla_yoklama/ui/ui.dart';

/// Ders detayı.
final class CourseDetailPage extends ConsumerStatefulWidget {
  const CourseDetailPage({required this.courseId, super.key});

  final String courseId;

  @override
  ConsumerState<CourseDetailPage> createState() => _CourseDetailPageState();
}

final class _CourseDetailPageState extends ConsumerState<CourseDetailPage> {
  bool _requireLocation = false;
  bool _starting = false;

  Future<void> _start(Course course) async {
    final user = ref.read(currentUserProvider);
    if (user is! Instructor) return;
    setState(() => _starting = true);
    final result = await ref
        .read(attendanceRepositoryProvider)
        .startSession(
          course: course,
          instructor: user,
          at: ref.read(clockProvider).now(),
          requireLocation: _requireLocation,
        );
    if (!mounted) return;
    setState(() => _starting = false);
    switch (result) {
      case Ok(:final value):
        ref.invalidate(sessionsProvider(course.id));
        await context.push('/ogretim/oturum/${value.id}');
      case Err(:final failure):
        _snack(failure.message);
    }
  }

  void _snack(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final course = ref.watch(courseProvider(widget.courseId));
    return AppScaffold(
      title: l10n.coursesTitle,
      actions: [
        IconButton(
          tooltip: l10n.reports,
          icon: const Icon(Icons.insights_rounded),
          onPressed: () =>
              context.push('/ogretim/ders/${widget.courseId}/rapor'),
        ),
      ],
      body: AsyncValueView(
        value: course,
        data: (c) => c == null ? const SizedBox.shrink() : _body(context, c),
      ),
    );
  }

  Widget _body(BuildContext context, Course course) {
    final l10n = context.l10n;
    final p = context.palette;
    final sessions = ref.watch(sessionsProvider(course.id));
    final roster = ref.watch(rosterProvider(course.id));
    final ledger = ref.watch(ledgerProvider);
    final open = sessions.value?.where((s) => s.isOpen).firstOrNull;

    return ListView(
      padding: const EdgeInsets.all(Space.lg),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CourseCodeBadge(course: course),
        ),
        const SizedBox(height: Space.sm),
        Text(course.name, style: Theme.of(context).textTheme.headlineMedium),
        Text(
          '${course.department.label} · '
          '${l10n.studentsCount(course.studentIds.length)}',
          style: TextStyle(color: p.textMuted),
        ),
        const SizedBox(height: Space.xl),
        SurfaceCard(
          child: Column(
            children: [
              if (open == null)
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  value: _requireLocation,
                  onChanged: (v) => setState(() => _requireLocation = v),
                  title: Text(l10n.requireLocation),
                  subtitle: Text(l10n.requireLocationHint),
                  secondary: const Icon(Icons.location_on_outlined),
                ),
              const SizedBox(height: Space.sm),
              PrimaryButton(
                label: open == null ? l10n.startSession : l10n.continueSession,
                icon: open == null
                    ? Icons.qr_code_2_rounded
                    : Icons.play_arrow_rounded,
                loading: _starting,
                onPressed: open == null
                    ? () => _start(course)
                    : () => context.push('/ogretim/oturum/${open.id}'),
              ),
            ],
          ),
        ).enter(context),
        SectionHeader(l10n.studentStats),
        AsyncValueView(
          value: roster,
          data: (students) => Column(
            children: [
              for (final (i, s) in students.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.sm),
                  child: _StudentRow(
                    student: s,
                    summary: ledger.summaryFor(course, s.uid),
                    onTap: () => _showStudent(context, course, s),
                  ).enter(context, index: i),
                ),
            ],
          ),
        ),
        SectionHeader(l10n.history),
        AsyncValueView(
          value: sessions,
          data: (list) => list.isEmpty
              ? EmptyState(icon: Icons.history_rounded, message: l10n.noHistory)
              : Column(
                  children: [
                    for (final (i, s) in list.indexed)
                      _SessionRow(session: s).enter(context, index: i),
                  ],
                ),
        ),
      ],
    );
  }

  Future<void> _showStudent(
    BuildContext context,
    Course course,
    Student student,
  ) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _StudentRecordsSheet(course: course, student: student),
  );
}

final class _StudentRow extends StatelessWidget {
  const _StudentRow({
    required this.student,
    required this.summary,
    required this.onTap,
  });

  final Student student;
  final AttendanceSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final warn = summary.isOverLimit || summary.isNearLimit;
    return SurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: Space.lg,
        vertical: Space.md,
      ),
      borderColor: summary.isOverLimit ? p.absent.withValues(alpha: 0.5) : null,
      child: Row(
        children: [
          RateRing(rate: summary.rate),
          const SizedBox(width: Space.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.displayName),
                Text(
                  student.studentNumber,
                  style: AppTheme.mono(context, size: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${summary.absent} / ${summary.course.maxAbsences}',
                style: TextStyle(
                  color: warn ? p.absent : p.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (warn)
                Icon(Icons.warning_amber_rounded, size: 18, color: p.absent),
            ],
          ),
        ],
      ),
    );
  }
}

final class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session});

  final AttendanceSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final p = context.palette;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minTileHeight: Sizes.minTouch,
      leading: Icon(
        session.isOpen ? Icons.radio_button_checked : Icons.link_rounded,
        color: session.isOpen ? p.late : p.present,
      ),
      title: Text(session.startedAt.trDateTime),
      subtitle: Text(
        session.isOpen
            ? l10n.openSession
            : l10n.sessionBlock(session.blockIndex ?? 0),
      ),
      trailing: session.isOpen ? const Icon(Icons.chevron_right) : null,
      onTap: session.isOpen
          ? () => context.push('/ogretim/oturum/${session.id}')
          : null,
    );
  }
}

/// Öğrencinin kayıtları + düzeltme.
final class _StudentRecordsSheet extends ConsumerWidget {
  const _StudentRecordsSheet({required this.course, required this.student});

  final Course course;
  final Student student;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final records = ref
        .watch(ledgerProvider)
        .effectiveFor(course.id)
        .where((e) => e.studentId == student.uid)
        .toList()
        .reversed
        .toList();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student.displayName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(student.studentNumber, style: AppTheme.mono(context)),
            const SizedBox(height: Space.md),
            if (records.isEmpty)
              EmptyState(icon: Icons.history_rounded, message: l10n.noHistory)
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: records.length,
                  itemBuilder: (context, i) {
                    final e = records[i];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(e.original.timestamp.trDateTime),
                      subtitle: e.isCorrected
                          ? Text('${l10n.corrected}: ${e.correction!.reason}')
                          : HashText(e.recordHash),
                      trailing: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: Space.xs,
                        children: [
                          StatusChip(e.status, dense: true),
                          IconButton(
                            tooltip: l10n.correct,
                            icon: const Icon(Icons.edit_note_rounded),
                            onPressed: () => showDialog<void>(
                              context: context,
                              builder: (_) => _CorrectionDialog(target: e),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Düzeltme bloğu ekleme diyaloğu.
final class _CorrectionDialog extends ConsumerStatefulWidget {
  const _CorrectionDialog({required this.target});

  final EffectiveAttendance target;

  @override
  ConsumerState<_CorrectionDialog> createState() => _CorrectionDialogState();
}

final class _CorrectionDialogState extends ConsumerState<_CorrectionDialog> {
  late final TextEditingController _reason = TextEditingController();
  String _choice = 'present';
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  AttendanceStatus get _status => switch (_choice) {
    'absent' => const Absent(),
    'excused' => Excused(_reason.text.trim()),
    _ => const Present(),
  };

  Future<void> _save() async {
    final user = ref.read(currentUserProvider);
    if (user is! Instructor) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final signer = await ref.read(signerProvider(user.uid).future);
    final result = await ref
        .read(correctAttendanceProvider)
        .call(
          target: widget.target,
          newStatus: _status,
          reason: _reason.text,
          instructor: user,
          signer: signer,
        );
    if (!mounted) return;
    switch (result) {
      case Ok():
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.correctionSaved)));
      case Err(:final failure):
        setState(() {
          _saving = false;
          _error = failure.message;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.correctionTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.correctionHint),
            const SizedBox(height: Space.lg),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'present',
                  label: Text(l10n.statusPresent),
                ),
                ButtonSegment(value: 'absent', label: Text(l10n.statusAbsent)),
                ButtonSegment(
                  value: 'excused',
                  label: Text(l10n.statusExcused),
                ),
              ],
              selected: {_choice},
              onSelectionChanged: (s) => setState(() => _choice = s.first),
            ),
            const SizedBox(height: Space.lg),
            TextField(
              controller: _reason,
              maxLines: 2,
              decoration: InputDecoration(labelText: l10n.correctionReason),
            ),
            if (_error != null) ...[
              const SizedBox(height: Space.md),
              ErrorBanner(_error!),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(l10n.confirm),
        ),
      ],
    );
  }
}
