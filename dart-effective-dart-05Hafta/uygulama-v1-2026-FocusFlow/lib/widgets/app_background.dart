import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Ekranların arkasına yumuşak marka renkleri ve ışık lekeleri ekler.
class AppBackground extends StatelessWidget {
  /// Verilen içeriği marka arka planıyla sarar.
  const AppBackground({super.key, required this.child});

  /// Arka planın üzerinde gösterilecek içerik.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const <Color>[
                  Color(0xFF0B1511),
                  Color(0xFF0E1D17),
                  Color(0xFF0B1511),
                ]
              : const <Color>[
                  Color(0xFFF9F6EE),
                  Color(0xFFF4F1E7),
                  Color(0xFFF8F5ED),
                ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: -150,
            right: -110,
            child: IgnorePointer(
              child: _Glow(
                size: 340,
                color: scheme.secondary.withValues(alpha: isDark ? 0.20 : 0.13),
              ),
            ),
          ),
          Positioned(
            bottom: -140,
            left: -130,
            child: IgnorePointer(
              child: _Glow(
                size: 320,
                color: AppColors.sand.withValues(alpha: isDark ? 0.11 : 0.10),
              ),
            ),
          ),
          Positioned(
            top: 260,
            left: -90,
            child: IgnorePointer(
              child: _Glow(
                size: 190,
                color: AppColors.sky.withValues(alpha: isDark ? 0.08 : 0.07),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}
