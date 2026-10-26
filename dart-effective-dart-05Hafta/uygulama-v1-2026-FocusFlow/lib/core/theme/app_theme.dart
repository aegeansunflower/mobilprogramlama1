import 'package:flutter/material.dart';

/// FocusFlow'un sabit marka renkleri.
///
/// Renkler tek bir yerde tutulur; ekranlar doğrudan HEX değeri kullanmaz.
abstract final class AppColors {
  static const Color pine = Color(0xFF0B2B21);
  static const Color forest = Color(0xFF14503B);
  static const Color emerald = Color(0xFF3C8C68);
  static const Color accent = emerald;
  static const Color mint = Color(0xFFA9E5C6);
  static const Color lime = Color(0xFFD8F37A);
  static const Color cream = Color(0xFFF6F3EA);
  static const Color paper = Color(0xFFFFFCF5);
  static const Color ink = Color(0xFF14241C);
  static const Color deepForest = Color(0xFF09251C);
  static const Color softGreen = Color(0xFFE3EFE6);
  static const Color sand = Color(0xFFE8B06B);
  static const Color warmSand = sand;
  static const Color coral = Color(0xFFDE7657);
  static const Color sky = Color(0xFF78B7C9);
  static const Color danger = Color(0xFFC24B3A);

  /// FocusChain kartlarında kullanılan derin petrol mavisi.
  static const Color deepChain = Color(0xFF0A2B33);
  static const Color chainBlue = Color(0xFF2E7D9A);
  static const Color chainTeal = Color(0xFF2A9D8F);
  static const Color tokenGold = Color(0xFFE9B95C);
  static const List<Color> chainGradient = <Color>[
    Color(0xFF0A2B33),
    Color(0xFF12545A),
    Color(0xFF247D73),
  ];

  /// Koyu temada kullanılan gece yüzeyleri.
  static const Color night = Color(0xFF0B1511);
  static const Color nightSurface = Color(0xFF101E18);
  static const Color nightElevated = Color(0xFF16271F);

  /// Odak kartlarında kullanılan sıcak-soğuk geçiş.
  static const List<Color> heroGradient = <Color>[
    Color(0xFF0B2F24),
    Color(0xFF17533E),
    Color(0xFF2C7A5A),
  ];
}

/// Uygulamanın açık ve koyu tema tanımlarını üretir.
abstract final class AppTheme {
  /// Açık tema; sıcak krem arka plan ve orman yeşili vurgular kullanır.
  static ThemeData get light => _buildTheme(Brightness.light);

  /// Koyu tema; kontrastı koruyan gece yeşili yüzeyler kullanır.
  static ThemeData get dark => _buildTheme(Brightness.dark);

