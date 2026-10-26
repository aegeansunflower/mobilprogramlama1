import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../blockchain/achievements/achievement_engine.dart';
import '../../blockchain/models/chain_reward.dart';
import '../../blockchain/services/wallet_service.dart';
import '../../blockchain/utils/chain_formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../state/app_controller.dart';
import '../../widgets/app_snack_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/page_header.dart';
import '../chain/chain_widgets.dart';
import '../rewards/rewards_page.dart';

/// Yerel FOCUS cüzdanını, kanıt rozetlerini ve transfer akışını gösterir.
class WalletScreen extends StatelessWidget {
  /// Cüzdan ekranını denetleyici ve defter geri çağrısıyla oluşturur.
  const WalletScreen({
    super.key,
    required this.controller,
    required this.onOpenChain,
  });

  /// Uygulamanın merkezi durumu.
  final AppController controller;

  /// Kanıt sekmesine geçer.
  final VoidCallback onOpenChain;

  Future<void> _openTransferDialog(BuildContext context) async {
    final result = await showDialog<ChainReward>(
      context: context,
      builder: (dialogContext) => _TransferDialog(controller: controller),
    );
    if (!context.mounted || result == null) {
      return;
    }
    showAppSnackBar(
      context,
      result.isConfirmed
          ? 'Transfer onaylandı • ${shortHash(result.transaction.id)}'
          : 'Transfer sıraya alındı • ${shortHash(result.transaction.id)}',
      tone: SnackBarTone.success,
    );
  }

  Future<void> _copyAddress(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: controller.walletAddress));
    if (!context.mounted) {
      return;
    }
    showAppSnackBar(
      context,
      'Cüzdan adresi kopyalandı.',
      tone: SnackBarTone.info,
    );
  }

  void _openRewards(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RewardsPage(controller: controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chain = controller.chain;
    if (chain == null) {
      return _WalletUnavailable(controller: controller);
    }

    final minted = controller.mintedAchievements;
    final mintedById = <AchievementId, MintedAchievement>{
      for (final item in minted) item.achievement: item,
    };
    final pendingIds = chain.pendingTransactions
        .map((transaction) => transaction.id)
        .toSet();
    final recentTransactions = chain.allTransactions.reversed
        .take(8)
        .toList(growable: false);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      children: <Widget>[
        PageHeader(
          title: 'Cüzdan',
          subtitle:
              'FOCUS kazan, ödül mağazasında harca veya imzalı transferle '
              'gönder. Tüm hareketler Kanıt Defteri’nde.',
          trailing: ChainStatusPill(
            label: '${minted.length}/${AchievementId.values.length} ROZET',
            color: AppColors.tokenGold,
            icon: Icons.workspace_premium_rounded,
          ),
        ),
        const SizedBox(height: 18),
        _WalletHeroCard(
          controller: controller,
          onSend: () => _openTransferDialog(context),
          onCopy: () => _copyAddress(context),
          onOpenChain: onOpenChain,
        ),
        const SizedBox(height: 14),
        _RewardsPromoCard(onTap: () => _openRewards(context)),
        const SizedBox(height: 20),
        _SectionTitle(
          title: 'Kanıt Rozetleri',
          caption:
              'Koşulu tamamlanan rozetler NFT benzeri işlemlerle deftere '
              'işlenir.',
          trailing: '${minted.length} / ${AchievementId.values.length}',
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 10) / 2;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                for (final achievement in AchievementId.values)
                  SizedBox(
                    width: cardWidth,
                    child: _AchievementCard(
                      achievement: achievement,
                      minted: mintedById[achievement],
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 22),
        _SectionTitle(
          title: 'Son İşlemler',
          caption: 'Ödüller, madencilik gelirleri ve transferler.',
          trailing: '${chain.allTransactions.length}',
        ),
        const SizedBox(height: 10),
        if (recentTransactions.isEmpty)
          const EmptyState(
            icon: Icons.receipt_long_rounded,
            title: 'Henüz işlem yok',
            message:
                'İlk odak oturumunu tamamladığında FOCUS ödülün burada '
                'görünecek.',
          )
        else
          Column(
            children: <Widget>[
              for (
                var index = 0;
                index < recentTransactions.length;
                index++
              ) ...<Widget>[
                ChainTransactionTile(
                  transaction: recentTransactions[index],
                  walletAddress: controller.walletAddress,
                  isPending: pendingIds.contains(recentTransactions[index].id),
                ),
                if (index != recentTransactions.length - 1)
                  const SizedBox(height: 8),
              ],
            ],
          ),
        const SizedBox(height: 14),
        TextButton.icon(
          onPressed: onOpenChain,
          icon: const Icon(Icons.verified_outlined, size: 17),
          label: const Text('Tüm defteri keşfet'),
        ),
        const SizedBox(height: 12),
        _LocalKeyNotice(),
      ],
    );
  }
}

