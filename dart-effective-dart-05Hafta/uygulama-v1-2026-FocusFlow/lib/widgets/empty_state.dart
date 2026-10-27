import 'package:flutter/material.dart';

/// Liste veya ekran boş olduğunda yönlendirici bir durum gösterir.
class EmptyState extends StatelessWidget {
  /// Boş durum bileşenini oluşturur.
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  /// Boş durumu simgeleyen ikon.
  final IconData icon;

  /// Kısa başlık.
  final String title;

  /// Kullanıcıya ne yapacağını anlatan açıklama.
  final String message;

  /// İsteğe bağlı eylem düğmesi etiketi.
  final String? actionLabel;

  /// Eylem düğmesine basıldığında çalışacak geri çağırma.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            scheme.surfaceContainerLowest,
            scheme.secondaryContainer.withValues(alpha: 0.34),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.72),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -42,
            right: -34,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.secondary.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        scheme.primaryContainer,
                        scheme.secondaryContainer,
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: scheme.outlineVariant.withValues(alpha: 0.8),
                    ),
                  ),
                  child: Icon(icon, color: scheme.onPrimaryContainer, size: 28),
                ),
                const SizedBox(height: 17),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                if (actionLabel != null && onAction != null) ...<Widget>[
                  const SizedBox(height: 18),
                  FilledButton.tonalIcon(
                    onPressed: onAction,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(actionLabel!),
                    style: FilledButton.styleFrom(
                      backgroundColor: scheme.secondaryContainer,
                      foregroundColor: scheme.onSecondaryContainer,
                      minimumSize: const Size(0, 46),
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
