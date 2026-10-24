import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../blockchain/models/chain_transaction.dart';
import '../../blockchain/utils/chain_formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_time_utils.dart';

/// İşlem türüne göre kullanılan ikon.
IconData chainTransactionIcon(ChainTransactionType type) {
  return switch (type) {
    ChainTransactionType.genesis => Icons.celebration_rounded,
    ChainTransactionType.focusReward => Icons.center_focus_strong_rounded,
    ChainTransactionType.taskReward => Icons.task_alt_rounded,
    ChainTransactionType.achievementReward => Icons.workspace_premium_rounded,
    ChainTransactionType.miningReward => Icons.hexagon_rounded,
    ChainTransactionType.transfer => Icons.swap_horiz_rounded,
    ChainTransactionType.rewardRedemption => Icons.card_giftcard_rounded,
  };
}

/// İşlem türüne göre vurgu rengi.
Color chainTransactionColor(ChainTransactionType type, ColorScheme scheme) {
  return switch (type) {
    ChainTransactionType.genesis => AppColors.tokenGold,
    ChainTransactionType.focusReward => scheme.secondary,
    ChainTransactionType.taskReward => AppColors.sand,
    ChainTransactionType.achievementReward => AppColors.tokenGold,
    ChainTransactionType.miningReward => AppColors.sky,
    ChainTransactionType.transfer => scheme.primary,
    ChainTransactionType.rewardRedemption => AppColors.sand,
  };
}

/// Rozet ikon adlarını Material ikonlarına eşler.
IconData achievementIcon(String iconName) {
  return switch (iconName) {
    'spa' => Icons.spa_rounded,
    'local_fire_department' => Icons.local_fire_department_rounded,
    'workspace_premium' => Icons.workspace_premium_rounded,
    'calendar_month' => Icons.calendar_month_rounded,
    'task_alt' => Icons.task_alt_rounded,
    'checklist' => Icons.checklist_rounded,
    'view_in_ar' => Icons.view_in_ar_rounded,
    'auto_awesome' => Icons.auto_awesome_rounded,
    _ => Icons.military_tech_rounded,
  };
}

/// FOCUS tokenını temsil eden küçük altın madalyon.
class FocusCoin extends StatelessWidget {
  /// İstenen çapta coin oluşturur.
  const FocusCoin({super.key, this.size = 34});

  /// Coin çapı.
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFFFF0B8),
            AppColors.tokenGold,
            Color(0xFFC8892E),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.55),
          width: 1.2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.tokenGold.withValues(alpha: 0.35),
            blurRadius: size * 0.35,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'F',
          style: TextStyle(
            color: AppColors.deepChain,
            fontSize: size * 0.48,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ),
    );
  }
}

/// Zincir kartlarında kullanılan düşük kontrastlı düğüm ağı deseni.
class ChainPattern extends StatelessWidget {
  /// Deseni ve üstüne çizilecek içeriği oluşturur.
  const ChainPattern({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.opacity = 0.13,
  });

  /// Desenin üzerine yerleşecek içerik.
  final Widget child;

  /// Düğüm ve çizgi rengi.
  final Color color;

  /// Desen saydamlığı.
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ChainPatternPainter(color: color, opacity: opacity),
      child: child,
    );
  }
}

class _ChainPatternPainter extends CustomPainter {
  const _ChainPatternPainter({required this.color, required this.opacity});

  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    final dotPaint = Paint()..color = color.withValues(alpha: opacity * 1.6);

    final points = <Offset>[
      Offset(size.width * 0.08, size.height * 0.22),
      Offset(size.width * 0.28, size.height * 0.08),
      Offset(size.width * 0.45, size.height * 0.32),
      Offset(size.width * 0.68, size.height * 0.16),
      Offset(size.width * 0.88, size.height * 0.35),
      Offset(size.width * 0.76, size.height * 0.62),
      Offset(size.width * 0.52, size.height * 0.55),
      Offset(size.width * 0.31, size.height * 0.72),
      Offset(size.width * 0.1, size.height * 0.55),
    ];
    const links = <List<int>>[
      <int>[0, 1],
      <int>[1, 2],
      <int>[2, 3],
      <int>[3, 4],
      <int>[4, 5],
      <int>[5, 6],
      <int>[6, 7],
      <int>[7, 8],
      <int>[8, 0],
      <int>[2, 6],
      <int>[0, 8],
    ];
    for (final link in links) {
      canvas.drawLine(points[link[0]], points[link[1]], paint);
    }
    for (final point in points) {
      canvas.drawCircle(point, 2.4, dotPaint);
      canvas.drawCircle(
        point,
        6.5,
        Paint()
          ..color = color.withValues(alpha: opacity * 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    final arcPaint = Paint()
      ..color = color.withValues(alpha: opacity * 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.9, size.height * 0.8),
        radius: math.min(size.width, size.height) * 0.32,
      ),
      -math.pi / 2,
      math.pi,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ChainPatternPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.opacity != opacity;
  }
}

/// Bir zincir işlemini liste satırı olarak gösterir.
class ChainTransactionTile extends StatelessWidget {
  /// İşlem ve cüzdan bağlamıyla satır oluşturur.
  const ChainTransactionTile({
    super.key,
    required this.transaction,
    required this.walletAddress,
    this.isPending = false,
    this.showHash = true,
  });

  /// Gösterilecek işlem.
  final ChainTransaction transaction;

  /// Yerel cüzdan adresi; tutarın yönünü belirlemek için kullanılır.
  final String walletAddress;

  /// İşlem henüz bir blokta onaylanmadı mı?
  final bool isPending;

  /// İşlem hash'i alt satırda gösterilsin mi?
  final bool showHash;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = chainTransactionColor(transaction.type, scheme);
    final incoming = transaction.toAddress == walletAddress;
    final amountColor = incoming ? scheme.secondary : scheme.onSurfaceVariant;
    final amountPrefix = incoming ? '+' : '-';
    final metadataTitle = transaction.metadata['title'];
    final title =
        transaction.type == ChainTransactionType.rewardRedemption &&
            metadataTitle is String &&
            metadataTitle.trim().isNotEmpty
        ? metadataTitle
        : transaction.type.label;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              chainTransactionIcon(transaction.type),
              color: accent,
              size: 19,
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
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$amountPrefix${transaction.amount} FOCUS',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: amountColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${shortAddress(transaction.fromAddress)} → '
                  '${shortAddress(transaction.toAddress)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontSize: 9.5,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: <Widget>[
                    Text(
                      '${formatShortTurkishDate(transaction.dateTime)} • '
                      '${formatTime(transaction.dateTime)}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant.withValues(alpha: 0.75),
                        fontSize: 9,
                      ),
                    ),
                    if (isPending) ...<Widget>[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.sand.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'BEKLİYOR',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.sand,
                            fontSize: 7.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (showHash) ...<Widget>[
                  const SizedBox(height: 3),
                  Text(
                    shortHash(transaction.id, head: 12, tail: 8),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8.5,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.62),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Küçük, renkli durum etiketi.
class ChainStatusPill extends StatelessWidget {
  /// Etiket metni ve rengiyle oluşturur.
  const ChainStatusPill({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  /// Etiket metni.
  final String label;

  /// Etiket vurgu rengi.
  final Color color;

  /// İsteğe bağlı baştaki ikon.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
