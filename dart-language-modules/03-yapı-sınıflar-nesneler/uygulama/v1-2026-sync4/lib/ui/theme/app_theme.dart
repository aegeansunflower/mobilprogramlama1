// DART KONUSU: Class modifiers — `abstract final class` (static fabrika).
// Classes & objects — static const üyeler, static metotlar.

/// Material 3 teması: Inter gövde, Newsreader başlık, Fira Code hash
/// (hepsi uygulamaya gömülü).
library;

import 'package:flutter/material.dart';
import 'package:sarkisla_yoklama/core/core.dart';
import 'package:sarkisla_yoklama/ui/theme/app_palette.dart';
import 'package:sarkisla_yoklama/ui/theme/tokens.dart';

/// Tema fabrikası.
abstract final class AppTheme {
  /// Gövde yazı tipi.
  static const String fontFamily = 'Inter';

  /// Başlık (serif) yazı tipi — değişken ağırlıklı.
  static const String displayFamily = 'Newsreader';

  /// Eş aralıklı yazı tipi — değişken ağırlıklı.
  static const String monoFamily = 'FiraCode';

  /// Serif başlık stili. Değişken yazı tipinde ağırlık `wght` ekseniyle
  /// verilir; `opsz` büyük puntolarda harf biçimini inceltir.
  static TextStyle display({
    required double size,
    required Color color,
    double weight = 480,
    FontStyle style = FontStyle.normal,
  }) => TextStyle(
    fontFamily: displayFamily,
    fontSize: size,
    height: 1.12,
    letterSpacing: size >= 28 ? -0.6 : -0.2,
    color: color,
    fontStyle: style,
    fontVariations: [
      FontVariation('wght', weight),
      FontVariation('opsz', size.clamp(6, 72).toDouble()),
    ],
  );

  /// [brightness] ve [role] için tema.
  static ThemeData build(Brightness brightness, Role? role) {
    final p = AppPalette.of(brightness, role);
    final scheme =
        ColorScheme.fromSeed(
          seedColor: p.accent,
          brightness: brightness,
        ).copyWith(
          primary: p.accent,
          onPrimary: p.onAccent,
          secondary: p.accent,
          surface: p.surface,
          onSurface: p.textPrimary,
          onSurfaceVariant: p.textMuted,
          outline: p.borderStrong,
          outlineVariant: p.border,
          error: p.absent,
          surfaceContainerHighest: p.surfaceMuted,
        );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
      fontFamily: fontFamily,
    );
    final t = base.textTheme.apply(
      fontFamily: fontFamily,
      bodyColor: p.textPrimary,
      displayColor: p.textPrimary,
    );
    final text = t.copyWith(
      displaySmall: display(size: 36, color: p.textPrimary),
      headlineLarge: display(size: 32, color: p.textPrimary),
      headlineMedium: display(size: 28, color: p.textPrimary),
      headlineSmall: display(size: 24, color: p.textPrimary),
      titleLarge: t.titleLarge?.copyWith(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleMedium: t.titleMedium?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      ),
      titleSmall: t.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: t.bodyLarge?.copyWith(fontSize: 15, height: 1.5),
      bodyMedium: t.bodyMedium?.copyWith(fontSize: 14, height: 1.5),
      bodySmall: t.bodySmall?.copyWith(
        fontSize: 12.5,
        height: 1.45,
        color: p.textMuted,
      ),
      labelLarge: t.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      labelSmall: t.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.9,
        color: p.textMuted,
      ),
    );

    OutlineInputBorder outline(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: Radii.control,
      borderSide: BorderSide(color: c, width: w),
    );

    return base.copyWith(
      scaffoldBackgroundColor: p.background,
      canvasColor: p.background,
      textTheme: text,
      extensions: [p],
      dividerTheme: DividerThemeData(color: p.border, space: 1, thickness: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: p.textPrimary,
        centerTitle: false,
        titleTextStyle: text.titleMedium,
        shape: Border(bottom: BorderSide(color: p.border)),
      ),
      iconTheme: IconThemeData(color: p.textMuted, size: Sizes.iconMd),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        labelStyle: TextStyle(color: p.textMuted),
        floatingLabelStyle: TextStyle(color: p.accent),
        prefixIconColor: p.textMuted,
        border: outline(p.borderStrong),
        enabledBorder: outline(p.borderStrong),
        focusedBorder: outline(p.accent, 1.6),
        errorBorder: outline(p.absent),
        focusedErrorBorder: outline(p.absent, 1.6),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Space.lg,
          vertical: 14,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.accent,
          foregroundColor: p.onAccent,
          minimumSize: const Size(Sizes.minTouch, Sizes.buttonHeight),
          shape: const RoundedRectangleBorder(borderRadius: Radii.control),
          textStyle: text.labelLarge?.copyWith(fontSize: 14.5),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.textPrimary,
          backgroundColor: p.surface,
          minimumSize: const Size(Sizes.minTouch, Sizes.buttonHeight),
          shape: const RoundedRectangleBorder(borderRadius: Radii.control),
          side: BorderSide(color: p.borderStrong),
          textStyle: text.labelLarge?.copyWith(fontSize: 14.5),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.textPrimary,
          minimumSize: const Size(Sizes.minTouch, Sizes.minTouch),
          textStyle: text.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: p.textMuted,
          minimumSize: const Size(Sizes.minTouch, Sizes.minTouch),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.surface,
        side: BorderSide(color: p.border),
        shape: const RoundedRectangleBorder(borderRadius: Radii.pill),
        labelStyle: text.labelLarge?.copyWith(color: p.textPrimary),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.onAccent : p.textMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.accent : p.surfaceMuted,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.accent,
        foregroundColor: p.onAccent,
        elevation: 2,
        highlightElevation: 2,
        shape: const RoundedRectangleBorder(borderRadius: Radii.card),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: Radii.control),
        backgroundColor: p.textPrimary,
        contentTextStyle: text.bodyMedium?.copyWith(color: p.background),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.card,
          side: BorderSide(color: p.border),
        ),
        titleTextStyle: display(size: 22, color: p.textPrimary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: p.textMuted,
        titleTextStyle: text.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        subtitleTextStyle: text.bodySmall,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.accent),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: p.accentSoft,
          selectedForegroundColor: p.textPrimary,
          side: BorderSide(color: p.borderStrong),
        ),
      ),
    );
  }

  /// Hash ve kimlikler için eş aralıklı yazı tipi.
  static TextStyle mono(BuildContext context, {double? size, Color? color}) =>
      TextStyle(
        fontFamily: monoFamily,
        fontSize: size ?? 12.5,
        color: color ?? context.palette.textMuted,
        fontVariations: const [FontVariation('wght', 450)],
      );
}
