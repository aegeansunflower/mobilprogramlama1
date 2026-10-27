// DART KONUSU: Classes & objects — `StatefulWidget` + `State` (hover/press
// durumu), const constructor'lar, isteğe bağlı parametreler, `super.key`,
// enum ile varyant. Class modifiers — `final class` widget'lar.

/// Yüzeyler: arka plan, kart, buton, iskelet, avatar, okul mührü.
library;

import 'package:flutter/material.dart';
import 'package:sarkisla_yoklama/ui/motion/motion.dart';
import 'package:sarkisla_yoklama/ui/theme/app_palette.dart';
import 'package:sarkisla_yoklama/ui/theme/tokens.dart';
import 'package:sarkisla_yoklama/ui/widgets/status.dart' show L10nContext;

/// Düz, sıcak tonlu sayfa zemini. Işık lekesi ya da gradyan yok.
final class AppBackground extends StatelessWidget {
  const AppBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      ColoredBox(color: context.palette.background, child: child);
}

/// İnce kenarlıklı beyaz kart.
///
/// Framer Motion'daki `whileHover` / `whileTap` karşılığı: fareyle üzerine
/// gelince kenarlık koyulaşır ve gölge belirir; basılınca kart %1.5 küçülür.
/// "Animasyonları azalt" açıksa geçişler anında olur.
final class SurfaceCard extends StatefulWidget {
  const SurfaceCard({
    required this.child,
    this.padding = const EdgeInsets.all(Space.lg),
    this.onTap,
    this.semanticLabel,
    this.borderColor,
    this.color,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final Color? borderColor;
  final Color? color;

  @override
  State<SurfaceCard> createState() => _SurfaceCardState();
}

final class _SurfaceCardState extends State<SurfaceCard> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _interactive => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final reduce = context.reduceMotion;
    final duration = reduce ? Duration.zero : MotionDurations.fast;
    final lifted = _interactive && _hovered;

    return Semantics(
      button: _interactive,
      label: widget.semanticLabel,
      child: AnimatedScale(
        scale: _pressed && !reduce ? 0.985 : 1,
        duration: duration,
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: duration,
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: widget.color ?? p.surface,
            borderRadius: Radii.card,
            border: Border.all(
              color: widget.borderColor ?? (lifted ? p.borderStrong : p.border),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: lifted ? 0.07 : 0.03),
                blurRadius: lifted ? 14 : 2,
                offset: Offset(0, lifted ? 4 : 1),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: Radii.card,
              onTap: widget.onTap,
              onHover: _interactive
                  ? (v) => setState(() => _hovered = v)
                  : null,
              onHighlightChanged: _interactive
                  ? (v) => setState(() => _pressed = v)
                  : null,
              splashFactory: NoSplash.splashFactory,
              highlightColor: p.surfaceMuted.withValues(alpha: 0.5),
              hoverColor: Colors.transparent,
              child: Padding(padding: widget.padding, child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}

/// Buton varyantı.
enum ButtonVariant { primary, secondary }

/// Düz, rol renginde birincil buton (48 dp). Yüklenirken etiketin yerine
/// küçük bir gösterge geçer; buton boyutu değişmez.
final class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.variant = ButtonVariant.primary,
    this.expand = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final ButtonVariant variant;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final fg = variant == ButtonVariant.primary ? p.onAccent : p.textPrimary;
    final content = AnimatedSwitcher(
      duration: context.reduceMotion ? Duration.zero : MotionDurations.fast,
      child: loading
          ? SizedBox.square(
              key: const ValueKey('loading'),
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: fg),
            )
          : Row(
              key: const ValueKey('label'),
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: fg),
                  const SizedBox(width: Space.sm),
                ],
                Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
              ],
            ),
    );
    final onTap = loading ? null : onPressed;
    final button = switch (variant) {
      ButtonVariant.primary => FilledButton(onPressed: onTap, child: content),
      ButtonVariant.secondary => OutlinedButton(
        onPressed: onTap,
        child: content,
      ),
    };
    return Semantics(
      label: loading ? label : null,
      child: expand ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}

