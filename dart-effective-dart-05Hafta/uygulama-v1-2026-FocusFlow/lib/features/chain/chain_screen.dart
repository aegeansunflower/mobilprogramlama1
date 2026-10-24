import 'package:flutter/material.dart';

import '../../blockchain/models/chain_block.dart';
import '../../blockchain/models/chain_validation_result.dart';
import '../../blockchain/models/focus_chain.dart';
import '../../blockchain/utils/chain_formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_time_utils.dart';
import '../../state/app_controller.dart';
import '../../widgets/app_snack_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/page_header.dart';
import 'chain_widgets.dart';

enum _ChainTab { blocks, transactions }

/// FocusChain ağ durumunu, blokları, işlemleri ve bütünlük demosunu gösterir.
class ChainScreen extends StatefulWidget {
  /// Zincir ekranını merkezi denetleyiciyle oluşturur.
  const ChainScreen({super.key, required this.controller});

  /// Uygulamanın merkezi durumu.
  final AppController controller;

  @override
  State<ChainScreen> createState() => _ChainScreenState();
}

class _ChainScreenState extends State<ChainScreen> {
  _ChainTab _tab = _ChainTab.blocks;

  Future<void> _mineBlock() async {
    final block = await widget.controller.minePendingBlock();
    if (!mounted) {
      return;
    }
    if (block == null) {
      showAppSnackBar(
        context,
        widget.controller.chainError ??
            'Blok üretilemedi. Bekleyen işlem olup olmadığını kontrol et.',
        tone: SnackBarTone.error,
      );
      return;
    }
    showAppSnackBar(
      context,
      'Blok #${block.index} üretildi • ${shortHash(block.hash)}',
      tone: SnackBarTone.success,
    );
  }

  Future<void> _validate() async {
    final result = await widget.controller.validateChain();
    if (!mounted) {
      return;
    }
    if (result == null) {
      showAppSnackBar(
        context,
        'Kanıt defteri henüz hazır değil.',
        tone: SnackBarTone.error,
      );
      return;
    }
    showAppSnackBar(
      context,
      result.message,
      tone: result.isValid ? SnackBarTone.success : SnackBarTone.error,
    );
  }

  Future<void> _simulateTamper() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Bütünlük demosu'),
        content: const Text(
          'Son bloktaki bir işlem miktarı bellekte değiştirilecek. '
          'Kalıcı defter etkilenmez; doğrulama bu değişikliği yakalamalı. '
          'Devam edilsin mi?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Kurcala'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    final tampered = await widget.controller.simulateChainTamper();
    if (!mounted) {
      return;
    }
    showAppSnackBar(
      context,
      tampered
          ? 'Defter bellekte kurcalandı. Şimdi doğrula ve farkı gör.'
          : widget.controller.chainError ?? 'Kurcalama için yeterli blok yok.',
      tone: tampered ? SnackBarTone.info : SnackBarTone.error,
    );
  }

  Future<void> _restore() async {
    await widget.controller.restoreChainAfterTamper();
    if (!mounted) {
      return;
    }
    showAppSnackBar(
      context,
      'Sağlam defter geri yüklendi.',
      tone: SnackBarTone.success,
    );
  }

