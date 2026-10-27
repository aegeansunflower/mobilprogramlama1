// DART KONUSU: Class modifiers — sealed `ChainValidation` / `ChainBroken`
// üzerinde eksiksiz switch (her bozulma türü için ayrı açıklama). Classes &
// objects — `ConsumerWidget`, private widget'lar, records.

/// Blok zinciri gezgini ve kurcalama tespiti ekranı.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sarkisla_yoklama/app/providers.dart';
import 'package:sarkisla_yoklama/attendance/attendance.dart';
import 'package:sarkisla_yoklama/attendance/presentation/attendance_providers.dart';
import 'package:sarkisla_yoklama/attendance/presentation/shared_widgets.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart';
import 'package:sarkisla_yoklama/core/core.dart';
import 'package:sarkisla_yoklama/ui/ui.dart';

/// Zincir sayfası. Bozulan blok kırmızıyla vurgulanır.
final class ChainPage extends ConsumerWidget {
  const ChainPage({super.key});

  Future<void> _tamper(BuildContext context, WidgetRef ref) async {
    final blocks = ref.read(chainBlocksProvider).value ?? const [];
    final target = blocks.where((b) => !b.isGenesis).lastOrNull;
    if (target == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.tamperNeedsBlock)));
      return;
    }
    // Saldırgan, ilk kaydın durumunu "Katıldı" yapıyor.
    await ref.read(localChainProvider).simulateTamper(target.index, (json) {
      final txs = List<Object?>.from(json['transactions']! as List);
      final first = Map<String, Object?>.from(txs.first! as Map);
      final data = Map<String, Object?>.from(first['data']! as Map);
      if (first['type'] == AttendanceRecord.kind) {
        data['status'] = const Present().toJson();
        data['studentNumber'] = '${data['studentNumber']}*';
      } else {
        data['reason'] = 'kurcalandı';
      }
      txs[0] = {...first, 'data': data};
      return {...json, 'transactions': txs};
    });
    ref.invalidate(chainValidationProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final blocks = ref.watch(chainBlocksProvider);
    final validation = ref.watch(chainValidationProvider).value;
    final brokenAt = validation is ChainBroken ? validation.blockIndex : null;
    final isDemo = ref.watch(appConfigProvider).isDemo;

    return AppScaffold(
      title: l10n.chainTitle,
      actions: [
        IconButton(
          tooltip: l10n.validateAgain,
          icon: const Icon(Icons.refresh),
          onPressed: () => ref.invalidate(chainValidationProvider),
        ),
      ],
      body: AsyncValueView(
        value: blocks,
        data: (list) => ListView(
          padding: const EdgeInsets.all(Space.lg),
          children: [
            const ChainStatusCard().enter(context),
            if (validation case final ChainBroken broken
                when broken is MerkleMismatch ||
                    broken is HashMismatch ||
                    broken is BrokenLink) ...[
              const SizedBox(height: Space.md),
              _BrokenExplanation(broken: broken).enter(context, index: 1),
            ],
            if (isDemo) ...[
              const SizedBox(height: Space.md),
              Text(
                l10n.tamperExplain,
                style: TextStyle(color: context.palette.textMuted),
              ),
              const SizedBox(height: Space.sm),
              OutlinedButton.icon(
                onPressed: () => _tamper(context, ref),
                icon: const Icon(Icons.bug_report_outlined),
                label: Text(l10n.simulateTamper),
              ),
            ],
            SectionHeader(
              l10n.chainTitle,
              trailing: Text(
                'PoA · Ed25519',
                style: AppTheme.mono(context, size: 11),
              ),
            ),
            for (final (i, block) in list.reversed.indexed)
              _BlockTile(
                block: block,
                broken: brokenAt == block.index,
              ).enter(context, index: i),
          ],
        ),
      ),
    );
  }
}

/// Bozulma türüne göre ayrıntılı açıklama.
final class _BrokenExplanation extends StatelessWidget {
  const _BrokenExplanation({required this.broken});

  final ChainBroken broken;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rows = <(String, Hash)>[
      ...switch (broken) {
        MerkleMismatch(:final stored, :final computed) => [
          ('${l10n.merkleRoot} (saklanan)', stored),
          ('${l10n.merkleRoot} (hesaplanan)', computed),
        ],
        HashMismatch(:final stored, :final computed) => [
          ('${l10n.blockHash} (saklanan)', stored),
          ('${l10n.blockHash} (hesaplanan)', computed),
        ],
        BrokenLink(:final expected, :final actual) => [
          ('${l10n.previousHash} (beklenen)', expected),
          ('${l10n.previousHash} (bulunan)', actual),
        ],
        InvalidGenesis() ||
        UnreadableBlock() ||
        IndexGap() ||
        TimestampRegression() ||
        UnknownAuthority() ||
        BadSignature() => const <(String, Hash)>[],
      },
    ];
    return SurfaceCard(
      borderColor: context.palette.absent.withValues(alpha: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (label, hash) in rows) HashText(hash, label: label),
        ],
      ),
    );
  }
}

final class _BlockTile extends StatelessWidget {
  const _BlockTile({required this.block, required this.broken});

  final Block<Record> block;
  final bool broken;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final p = context.palette;
    final color = broken ? p.absent : p.accent;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: SurfaceCard(
        padding: EdgeInsets.zero,
        borderColor: broken ? p.absent : null,
        child: ExpansionTile(
          shape: const Border(),
          leading: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: Radii.control,
            ),
            child: Text(
              '#${block.index}',
              style: AppTheme.mono(context, size: 13, color: color),
            ),
          ),
          title: Text(
            block.isGenesis
                ? l10n.genesisBlock
                : l10n.transactionsCount(block.transactions.length),
          ),
          subtitle: Text(
            '${block.timestamp.trDateTime} · ${block.hash.short}',
            style: AppTheme.mono(context, size: 12),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            Space.lg,
            0,
            Space.lg,
            Space.lg,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.signedBy(block.authorityId)),
            HashText(block.hash, label: l10n.blockHash, full: true),
            HashText(block.previousHash, label: l10n.previousHash),
            HashText(block.merkleRoot, label: l10n.merkleRoot),
            for (final tx in block.transactions)
              switch (tx) {
                AttendanceRecord(:final studentNumber, :final status) =>
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(studentNumber, style: AppTheme.mono(context)),
                    trailing: StatusChip(status, dense: true),
                  ),
                CorrectionRecord(:final studentId, :final newStatus) =>
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.edit_note_rounded),
                    title: Text('${l10n.corrected}: $studentId'),
                    trailing: StatusChip(newStatus, dense: true),
                  ),
                _ => const SizedBox.shrink(),
              },
          ],
        ),
      ),
    );
  }
}
