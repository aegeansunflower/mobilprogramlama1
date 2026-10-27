// DART KONUSU: Classes & objects — `ConsumerStatefulWidget`, records
// (EndSessionSummary), private widget'lar. Libraries & imports — `show`.

/// Canlı yoklama: 15 sn'de bir yenilenen QR, canlı katılımcılar, bitir.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart' show QrImageView;
import 'package:sarkisla_yoklama/app/providers.dart';
import 'package:sarkisla_yoklama/attendance/attendance.dart';
import 'package:sarkisla_yoklama/attendance/presentation/attendance_providers.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/auth/presentation/auth_controller.dart';
import 'package:sarkisla_yoklama/core/core.dart';
import 'package:sarkisla_yoklama/ui/ui.dart';

/// Canlı oturum ekranı.
final class LiveSessionPage extends ConsumerStatefulWidget {
  const LiveSessionPage({required this.sessionId, super.key});

  final String sessionId;

  @override
  ConsumerState<LiveSessionPage> createState() => _LiveSessionPageState();
}

final class _LiveSessionPageState extends ConsumerState<LiveSessionPage> {
  bool _ending = false;

  void _snack(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  Future<void> _end(AttendanceSession session) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.endSessionConfirmTitle),
        content: Text(l10n.endSessionConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final user = ref.read(currentUserProvider);
    if (user is! Instructor) return;
    setState(() => _ending = true);
    final signer = await ref.read(signerProvider(user.uid).future);
    final result = await ref
        .read(endSessionProvider)
        .call(sessionId: session.id, instructor: user, signer: signer);
    if (!mounted) return;
    setState(() => _ending = false);
    switch (result) {
      case Ok(:final value):
        await showDialog<void>(
          context: context,
          builder: (_) => _SealedDialog(summary: value),
        );
        if (mounted) context.pop();
      case Err(:final failure):
        _snack(failure.message);
    }
  }

  Future<void> _simulate(AttendanceSession session) async {
    final result = await DemoActions.simulateStudent(ref, session);
    if (!mounted) return;
    switch (result) {
      case null:
        _snack(context.l10n.allStudentsArrived);
      case Err(:final failure):
        _snack(failure.message);
      case Ok():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final session = ref.watch(sessionProvider(widget.sessionId));
    final isDemo = ref.watch(appConfigProvider).isDemo;
    return AppScaffold(
      title: l10n.liveSession,
      body: AsyncValueView(
        value: session,
        data: (s) {
          if (s == null) return const SizedBox.shrink();
          final roster = ref.watch(rosterProvider(s.courseId));
          final checkIns = ref.watch(checkInsProvider(s.id));
          final total = roster.value?.length ?? 0;
          final arrived = checkIns.value ?? const <PendingCheckIn>[];
          return ListView(
            padding: const EdgeInsets.all(Space.lg),
            children: [
              _QrCard(sessionId: s.id),
              const SizedBox(height: Space.lg),
              if (isDemo && s.isOpen)
                OutlinedButton.icon(
                  onPressed: () => _simulate(s),
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  label: Text(l10n.simulateStudent),
                ),
              SectionHeader(
                l10n.participants,
                trailing: Text(
                  l10n.participantsProgress(arrived.length, total),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              _Progress(value: total == 0 ? 0 : arrived.length / total),
              const SizedBox(height: Space.md),
              if (arrived.isEmpty)
                EmptyState(
                  icon: Icons.groups_2_outlined,
                  message: l10n.noParticipantsYet,
                )
              else
                for (final c in arrived.reversed)
                  _ParticipantTile(
                    key: ValueKey(c.record.studentId),
                    checkIn: c,
                  ).enter(context),
              const SizedBox(height: Space.xl),
              if (s.isOpen)
                PrimaryButton(
                  label: l10n.endSession,
                  icon: Icons.lock_rounded,
                  loading: _ending,
                  onPressed: () => _end(s),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// QR ve geri sayım halkası.
final class _QrCard extends ConsumerWidget {
  const _QrCard({required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final p = context.palette;
    final live = ref.watch(liveQrProvider(sessionId));
    return SurfaceCard(
      padding: const EdgeInsets.all(Space.xl),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: const EdgeInsets.all(Space.lg),
              decoration: const BoxDecoration(
                // QR her temada beyaz zemin üzerinde siyah: tarayıcılar için
                // en yüksek kontrast.
                color: Colors.white,
                borderRadius: Radii.card,
              ),
              child: live == null
                  ? const Center(child: CircularProgressIndicator())
                  : AnimatedSwitcher(
                      duration: context.reduceMotion
                          ? Duration.zero
                          : MotionDurations.medium,
                      child: Semantics(
                        key: ValueKey(live.token.nonce),
                        label: l10n.qrSemantics,
                        image: true,
                        child: QrImageView(
                          data: live.token.encode(),
                          gapless: false,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: Space.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: 28,
                child: CircularProgressIndicator(
                  value: live?.progress ?? 0,
                  strokeWidth: 4,
                  color: p.accent,
                  backgroundColor: p.accent.withValues(alpha: 0.15),
                ),
              ),
              const SizedBox(width: Space.md),
              Text(
                l10n.qrRefreshIn(live?.secondsLeft ?? 15),
                style: TextStyle(color: p.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _Progress extends StatelessWidget {
  const _Progress({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ClipRRect(
      borderRadius: Radii.pill,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: value),
        duration: context.reduceMotion ? Duration.zero : MotionDurations.slow,
        curve: Motion.gentle,
        builder: (context, v, _) => LinearProgressIndicator(
          value: v,
          minHeight: 10,
          color: p.present,
          backgroundColor: p.present.withValues(alpha: 0.15),
        ),
      ),
    );
  }
}

final class _ParticipantTile extends StatelessWidget {
  const _ParticipantTile({required this.checkIn, super.key});

  final PendingCheckIn checkIn;

  @override
  Widget build(BuildContext context) {
    final r = checkIn.record;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: SurfaceCard(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.lg,
          vertical: Space.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(checkIn.studentName),
                  Text(
                    '${r.studentNumber} · ${r.timestamp.trTime}',
                    style: AppTheme.mono(context, size: 12),
                  ),
                ],
              ),
            ),
            StatusChip(r.status, dense: true),
          ],
        ),
      ),
    );
  }
}

/// Blok mühürlendi diyaloğu.
final class _SealedDialog extends StatelessWidget {
  const _SealedDialog({required this.summary});

  final EndSessionSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SuccessCheck(semanticLabel: l10n.endSessionDone(summary.block.index)),
          const SizedBox(height: Space.lg),
          Text(
            l10n.endSessionDone(summary.block.index),
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Space.md),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            alignment: WrapAlignment.center,
            children: [
              const StatusChip(Present(), dense: true),
              Text('${summary.present}'),
              const StatusChip(Absent(), dense: true),
              Text('${summary.absent}'),
            ],
          ),
          const SizedBox(height: Space.md),
          HashText(summary.block.hash, label: l10n.blockHash),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}