  void _showHowItWorks() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => const _HowItWorksSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final chain = controller.chain;
    if (chain == null) {
      return _ChainUnavailable(controller: controller);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      children: <Widget>[
        PageHeader(
          title: 'Kanıt Defteri',
          subtitle:
              'Odak oturumların imzalı işlemler ve değişmez bloklar olarak '
              'bu cihazdaki yerel deftere yazılır.',
          trailing: _ValidationPill(result: controller.lastChainValidation),
        ),
        const SizedBox(height: 18),
        _NetworkHeroCard(controller: controller),
        const SizedBox(height: 14),
        _ValidationCard(
          result: controller.lastChainValidation,
          isTampered: controller.isChainTampered,
          onValidate: _validate,
        ),
        const SizedBox(height: 18),
        _ChainTabSelector(
          selected: _tab,
          blockCount: chain.height,
          transactionCount: chain.allTransactions.length,
          onChanged: (tab) => setState(() => _tab = tab),
        ),
        const SizedBox(height: 14),
        if (_tab == _ChainTab.blocks)
          _BlockList(chain: chain, walletAddress: controller.walletAddress)
        else
          _TransactionList(
            chain: chain,
            walletAddress: controller.walletAddress,
          ),
        const SizedBox(height: 18),
        _HowItWorksCard(onTap: _showHowItWorks),
        const SizedBox(height: 12),
        _IntegrityDemoCard(
          isTampered: controller.isChainTampered,
          canTamper: chain.height >= 2,
          onTamper: _simulateTamper,
          onRestore: _restore,
        ),
      ],
    );
  }
}

class _ChainUnavailable extends StatelessWidget {
  const _ChainUnavailable({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      children: <Widget>[
        const PageHeader(
          title: 'Kanıt Defteri',
          subtitle: 'Yerel kanıt defteri başlatılamadı.',
        ),
        const SizedBox(height: 24),
        EmptyState(
          icon: Icons.link_off_rounded,
          title: 'Defter kapalı',
          message:
              controller.chainError ??
              'Yerel defter yüklenemedi. Depolama izinlerini kontrol edip '
                  'yeniden deneyin.',
          actionLabel: 'Yeniden dene',
          onAction: controller.retryChainInitialization,
        ),
      ],
    );
  }
}

class _ValidationPill extends StatelessWidget {
  const _ValidationPill({required this.result});

  final ChainValidationResult? result;

  @override
  Widget build(BuildContext context) {
    final current = result;
    if (current == null) {
      return const ChainStatusPill(
        label: 'DOĞRULANMADI',
        color: AppColors.sand,
        icon: Icons.pending_outlined,
      );
    }
    return ChainStatusPill(
      label: current.isValid ? 'SAĞLIKLI' : 'HATALI',
      color: current.isValid
          ? AppColors.chainTeal
          : Theme.of(context).colorScheme.error,
      icon: current.isValid ? Icons.verified_rounded : Icons.gpp_bad_rounded,
    );
  }
}

