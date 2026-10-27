import 'package:flutter/material.dart';

import '../../blockchain/utils/chain_formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../models/reward_offer.dart';
import '../../state/app_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_snack_bar.dart';
import '../../widgets/page_header.dart';
import '../chain/chain_widgets.dart';

/// FOCUS tokenlarının yerel ödüllere dönüştürüldüğü mağaza sayfası.
class RewardsPage extends StatelessWidget {
  /// Ödül mağazasını merkezi denetleyiciyle oluşturur.
  const RewardsPage({super.key, required this.controller});

  /// Uygulamanın merkezi durumu.
  final AppController controller;

  Future<void> _redeem(BuildContext context, RewardOffer offer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('${offer.title} kullanılsın mı?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${offer.cost} FOCUS harcanacak ve ödül deftere '
                'kaydedilecek.',
              ),
              const SizedBox(height: 10),
              Text(
                'İşlem cihazdaki Ed25519 anahtarıyla imzalanır. Bu, gerçek '
                'para değeri olmayan yerel bir öz-ödül kullanımıdır.',
                style: Theme.of(dialogContext).textTheme.labelSmall?.copyWith(
                  color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Vazgeç'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.redeem_rounded, size: 17),
              label: const Text('Kullan'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) {
      return;
    }

    final result = await controller.redeemReward(offer);
    if (!context.mounted) {
      return;
    }
    if (result == null) {
      showAppSnackBar(
        context,
        controller.chainError ?? 'Ödül kullanılamadı.',
        tone: SnackBarTone.error,
      );
      return;
    }
    showAppSnackBar(
      context,
      '${offer.title} kullanıldı • -${offer.cost} FOCUS • '
      '${shortHash(result.transaction.id)}',
      tone: SnackBarTone.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 4,
        title: const Text('Ödül Mağazası'),
      ),
      body: AppBackground(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final balance = controller.availableFocusBalance;
            final redemptions = controller.rewardRedemptions.reversed.toList(
              growable: false,
            );
            final useCounts = <RewardOffer, int>{};
            for (final transaction in redemptions) {
              final rewardId = transaction.metadata['rewardId'];
              final offer = rewardId is String
                  ? RewardOffer.fromId(rewardId)
                  : null;
              if (offer != null) {
                useCounts.update(
                  offer,
                  (count) => count + 1,
                  ifAbsent: () => 1,
                );
              }
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
              children: <Widget>[
                const PageHeader(
                  title: 'Ödül Mağazası',
                  subtitle:
                      'Kazandığın FOCUS’ları kendi molalarına dönüştür. Her '
                      'kullanım imzalı bir işlemle Kanıt Defteri’ne yazılır.',
                ),
                const SizedBox(height: 16),
                _BalanceBanner(
                  balance: balance,
                  redemptionCount: redemptions.length,
                ),
                if (controller.isChainTampered) ...<Widget>[
                  const SizedBox(height: 12),
                  _TamperNotice(),
                ],
                const SizedBox(height: 22),
                Text(
                  'Ödüller',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'FOCUS biriktir, ihtiyacın olan molayı seç.',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                for (final offer in RewardOffer.values) ...<Widget>[
                  _RewardCard(
                    offer: offer,
                    useCount: useCounts[offer] ?? 0,
                    canRedeem:
                        balance >= offer.cost && !controller.isChainTampered,
                    isTampered: controller.isChainTampered,
                    onRedeem: () => _redeem(context, offer),
                  ),
                  if (offer != RewardOffer.values.last)
                    const SizedBox(height: 10),
                ],
                const SizedBox(height: 24),
                Text(
                  'Nasıl çalışır?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const _HowItWorksCard(),
                const SizedBox(height: 24),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Kullanılan ödüller',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      '${redemptions.length}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Her kullanım defterde ayrı bir kanıt olarak durur.',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                if (redemptions.isEmpty)
                  const _EmptyRedemptions()
                else
                  for (
                    var index = 0;
                    index < redemptions.length;
                    index++
                  ) ...<Widget>[
                    ChainTransactionTile(
                      transaction: redemptions[index],
                      walletAddress: controller.walletAddress,
                      showHash: true,
                    ),
                    if (index != redemptions.length - 1)
                      const SizedBox(height: 8),
                  ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BalanceBanner extends StatelessWidget {
  const _BalanceBanner({required this.balance, required this.redemptionCount});

  final int balance;
  final int redemptionCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppTheme.chainGradientFor(theme.brightness),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ChainPattern(
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: <Widget>[
              const FocusCoin(size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'HARCANABİLİR BAKİYE',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$balance FOCUS',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                      ),
                    ),
                  ],
                ),
              ),
              if (redemptionCount > 0)
                ChainStatusPill(
                  label: '$redemptionCount KULLANIM',
                  color: AppColors.lime,
                  icon: Icons.redeem_rounded,
                )
              else
                ChainStatusPill(
                  label: 'HAZIR',
                  color: AppColors.mint,
                  icon: Icons.bolt_rounded,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.offer,
    required this.useCount,
    required this.canRedeem,
    required this.isTampered,
    required this.onRedeem,
  });

  final RewardOffer offer;
  final int useCount;
  final bool canRedeem;
  final bool isTampered;
  final VoidCallback onRedeem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.sand.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  _rewardIcon(offer.iconName),
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
                      offer.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      offer.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    if (useCount > 0) ...<Widget>[
                      const SizedBox(height: 5),
                      Text(
                        '$useCount kez kullanıldı',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.secondary,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.toll_rounded,
                      size: 13,
                      color: AppColors.tokenGold,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${offer.cost} FOCUS',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: canRedeem ? onRedeem : null,
                icon: Icon(
                  canRedeem
                      ? Icons.redeem_rounded
                      : isTampered
                      ? Icons.lock_rounded
                      : Icons.lock_outline_rounded,
                  size: 16,
                ),
                label: Text(
                  isTampered
                      ? 'Kilitli'
                      : canRedeem
                      ? 'Kullan'
                      : 'Yetersiz',
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Column(
        children: <Widget>[
          _HowItWorksRow(
            icon: Icons.center_focus_strong_rounded,
            title: 'FOCUS kazan',
            text: 'Odak oturumları, görevler ve rozetlerle FOCUS biriktir.',
          ),
          const SizedBox(height: 11),
          _HowItWorksRow(
            icon: Icons.redeem_rounded,
            title: 'Ödül seç',
            text:
                'Biriktirdiğin FOCUS’u kahve, dizi veya dinlenme gününe '
                'dönüştür.',
          ),
          const SizedBox(height: 11),
          _HowItWorksRow(
            icon: Icons.verified_rounded,
            title: 'Defterde kanıtla',
            text:
                'Her kullanım imzalanır, bakiyeden düşer ve Kanıt '
                'Defteri’nde kalıcı bir işlem olur.',
          ),
        ],
      ),
    );
  }
}

class _HowItWorksRow extends StatelessWidget {
  const _HowItWorksRow({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 18, color: scheme.secondary),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyRedemptions extends StatelessWidget {
  const _EmptyRedemptions();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.receipt_long_rounded,
            size: 20,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Henüz ödül kullanmadın. İlk ödülünü seçtiğinde burada '
              'görünecek.',
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TamperNotice extends StatelessWidget {
  const _TamperNotice();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.errorContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.error.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.lock_rounded, size: 17, color: scheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Kurcalama demosu aktif. Ödül kullanmak için önce sağlam '
              'deftere dön.',
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.error,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

IconData _rewardIcon(String iconName) {
  return switch (iconName) {
    'local_cafe' => Icons.local_cafe_rounded,
    'movie' => Icons.movie_rounded,
    'sports_esports' => Icons.sports_esports_rounded,
    'beach_access' => Icons.beach_access_rounded,
    _ => Icons.card_giftcard_rounded,
  };
}
