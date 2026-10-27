// DART KONUSU: Classes & objects — `StatefulWidget` + `State` kalıtımı,
// mixin (`SingleTickerProviderStateMixin`), `CustomPainter` alt sınıfı,
// `@override` / `@mustCallSuper` uyan yaşam döngüsü metotları.

/// Yoklama başarılı mikro etkileşimi: çizilen onay işareti + yay.
library;

import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:sarkisla_yoklama/ui/motion/motion.dart';
import 'package:sarkisla_yoklama/ui/theme/app_palette.dart';

/// Daire yayla büyür, ardından onay işareti çizilir ve titreşim verilir.
/// "Animasyonları azalt" açıksa son hâli doğrudan gösterilir.
final class SuccessCheck extends StatefulWidget {
  const SuccessCheck({this.size = 84, this.semanticLabel, super.key});

  final double size;
  final String? semanticLabel;

  @override
  State<SuccessCheck> createState() => _SuccessCheckState();
}

final class _SuccessCheckState extends State<SuccessCheck>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final Animation<double> _circle = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.6, curve: Motion.spring),
  );
  late final Animation<double> _tick = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.35, 1, curve: Curves.easeOutCubic),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.isDismissed) {
      if (context.reduceMotion) {
        _controller.value = 1;
      } else {
        _controller.forward();
      }
      unawaited(HapticFeedback.mediumImpact());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      label: widget.semanticLabel,
      liveRegion: true,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => Transform.scale(
            scale: _circle.value,
            child: CustomPaint(
              size: Size.square(widget.size),
              painter: _CheckPainter(
                progress: _tick.value,
                fill: p.present,
                stroke: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _CheckPainter extends CustomPainter {
  const _CheckPainter({
    required this.progress,
    required this.fill,
    required this.stroke,
  });

  final double progress;
  final Color fill;
  final Color stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    canvas
      ..drawCircle(c, r, Paint()..color = fill.withValues(alpha: 0.12))
      ..drawCircle(c, r * 0.84, Paint()..color = fill);

    final path = Path()
      ..moveTo(size.width * 0.32, size.height * 0.52)
      ..lineTo(size.width * 0.45, size.height * 0.65)
      ..lineTo(size.width * 0.70, size.height * 0.38);
    final metric = path.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * progress),
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.06
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_CheckPainter old) =>
      old.progress != progress || old.fill != fill;
}
