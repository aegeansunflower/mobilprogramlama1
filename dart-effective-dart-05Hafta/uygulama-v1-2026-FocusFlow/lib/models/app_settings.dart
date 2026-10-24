import 'package:flutter/material.dart';

import 'focus_session.dart';

/// Kullanıcının Pomodoro süreleri ve tema tercihini taşıyan ayarlar.
class AppSettings {
  /// Varsayılan ayarlarla yeni bir nesne oluşturur.
  const AppSettings({
    this.focusDurationMinutes = defaultFocusMinutes,
    this.shortBreakMinutes = defaultShortBreakMinutes,
    this.longBreakMinutes = defaultLongBreakMinutes,
    this.themeMode = ThemeMode.system,
  });

  /// Varsayılan odak süresi (dakika).
  static const int defaultFocusMinutes = 25;

  /// Varsayılan kısa mola süresi (dakika).
  static const int defaultShortBreakMinutes = 5;

  /// Varsayılan uzun mola süresi (dakika).
  static const int defaultLongBreakMinutes = 15;

  /// İzin verilen en kısa odak süresi.
  static const int minFocusMinutes = 5;

  /// İzin verilen en uzun odak süresi.
  static const int maxFocusMinutes = 120;

  /// İzin verilen en kısa kısa mola süresi.
  static const int minShortBreakMinutes = 1;

  /// İzin verilen en uzun kısa mola süresi.
  static const int maxShortBreakMinutes = 30;

  /// İzin verilen en kısa uzun mola süresi.
  static const int minLongBreakMinutes = 5;

  /// İzin verilen en uzun uzun mola süresi.
  static const int maxLongBreakMinutes = 60;

  /// Odak oturumu süresi (dakika).
  final int focusDurationMinutes;

  /// Kısa mola süresi (dakika).
  final int shortBreakMinutes;

  /// Uzun mola süresi (dakika).
  final int longBreakMinutes;

  /// Uygulamanın tema tercihi.
  final ThemeMode themeMode;

  /// Odak süresi için geçerli aralık kontrolü.
  static String? validateFocusMinutes(int minutes) => _validateMinutes(
    minutes,
    min: minFocusMinutes,
    max: maxFocusMinutes,
    label: 'Odak süresi',
  );

  /// Kısa mola süresi için geçerli aralık kontrolü.
  static String? validateShortBreakMinutes(int minutes) => _validateMinutes(
    minutes,
    min: minShortBreakMinutes,
    max: maxShortBreakMinutes,
    label: 'Kısa mola',
  );

  /// Uzun mola süresi için geçerli aralık kontrolü.
  static String? validateLongBreakMinutes(int minutes) => _validateMinutes(
    minutes,
    min: minLongBreakMinutes,
    max: maxLongBreakMinutes,
    label: 'Uzun mola',
  );

  static String? _validateMinutes(
    int minutes, {
    required int min,
    required int max,
    required String label,
  }) {
    if (minutes < min || minutes > max) {
      return '$label $min ile $max dakika arasında olmalıdır.';
    }
    return null;
  }

  /// Tüm ayarların geçerli olup olmadığını tek seferde kontrol eder.
  String? get validationError =>
      validateFocusMinutes(focusDurationMinutes) ??
      validateShortBreakMinutes(shortBreakMinutes) ??
      validateLongBreakMinutes(longBreakMinutes);

  /// Verilen oturum türünün saniye cinsinden planlanan süresini döndürür.
  int durationSecondsFor(SessionType type) {
    final minutes = switch (type) {
      SessionType.focus => focusDurationMinutes,
      SessionType.shortBreak => shortBreakMinutes,
      SessionType.longBreak => longBreakMinutes,
    };
    return minutes * 60;
  }

  /// Seçilen alanları değiştirilmiş yeni bir ayar nesnesi döndürür.
  AppSettings copyWith({
    int? focusDurationMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      focusDurationMinutes: focusDurationMinutes ?? this.focusDurationMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  /// Ayarları yerel depoya yazılabilecek JSON haritasına dönüştürür.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'focusDurationMinutes': focusDurationMinutes,
      'shortBreakMinutes': shortBreakMinutes,
      'longBreakMinutes': longBreakMinutes,
      'themeMode': themeMode.name,
    };
  }

  /// JSON haritasından ayar üretir.
  ///
  /// Aralık dışındaki veya bozuk değerler uygulamayı düşürmemek için ilgili
  /// varsayılan değerle değiştirilir.
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      focusDurationMinutes: _readMinutes(
        json['focusDurationMinutes'],
        fallback: defaultFocusMinutes,
        min: minFocusMinutes,
        max: maxFocusMinutes,
      ),
      shortBreakMinutes: _readMinutes(
        json['shortBreakMinutes'],
        fallback: defaultShortBreakMinutes,
        min: minShortBreakMinutes,
        max: maxShortBreakMinutes,
      ),
      longBreakMinutes: _readMinutes(
        json['longBreakMinutes'],
        fallback: defaultLongBreakMinutes,
        min: minLongBreakMinutes,
        max: maxLongBreakMinutes,
      ),
      themeMode: _readThemeMode(json['themeMode']),
    );
  }

  static int _readMinutes(
    Object? value, {
    required int fallback,
    required int min,
    required int max,
  }) {
    if (value is! int || value < min || value > max) {
      return fallback;
    }
    return value;
  }

  static ThemeMode _readThemeMode(Object? value) {
    if (value is! String) {
      return ThemeMode.system;
    }
    for (final mode in ThemeMode.values) {
      if (mode.name == value) {
        return mode;
      }
    }
    return ThemeMode.system;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppSettings &&
            other.focusDurationMinutes == focusDurationMinutes &&
            other.shortBreakMinutes == shortBreakMinutes &&
            other.longBreakMinutes == longBreakMinutes &&
            other.themeMode == themeMode;
  }

  @override
  int get hashCode => Object.hash(
    focusDurationMinutes,
    shortBreakMinutes,
    longBreakMinutes,
    themeMode,
  );
}
