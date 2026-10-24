import 'package:flutter/material.dart';

/// Ekranların üst kısmında kullanılan başlık ve açıklama bileşeni.
class PageHeader extends StatelessWidget {
  /// Başlık, isteğe bağlı açıklama ve sağ eylemle oluşturur.
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  /// Ekran başlığı.
  final String title;

  /// Başlığın altındaki açıklama.
  final String? subtitle;

  /// Sağ tarafta gösterilecek isteğe bağlı bileşen.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: theme.textTheme.headlineSmall),
              if (subtitle != null) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...<Widget>[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}