  /// Kahraman kartlarda kullanılan marka gradyanı.
  static List<Color> heroGradientFor(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const <Color>[
        Color(0xFF0A2B20),
        Color(0xFF164C39),
        Color(0xFF236A4E),
      ];
    }
    return AppColors.heroGradient;
  }

  /// FocusChain kartlarında kullanılan petrol-mavi gradyanı.
  static List<Color> chainGradientFor(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const <Color>[
        Color(0xFF071E25),
        Color(0xFF0D3B43),
        Color(0xFF175B58),
      ];
    }
    return AppColors.chainGradient;
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.emerald,
          brightness: brightness,
        ).copyWith(
          primary: isDark ? const Color(0xFFA9E5C6) : AppColors.forest,
          onPrimary: isDark ? AppColors.deepForest : Colors.white,
          primaryContainer: isDark
              ? const Color(0xFF1E4A38)
              : const Color(0xFFDCEFE3),
          onPrimaryContainer: isDark
              ? const Color(0xFFD5F5E4)
              : const Color(0xFF0B2B21),
          secondary: isDark ? const Color(0xFF8FD6B4) : AppColors.emerald,
          onSecondary: isDark ? AppColors.deepForest : Colors.white,
          secondaryContainer: isDark
              ? const Color(0xFF234C3B)
              : const Color(0xFFD6EFE0),
          onSecondaryContainer: isDark
              ? const Color(0xFFD5F5E4)
              : const Color(0xFF123A2B),
          tertiary: isDark ? const Color(0xFFF2B08E) : AppColors.coral,
          onTertiary: isDark ? const Color(0xFF3D1A0D) : Colors.white,
          tertiaryContainer: isDark
              ? const Color(0xFF5A2A18)
              : const Color(0xFFFBE2D9),
          onTertiaryContainer: isDark
              ? const Color(0xFFFFD9C9)
              : const Color(0xFF4A1E12),
          surface: isDark ? AppColors.night : AppColors.cream,
          onSurface: isDark ? const Color(0xFFEAF3EC) : AppColors.ink,
          surfaceContainerLowest: isDark
              ? AppColors.nightSurface
              : AppColors.paper,
          surfaceContainerLow: isDark
              ? const Color(0xFF14251E)
              : const Color(0xFFF1EDE2),
          surfaceContainer: isDark
              ? const Color(0xFF1A2E25)
              : const Color(0xFFEAE5D8),
          surfaceContainerHigh: isDark
              ? const Color(0xFF22392E)
              : const Color(0xFFE3DDD0),
          surfaceContainerHighest: isDark
              ? const Color(0xFF2A4336)
              : const Color(0xFFDCD5C7),
          onSurfaceVariant: isDark
              ? const Color(0xFFA9BBB0)
              : const Color(0xFF5C6B61),
          outline: isDark ? const Color(0xFF71857A) : const Color(0xFF8B978C),
          outlineVariant: isDark
              ? const Color(0xFF2A4035)
              : const Color(0xFFDED8CB),
          error: isDark ? const Color(0xFFFFB4A4) : AppColors.danger,
          onError: isDark ? const Color(0xFF561F15) : Colors.white,
          errorContainer: isDark
              ? const Color(0xFF5C1F14)
              : const Color(0xFFFBE0DA),
          onErrorContainer: isDark
              ? const Color(0xFFFFDAD2)
              : const Color(0xFF4A120A),
          inverseSurface: isDark ? const Color(0xFFEAF3EC) : AppColors.pine,
          onInverseSurface: isDark ? AppColors.pine : Colors.white,
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: 'PlusJakartaSans',
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,
    );

    final textTheme = base.textTheme.copyWith(
      displaySmall: base.textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1.4,
        height: 1.05,
      ),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        height: 1.15,
      ),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.7,
        height: 1.2,
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleSmall: base.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.5),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.5),
      bodySmall: base.textTheme.bodySmall?.copyWith(height: 1.4),
      labelLarge: base.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      labelMedium: base.textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      labelSmall: base.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.75),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          side: BorderSide(color: scheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
          highlightColor: scheme.primaryContainer.withValues(alpha: 0.6),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        floatingLabelStyle: TextStyle(
          color: scheme.secondary,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.75),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.secondary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.error, width: 1.8),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: scheme.surfaceContainerLowest,
        indicatorColor: scheme.primaryContainer,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return textTheme.labelSmall?.copyWith(
            color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
            size: 24,
          );
        }),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: scheme.surfaceContainerLowest,
        selectedColor: scheme.primaryContainer,
        side: BorderSide(color: scheme.outlineVariant),
        shape: const StadiumBorder(),
        labelStyle: textTheme.labelMedium?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF2A4A3C) : AppColors.pine,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.7),
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.secondary,
        linearTrackColor: scheme.surfaceContainer,
        linearMinHeight: 8,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? scheme.surfaceContainerHigh : AppColors.pine,
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        textStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.secondary,
        textColor: scheme.onSurface,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll<Color>(
          scheme.outline.withValues(alpha: 0.45),
        ),
        radius: const Radius.circular(999),
        thickness: const WidgetStatePropertyAll<double>(5),
      ),
    );
  }
}
