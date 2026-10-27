// DART KONUSU: Classes & objects — `CustomPainter` alt sınıfı (`@override
// paint` / `shouldRepaint`), `LayoutBuilder` ile duyarlı yerleşim, private
// widget sınıfları, `ConsumerWidget`. Class modifiers — `final class`.

/// Giriş ekranlarının ortak iskeleti: geniş ekranda kurum paneli + içerik,
/// dar ekranda üst başlık + içerik.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sarkisla_yoklama/auth/presentation/auth_controller.dart';
import 'package:sarkisla_yoklama/ui/ui.dart';

/// Giriş ekranı iskeleti.
final class AuthShell extends StatelessWidget {
  const AuthShell({required this.child, this.leading, super.key});

  /// Sağ (ya da alt) bölmedeki içerik.
  final Widget child;

  /// Üst çubuğun solundaki öğe (ör. geri bağlantısı).
  final Widget? leading;

  @override
  Widget build(BuildContext context) => AppBackground(
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= Sizes.splitBreakpoint;
          final pane = _ContentPane(
            leading: leading,
            showHeader: !wide,
            child: child,
          );
          if (!wide) return SafeArea(child: pane);
          return Row(
            children: [
              const Expanded(flex: 5, child: _BrandPanel()),
              Expanded(flex: 6, child: SafeArea(child: pane)),
            ],
          );
        },
      ),
    ),
  );
}

final class _ContentPane extends StatelessWidget {
  const _ContentPane({
    required this.child,
    required this.showHeader,
    this.leading,
  });

  final Widget child;
  final Widget? leading;
  final bool showHeader;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(Space.sm, Space.sm, Space.sm, 0),
        child: Row(
          children: [?leading, const Spacer(), const ThemeToggleButton()],
        ),
      ),
      Expanded(
        // Geniş ekranda form dikeyde ortalanır; telefonda üstten başlar
        // (klavye açıldığında da doğal kayar).
        child: Align(
          alignment: showHeader ? Alignment.topCenter : Alignment.center,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              Space.xl,
              showHeader ? Space.lg : Space.sm,
              Space.xl,
              Space.xxl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showHeader) ...[
                    const _SchoolHeader(compact: true).enter(context),
                    const SizedBox(height: Space.xxl),
                  ],
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

/// Mühür + üniversite + yüksekokul adı.
final class _SchoolHeader extends StatelessWidget {
  const _SchoolHeader({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Row(
      children: [
        SchoolSeal(size: compact ? 44 : 52, semanticLabel: l10n.universityName),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.upper(l10n.universityName),
                style: theme.textTheme.labelSmall,
              ),
              const SizedBox(height: 2),
              Text(
                l10n.schoolName,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Sol kurum paneli.
final class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final statement = AppTheme.display(size: 40, color: p.textPrimary);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: p.surfaceMuted,
        border: Border(right: BorderSide(color: p.border)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/campus_bg.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    p.surface.withValues(alpha: 0.84),
                    p.surface.withValues(alpha: 0.58),
                    p.surface.withValues(alpha: 0.90),
                  ],
                  stops: const [0.0, 0.45, 0.85],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Space.xxxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SchoolHeader().enter(context),
                  const Spacer(),
                  const SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: _ChainIllustration(),
                  ),
                  const Spacer(),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '${l10n.brandStatementLead} '),
                        TextSpan(
                          text: l10n.brandStatementEmphasis,
                          style: AppTheme.display(
                            size: 40,
                            color: p.brand,
                            style: FontStyle.italic,
                          ),
                        ),
                        TextSpan(text: ' ${l10n.brandStatementTail}'),
                      ],
                    ),
                    style: statement,
                  ).enter(context, index: 2),
                  const SizedBox(height: Space.lg),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Text(
                      l10n.brandCaption,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: p.textMuted,
                      ),
                    ),
                  ).enter(context, index: 3),
                  const SizedBox(height: Space.xl),
                  Text(
                    l10n.brandFootnote,
                    style: AppTheme.mono(context, size: 11),
                  ).enter(context, index: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bağlı bloklardan oluşan ince çizgili zincir çizimi. Bloklar soldan sağa
/// sırayla çizilir; "Animasyonları azalt" açıksa doğrudan son hâli görünür.
final class _ChainIllustration extends StatelessWidget {
  const _ChainIllustration();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ExcludeSemantics(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: context.reduceMotion ? 1 : 0, end: 1),
        duration: const Duration(milliseconds: 1600),
        curve: Curves.easeInOutCubic,
        builder: (context, t, _) => CustomPaint(
          painter: _ChainPainter(
            progress: t,
            line: p.textMuted.withValues(alpha: 0.45),
            fill: p.surface,
            accent: p.brand,
          ),
        ),
      ),
    );
  }
}

final class _ChainPainter extends CustomPainter {
  const _ChainPainter({
    required this.progress,
    required this.line,
    required this.fill,
    required this.accent,
  });

  final double progress;
  final Color line;
  final Color fill;
  final Color accent;

  static const int _blocks = 4;

  @override
  void paint(Canvas canvas, Size size) {
    const blockW = 78.0;
    const blockH = 54.0;
    final gap = (size.width - blockW * _blocks) / (_blocks - 1);
    final stroke = Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    final fillPaint = Paint()..color = fill;

    for (var i = 0; i < _blocks; i++) {
      // Her blok ilerlemenin kendi dilimine sahip.
      final local = ((progress * _blocks) - i).clamp(0.0, 1.0);
      if (local == 0) continue;
      final y = size.height / 2 - blockH / 2 + (i.isEven ? -10 : 10);
      final rect = Rect.fromLTWH(i * (blockW + gap), y, blockW, blockH);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));

      // Önceki bloğa bağlantı çizgisi (previousHash).
      if (i > 0) {
        final prevY = size.height / 2 + (i.isEven ? 10 : -10);
        final from = Offset(rect.left - gap, prevY);
        final to = Offset(rect.left, rect.center.dy);
        canvas.drawLine(from, Offset.lerp(from, to, local)!, stroke);
      }

      canvas
        ..save()
        ..translate(0, (1 - local) * 6);
      fillPaint.color = fill.withValues(alpha: local);
      canvas
        ..drawRRect(rrect, fillPaint)
        ..drawRRect(
          rrect,
          stroke..color = line.withValues(alpha: line.a * local),
        );
      // Başlık satırları (hash'i temsil eden çizgiler).
      final lines = Paint()
        ..color = line.withValues(alpha: 0.5 * local)
        ..strokeWidth = 1.1
        ..strokeCap = StrokeCap.round;
      canvas
        ..drawLine(
          rect.topLeft + const Offset(12, 16),
          rect.topLeft + const Offset(52, 16),
          lines,
        )
        ..drawLine(
          rect.topLeft + const Offset(12, 27),
          rect.topLeft + const Offset(40, 27),
          lines,
        )
        // İmza noktası: son blok okul kırmızısıyla.
        ..drawCircle(
          rect.bottomRight - const Offset(14, 14),
          3.2,
          Paint()
            ..color = (i == _blocks - 1 ? accent : line).withValues(
              alpha: local,
            ),
        )
        ..restore();
      stroke.color = line;
    }
  }

  @override
  bool shouldRepaint(_ChainPainter old) =>
      old.progress != progress || old.line != line || old.accent != accent;
}

/// Açık/koyu tema düğmesi.
final class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: context.l10n.themeToggle,
      icon: Icon(dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      onPressed: () =>
          ref.read(themeModeProvider.notifier).toggle(currentlyDark: dark),
    );
  }
}
