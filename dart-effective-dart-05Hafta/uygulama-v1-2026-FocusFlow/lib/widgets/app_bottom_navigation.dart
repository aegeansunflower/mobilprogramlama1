import 'package:flutter/material.dart';

/// Uygulamanın yüzen alt gezinme çubuğu.
class AppBottomNavigation extends StatelessWidget {
  /// Seçili sekme ve seçim geri çağrısıyla oluşturur.
  const AppBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  /// Seçili sekmenin indeksi.
  final int selectedIndex;

  /// Kullanıcı başka bir sekmeye dokunduğunda çalışır.
  final ValueChanged<int> onDestinationSelected;

  static const List<_NavDestination> _destinations = <_NavDestination>[
    _NavDestination(
      label: 'Ana Sayfa',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _NavDestination(
      label: 'Odak',
      icon: Icons.timer_outlined,
      selectedIcon: Icons.timer_rounded,
    ),
    _NavDestination(
      label: 'Görevler',
      icon: Icons.checklist_rounded,
      selectedIcon: Icons.task_alt_rounded,
    ),
    _NavDestination(
      label: 'Kanıt',
      icon: Icons.verified_outlined,
      selectedIcon: Icons.verified_rounded,
    ),
    _NavDestination(
      label: 'Cüzdan',
      icon: Icons.account_balance_wallet_outlined,
      selectedIcon: Icons.account_balance_wallet_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest.withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.8),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: scheme.shadow.withValues(
                alpha: theme.brightness == Brightness.dark ? 0.32 : 0.09,
              ),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: List<Widget>.generate(_destinations.length, (index) {
            final destination = _destinations[index];
            return Expanded(
              child: _NavItem(
                destination: destination,
                selected: selectedIndex == index,
                onTap: () => onDestinationSelected(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = selected ? scheme.onPrimary : scheme.onSurfaceVariant;

    return Semantics(
      selected: selected,
      button: true,
      label: destination.label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 9),
            decoration: BoxDecoration(
              color: selected ? scheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(22),
              boxShadow: selected
                  ? <BoxShadow>[
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.22),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  selected ? destination.selectedIcon : destination.icon,
                  size: 21,
                  color: foreground,
                ),
                const SizedBox(height: 3),
                Text(
                  destination.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: foreground,
                    fontSize: 9.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
