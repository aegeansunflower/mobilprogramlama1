// DART KONUSU: Classes & objects — generics (`CustomTransitionPage<T>`),
// factory fonksiyon. Libraries & imports — `show`.

/// Sayfa geçişleri: paylaşılan eksen (shared axis) benzeri sön + kay.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'
    show CustomTransitionPage, GoRouterState;
import 'package:sarkisla_yoklama/ui/motion/motion.dart';
import 'package:sarkisla_yoklama/ui/theme/tokens.dart';

/// go_router sayfası. "Animasyonları azalt" açıksa geçiş anında olur.
CustomTransitionPage<void> motionPage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  final reduce = context.reduceMotion;
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: reduce ? Duration.zero : MotionDurations.page,
    reverseTransitionDuration: reduce ? Duration.zero : MotionDurations.medium,
    transitionsBuilder: (context, animation, secondary, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Motion.exit,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0.06, 0),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(
            opacity: Tween<double>(begin: 1, end: 0.6).animate(secondary),
            child: child,
          ),
        ),
      );
    },
  );
}