/// Ekran iskeleti: düz zemin + güvenli alan + geniş ekranda ortalanmış
/// içerik sütunu.
final class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.title,
    this.actions,
    this.floating,
    this.leading,
    this.maxWidth = Sizes.maxContentWidth,
    super.key,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floating;
  final Widget? leading;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => AppBackground(
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: title == null && actions == null && leading == null
          ? null
          : AppBar(
              title: title == null ? null : Text(title!),
              actions: [
                ...?actions,
                const SizedBox(width: Space.sm),
              ],
              leading: leading,
            ),
      floatingActionButton: floating,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: body,
          ),
        ),
      ),
    ),
  );
}

/// Baş harf avatarı. Yazı boyutu çapa göre hesaplanır; böylece "AY",
/// "ED" gibi iki harf her boyutta yuvarlağın içine sığar.
final class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar(this.initials, {this.size = 40, super.key});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: p.accentSoft,
          shape: BoxShape.circle,
          border: Border.all(color: p.accent.withValues(alpha: 0.18)),
        ),
        child: Padding(
          padding: EdgeInsets.all(size * 0.18),
          child: FittedBox(
            child: Text(
              initials,
              style: TextStyle(
                color: p.accent,
                fontWeight: FontWeight.w600,
                fontSize: size * 0.38,
                letterSpacing: 0.3,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Sivas Cumhuriyet Üniversitesi mührü.
final class SchoolSeal extends StatelessWidget {
  const SchoolSeal({this.size = 40, this.semanticLabel, super.key});

  final double size;
  final String? semanticLabel;

  /// Varlık yolu.
  static const String asset = 'assets/images/okul_logo.png';

  @override
  Widget build(BuildContext context) => SizedBox.square(
    // Yer önceden ayrılır: resim çözülürken yerleşim kaymaz.
    dimension: size,
    child: Image.asset(
      asset,
      width: size,
      height: size,
      semanticLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
          wasSynchronouslyLoaded
          ? child
          : AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: context.reduceMotion
                  ? Duration.zero
                  : MotionDurations.medium,
              child: child,
            ),
    ),
  );
}

/// Tek kartta, ince çizgilerle ayrılmış istatistikler.
final class StatStrip extends StatelessWidget {
  const StatStrip({required this.items, super.key});

  /// `(etiket, değer)` çiftleri.
  final List<(String, String)> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = context.palette;
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: Space.lg),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (final (i, (label, value)) in items.indexed) ...[
              if (i > 0) VerticalDivider(color: p.border, width: 1),
              Expanded(
                child: Semantics(
                  label: '$label: $value',
                  excludeSemantics: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.upper(label),
                          style: theme.textTheme.labelSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: Space.sm),
                        Text(value, style: theme.textTheme.headlineMedium),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Açık vurgu zeminli kare ikon kutusu (kart başlıkları için).
final class IconTile extends StatelessWidget {
  const IconTile(this.icon, {this.size = 40, this.color, super.key});

  final IconData icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color == null ? p.accentSoft : color!.withValues(alpha: 0.1),
        borderRadius: Radii.control,
      ),
      child: Icon(icon, size: size * 0.5, color: color ?? p.accent),
    );
  }
}

/// Duyarlı ızgara: genişliğe sığan sütun sayısını [minItemWidth]'e göre
/// hesaplar (telefonda 1, tablet/web'de 2–3 sütun).
final class AdaptiveGrid extends StatelessWidget {
  const AdaptiveGrid({
    required this.children,
    this.minItemWidth = 260,
    this.maxColumns = 3,
    this.spacing = Space.md,
    super.key,
  });

  final List<Widget> children;
  final double minItemWidth;
  final int maxColumns;
  final double spacing;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final columns = ((width + spacing) / (minItemWidth + spacing))
          .floor()
          .clamp(1, maxColumns);
      final itemWidth = (width - spacing * (columns - 1)) / columns;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          for (final child in children)
            SizedBox(width: itemWidth, child: child),
        ],
      );
    },
  );
}

/// Küçük istatistik kutusu: büyük harfli etiket + büyük sayı + açıklama.
final class StatTile extends StatelessWidget {
  const StatTile({
    required this.label,
    required this.value,
    this.caption,
    this.icon,
    super.key,
  });

  final String label;
  final String value;
  final String? caption;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = context.palette;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.upper(label),
                  style: theme.textTheme.labelSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null) Icon(icon, size: Sizes.iconSm),
            ],
          ),
          const SizedBox(height: Space.sm),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: p.textPrimary,
            ),
          ),
          if (caption != null) ...[
            const SizedBox(height: Space.xs),
            Text(
              caption!,
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