class _NetworkHeroCard extends StatelessWidget {
  const _NetworkHeroCard({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = AppTheme.chainGradientFor(theme.brightness);
    final pending = controller.pendingChainTransactionCount;
    final canMine = pending > 0 && !controller.isMining;

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
            color: AppColors.deepChain.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.5 : 0.26,
            ),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ChainPattern(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(21, 21, 21, 20),
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
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.13),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _LiveDot(),
                        SizedBox(width: 6),
                        Text(
                          'YEREL DÜĞÜM',
                          style: TextStyle(
                            color: AppColors.mint,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ChainStatusPill(
                    label: 'POW • ${controller.chain?.difficulty ?? 3}',
                    color: AppColors.lime,
                    icon: Icons.bolt_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'FOCUS BAKİYESİ',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.62),
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${controller.focusBalance}',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 46,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.8,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          shortAddress(controller.walletAddress),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontFamily: 'monospace',
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const FocusCoin(size: 58),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _NetworkMetric(
                        label: 'BLOK',
                        value: '${controller.chainHeight}',
                      ),
                    ),
                    _MetricDivider(),
                    Expanded(
                      child: _NetworkMetric(
                        label: 'BEKLEYEN',
                        value: '$pending',
                      ),
                    ),
                    _MetricDivider(),
                    Expanded(
                      child: _NetworkMetric(
                        label: 'TOPLAM ARZ',
                        value: '${controller.totalMintedFocus}',
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.isMining) ...<Widget>[
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: const LinearProgressIndicator(
                    minHeight: 4,
                    color: AppColors.lime,
                    backgroundColor: Color(0x33FFFFFF),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Proof-of-work çalışıyor, blok hazırlanıyor...',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 10,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: canMine ? () => _mine(context) : null,
                      icon: const Icon(Icons.hexagon_rounded, size: 18),
                      label: Text(
                        controller.isMining ? 'Madencilik...' : 'Blok üret',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.deepChain,
                        disabledBackgroundColor: Colors.white.withValues(
                          alpha: 0.18,
                        ),
                        disabledForegroundColor: Colors.white.withValues(
                          alpha: 0.45,
                        ),
                        minimumSize: const Size(0, 46),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.isMining
                          ? null
                          : () => _validate(context),
                      icon: const Icon(Icons.verified_outlined, size: 18),
                      label: const Text('Doğrula'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.28),
                        ),
                        minimumSize: const Size(0, 46),
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

  Future<void> _mine(BuildContext context) async {
    final state = context.findAncestorStateOfType<_ChainScreenState>();
    await state?._mineBlock();
  }

  Future<void> _validate(BuildContext context) async {
    final state = context.findAncestorStateOfType<_ChainScreenState>();
    await state?._validate();
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: AppColors.lime,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _NetworkMetric extends StatelessWidget {
  const _NetworkMetric({required this.label, required this.value});

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
            fontSize: 17,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 8,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _MetricDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: Colors.white.withValues(alpha: 0.1),
    );
  }
}

class _ValidationCard extends StatelessWidget {
  const _ValidationCard({
    required this.result,
    required this.isTampered,
    required this.onValidate,
  });

  final ChainValidationResult? result;
  final bool isTampered;
  final VoidCallback onValidate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final current = result;
    final isValid = current?.isValid ?? false;
    final accent = isTampered || (current != null && !isValid)
        ? scheme.error
        : AppColors.chainTeal;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: scheme.shadow.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.2 : 0.035,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isTampered || (current != null && !isValid)
                  ? Icons.gpp_bad_rounded
                  : Icons.shield_outlined,
              color: accent,
              size: 21,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Defter bütünlüğü',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ChainStatusPill(
                      label: current == null
                          ? 'BEKLİYOR'
                          : current.isValid
                          ? 'GEÇERLİ'
                          : 'GEÇERSİZ',
                      color: current == null ? AppColors.sand : accent,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isTampered
                      ? 'Bellekteki defter kurcalandı. Hash bağlantıları artık '
                            'tutarlı değil.'
                      : current?.message ??
                            'Defteri doğrulayarak hash, proof-of-work ve imza '
                                'kontrollerini çalıştır.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                if (current != null) ...<Widget>[
                  const SizedBox(height: 6),
                  Text(
                    '${current.checkedBlocks} blok • '
                    '${current.checkedTransactions} işlem • '
                    '${formatTime(current.checkedAt)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                      fontSize: 9,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: onValidate,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Yeniden doğrula'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
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

class _ChainTabSelector extends StatelessWidget {
  const _ChainTabSelector({
    required this.selected,
    required this.blockCount,
    required this.transactionCount,
    required this.onChanged,
  });

  final _ChainTab selected;
  final int blockCount;
  final int transactionCount;
  final ValueChanged<_ChainTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.75),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _ChainTabButton(
              label: 'Bloklar',
              count: blockCount,
              selected: selected == _ChainTab.blocks,
              onTap: () => onChanged(_ChainTab.blocks),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: _ChainTabButton(
              label: 'İşlemler',
              count: transactionCount,
              selected: selected == _ChainTab.transactions,
              onTap: () => onChanged(_ChainTab.transactions),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChainTabButton extends StatelessWidget {
  const _ChainTabButton({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = selected ? scheme.onPrimary : scheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? scheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: foreground,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.18)
                      : scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$count',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: foreground,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlockList extends StatelessWidget {
  const _BlockList({required this.chain, required this.walletAddress});

  final FocusChain chain;
  final String walletAddress;

  @override
  Widget build(BuildContext context) {
    final blocks = chain.blocks.reversed.toList(growable: false);
    return Column(
      children: <Widget>[
        for (var index = 0; index < blocks.length; index++) ...<Widget>[
          _BlockCard(
            block: blocks[index],
            walletAddress: walletAddress,
            isGenesis: blocks[index].index == 0,
          ),
          if (index != blocks.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _BlockCard extends StatelessWidget {
  const _BlockCard({
    required this.block,
    required this.walletAddress,
    required this.isGenesis,
  });

  final ChainBlock block;
  final String walletAddress;
  final bool isGenesis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.72),
        ),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(14, 4, 10, 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          shape: const Border(),
          collapsedShape: const Border(),
          iconColor: scheme.onSurfaceVariant,
          collapsedIconColor: scheme.onSurfaceVariant,
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isGenesis
                    ? <Color>[AppColors.tokenGold, AppColors.sand]
                    : <Color>[scheme.primary, scheme.secondary],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                '${block.index}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          title: Row(
            children: <Widget>[
              Text(
                'Blok #${block.index}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (isGenesis) ...<Widget>[
                const SizedBox(width: 6),
                const ChainStatusPill(
                  label: 'GENESIS',
                  color: AppColors.tokenGold,
                ),
              ],
            ],
          ),
          subtitle: Text(
            '${block.transactionCount} işlem • '
            '${formatShortTurkishDate(block.dateTime)} '
            '${formatTime(block.dateTime)}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          children: <Widget>[
            _HashRow(label: 'HASH', value: block.hash),
            const SizedBox(height: 6),
            _HashRow(label: 'ÖNCEKİ', value: block.previousHash),
            const SizedBox(height: 6),
            _HashRow(label: 'MERKLE', value: block.merkleRoot),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                _MiniMetric(label: 'NONCE', value: '${block.nonce}'),
                const SizedBox(width: 14),
                _MiniMetric(label: 'ZORLUK', value: '${block.difficulty}'),
                const Spacer(),
                Text(
                  shortAddress(block.minerAddress),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                    fontSize: 8.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            for (
              var index = 0;
              index < block.transactions.length;
              index++
            ) ...<Widget>[
              ChainTransactionTile(
                transaction: block.transactions[index],
                walletAddress: walletAddress,
                showHash: false,
              ),
              if (index != block.transactions.length - 1)
                const SizedBox(height: 7),
            ],
          ],
        ),
      ),
    );
  }
}

class _HashRow extends StatelessWidget {
  const _HashRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 54,
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8.5,
              height: 1.4,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: scheme.onSurfaceVariant.withValues(alpha: 0.65),
            fontSize: 8,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.7,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _TransactionList extends StatelessWidget {
  const _TransactionList({required this.chain, required this.walletAddress});

  final FocusChain chain;
  final String walletAddress;

  @override
  Widget build(BuildContext context) {
    final pendingIds = chain.pendingTransactions
        .map((transaction) => transaction.id)
        .toSet();
    final transactions = chain.allTransactions.reversed.toList(growable: false);
    if (transactions.isEmpty) {
      return const EmptyState(
        icon: Icons.receipt_long_rounded,
        title: 'Henüz işlem yok',
        message: 'İlk odak oturumunu tamamladığında işlem burada görünecek.',
      );
    }
    return Column(
      children: <Widget>[
        for (var index = 0; index < transactions.length; index++) ...<Widget>[
          ChainTransactionTile(
            transaction: transactions[index],
            walletAddress: walletAddress,
            isPending: pendingIds.contains(transactions[index].id),
          ),
          if (index != transactions.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: scheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.72),
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.chainBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: AppColors.chainBlue,
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'FocusFlow Proof nasıl çalışır?',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'İmza, mempool, proof-of-work ve hash bağlantıları.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: scheme.onSurfaceVariant,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntegrityDemoCard extends StatelessWidget {
  const _IntegrityDemoCard({
    required this.isTampered,
    required this.canTamper,
    required this.onTamper,
    required this.onRestore,
  });

  final bool isTampered;
  final bool canTamper;
  final VoidCallback onTamper;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = isTampered ? scheme.error : AppColors.chainBlue;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                isTampered
                    ? Icons.warning_amber_rounded
                    : Icons.science_outlined,
                color: accent,
                size: 19,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  isTampered ? 'Kurcalama tespit edildi' : 'Bütünlük demosu',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            isTampered
                ? 'Bellekteki defter değiştirildi. Doğrulama artık geçersiz; '
                      'sağlam kopyaya dönerek devam edebilirsin.'
                : 'Son bloktaki bir işlemi bellekte değiştirip doğrulamanın '
                      'nasıl hata verdiğini göster. Kalıcı veri etkilenmez.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          if (isTampered)
            FilledButton.icon(
              onPressed: onRestore,
              icon: const Icon(Icons.restore_rounded, size: 17),
              label: const Text('Sağlam deftere dön'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 40),
                backgroundColor: scheme.error,
                foregroundColor: scheme.onError,
              ),
            )
          else
            OutlinedButton.icon(
              onPressed: canTamper ? onTamper : null,
              icon: const Icon(Icons.bolt_rounded, size: 17),
              label: const Text('Defteri kurcala'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 40),
                foregroundColor: accent,
                side: BorderSide(color: accent.withValues(alpha: 0.4)),
              ),
            ),
        ],
      ),
    );
  }
}

class _HowItWorksSheet extends StatelessWidget {
  const _HowItWorksSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    const steps = <_HowItWorksStep>[
      _HowItWorksStep(
        icon: Icons.edit_note_rounded,
        title: '1. İşlem oluştur',
        description:
            'Odak oturumu veya görev tamamlandığında FOCUS ödülü için bir '
            'işlem gövdesi üretilir.',
      ),
      _HowItWorksStep(
        icon: Icons.key_rounded,
        title: '2. Ed25519 ile imzala',
        description:
            'Transferler cihazdaki özel anahtarla imzalanır. Açık anahtar, '
            'işlemi gönderen cüzdan adresiyle eşleştirilir.',
      ),
      _HowItWorksStep(
        icon: Icons.inbox_rounded,
        title: '3. Mempool’a al',
        description:
            'Doğrulanan işlemler onay bekleyenler havuzuna girer. Bakiye ve '
            'imza kontrolleri burada yapılır.',
      ),
      _HowItWorksStep(
        icon: Icons.hexagon_rounded,
        title: '4. Proof-of-work',
        description:
            'Blok, hash’i belirlenen sayıda sıfırla başlayana kadar nonce '
            'denenerek üretilir. Bu demo 3 sıfır zorluğu kullanır.',
      ),
      _HowItWorksStep(
        icon: Icons.link_rounded,
        title: '5. Hash bağlantıları',
        description:
            'Her blok önceki blok hash’ini, Merkle kökünü ve işlemleri taşır. '
            'Tek bir değişiklik sonraki tüm blokları geçersiz kılar.',
      ),
    ];

    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
        children: <Widget>[
          Text(
            'FocusFlow Proof nasıl çalışır?',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            'Bu sürüm tamamen cihazda çalışan yerel bir kanıt defteridir. '
            'İnternet, hesap veya sunucu gerektirmez.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          for (final step in steps) ...<Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.chainBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(step.icon, color: AppColors.chainBlue, size: 19),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        step.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
          ],
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.info_outline_rounded,
                  size: 17,
                  color: scheme.secondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Yerel demo defteri tek düğümlüdür; gerçek bir dağıtık '
                    'mutabakat ağı değildir. Kriptografik yapı taşları '
                    '(SHA-256, Merkle, Ed25519, PoW) gerçek uygulanmıştır.',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.45,
                    ),
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

class _HowItWorksStep {
  const _HowItWorksStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