class _WalletUnavailable extends StatelessWidget {
  const _WalletUnavailable({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      children: <Widget>[
        const PageHeader(
          title: 'Cüzdan',
          subtitle: 'Yerel FOCUS cüzdanı başlatılamadı.',
        ),
        const SizedBox(height: 24),
        EmptyState(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Cüzdan kapalı',
          message:
              controller.chainError ??
              'Yerel cüzdan yüklenemedi. Depolama izinlerini kontrol edip '
                  'yeniden deneyin.',
          actionLabel: 'Yeniden dene',
          onAction: controller.retryChainInitialization,
        ),
      ],
    );
  }
}

class _WalletHeroCard extends StatelessWidget {
  const _WalletHeroCard({
    required this.controller,
    required this.onSend,
    required this.onCopy,
    required this.onOpenChain,
  });

  final AppController controller;
  final VoidCallback onSend;
  final VoidCallback onCopy;
  final VoidCallback onOpenChain;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chain = controller.chain;
    final gradient = AppTheme.chainGradientFor(theme.brightness);
    final received = chain?.totalReceivedBy(controller.walletAddress) ?? 0;
    final spent = chain?.totalSpentBy(controller.walletAddress) ?? 0;

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
          padding: const EdgeInsets.fromLTRB(21, 20, 21, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'FOCUS CÜZDANI',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.3,
                    ),
                  ),
                  const Spacer(),
                  const ChainStatusPill(
                    label: 'YEREL',
                    color: AppColors.mint,
                    icon: Icons.phone_android_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: <Widget>[
                  const FocusCoin(size: 52),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${controller.focusBalance}',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.7,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'FOCUS',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Material(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: onCopy,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.key_rounded,
                          size: 15,
                          color: Colors.white.withValues(alpha: 0.55),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.walletAddress,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontFamily: 'monospace',
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.copy_rounded,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _WalletMetric(
                      label: 'TOPLAM KAZANILAN',
                      value: '$received',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 28,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  Expanded(
                    child: _WalletMetric(
                      label: 'HARCANAN',
                      value: '$spent',
                      alignEnd: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onSend,
                      icon: const Icon(Icons.send_rounded, size: 17),
                      label: const Text('Gönder'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.deepChain,
                        minimumSize: const Size(0, 46),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onOpenChain,
                      icon: const Icon(Icons.verified_outlined, size: 17),
                      label: const Text('Defter'),
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
}

class _RewardsPromoCard extends StatelessWidget {
  const _RewardsPromoCard({required this.onTap});

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
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.7),
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.sand.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  color: AppColors.sand,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Ödül Mağazası',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'FOCUS’larını kahve molası, dizi veya dinlenme gününe '
                      'dönüştür.',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.arrow_forward_rounded,
                size: 19,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletMetric extends StatelessWidget {
  const _WalletMetric({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.48),
            fontSize: 7.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$value FOCUS',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement, this.minted});

  final AchievementId achievement;
  final MintedAchievement? minted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isMinted = minted != null;
    final accent = isMinted ? AppColors.tokenGold : scheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: isMinted
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  AppColors.tokenGold.withValues(alpha: 0.2),
                  scheme.surfaceContainerLowest,
                ],
              )
            : null,
        color: isMinted ? null : scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isMinted
              ? AppColors.tokenGold.withValues(alpha: 0.36)
              : scheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: isMinted ? 0.17 : 0.08),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  isMinted
                      ? achievementIcon(achievement.iconName)
                      : Icons.lock_outline_rounded,
                  color: accent,
                  size: 19,
                ),
              ),
              const Spacer(),
              if (isMinted)
                const ChainStatusPill(
                  label: 'DEFTERDE',
                  color: AppColors.tokenGold,
                )
              else
                Icon(
                  Icons.lock_outline_rounded,
                  size: 13,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            achievement.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: isMinted ? scheme.onSurface : scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            achievement.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant.withValues(
                alpha: isMinted ? 0.85 : 0.6,
              ),
              height: 1.35,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Icon(
                Icons.toll_rounded,
                size: 12,
                color: isMinted
                    ? AppColors.tokenGold
                    : scheme.onSurfaceVariant.withValues(alpha: 0.45),
              ),
              const SizedBox(width: 3),
              Text(
                '+${achievement.reward} FOCUS',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isMinted
                      ? AppColors.tokenGold
                      : scheme.onSurfaceVariant.withValues(alpha: 0.55),
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (isMinted) ...<Widget>[
            const SizedBox(height: 5),
            Text(
              minted!.achievement.tokenId,
              style: TextStyle(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                fontFamily: 'monospace',
                fontSize: 7.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.caption,
    required this.trailing,
  });

  final String title;
  final String caption;
  final String trailing;

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
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                caption,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.7),
            ),
          ),
          child: Text(
            trailing,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _LocalKeyNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.lock_rounded, size: 16, color: scheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Bu cüzdan yalnızca bu cihazda oluşturulur. Özel anahtar yerel '
              'depoda tutulur; hesap, e-posta veya internet bağlantısı '
              'kullanılmaz. Demo amaçlı yerel defterde gerçek para değeri '
              'yoktur.',
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.45,
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransferDialog extends StatefulWidget {
  const _TransferDialog({required this.controller});

  final AppController controller;

  @override
  State<_TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends State<_TransferDialog> {
  static const String _demoAddress =
      '0x8f3c2a1b4d5e6f708192a3b4c5d6e7f8091a2b3c';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _addressController;
  late final TextEditingController _amountController;
  late final TextEditingController _memoController;
  bool _isSending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _amountController = TextEditingController();
    _memoController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final amount = int.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      return;
    }
    setState(() {
      _isSending = true;
      _error = null;
    });

    final result = await widget.controller.sendFocusTransfer(
      toAddress: _addressController.text.trim(),
      amount: amount,
      memo: _memoController.text,
    );
    if (!mounted) {
      return;
    }
    if (result == null) {
      setState(() {
        _isSending = false;
        _error = widget.controller.chainError ?? 'Transfer gönderilemedi.';
      });
      return;
    }
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AlertDialog(
      title: const Text('FOCUS Gönder'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: <Widget>[
                    const FocusCoin(size: 28),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'Harcanabilir: '
                        '${widget.controller.availableFocusBalance} FOCUS',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Alıcı adresi',
                  hintText: '0x…',
                  suffixIcon: IconButton(
                    onPressed: _isSending
                        ? null
                        : () {
                            _addressController.text = _demoAddress;
                          },
                    tooltip: 'Demo alıcı',
                    icon: const Icon(Icons.science_outlined, size: 19),
                  ),
                ),
                maxLines: 1,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final address = value?.trim() ?? '';
                  if (!WalletService.isValidAddress(address)) {
                    return '0x ile başlayan 40 hex karakterli adres gir.';
                  }
                  if (address == widget.controller.walletAddress) {
                    return 'Kendi adresine transfer yapamazsın.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Miktar',
                  hintText: '5',
                  suffixText: 'FOCUS',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  final amount = int.tryParse(value?.trim() ?? '');
                  if (amount == null || amount <= 0) {
                    return 'Sıfırdan büyük bir miktar gir.';
                  }
                  if (amount > widget.controller.availableFocusBalance) {
                    return 'Yetersiz bakiye.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _memoController,
                decoration: const InputDecoration(
                  labelText: 'Not (isteğe bağlı)',
                  hintText: 'Örn. çalışma grubu',
                ),
                maxLength: 80,
                textInputAction: TextInputAction.done,
              ),
              if (_error != null) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  _error!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                'Transfer cihazdaki Ed25519 özel anahtarıyla imzalanır ve '
                'yerel deftere yazılır.',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.4,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isSending ? null : () => Navigator.of(context).pop(),
          child: const Text('Vazgeç'),
        ),
        FilledButton.icon(
          onPressed: _isSending ? null : _submit,
          icon: _isSending
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send_rounded, size: 17),
          label: Text(_isSending ? 'Gönderiliyor...' : 'İmzala ve gönder'),
        ),
      ],
    );
  }
}
