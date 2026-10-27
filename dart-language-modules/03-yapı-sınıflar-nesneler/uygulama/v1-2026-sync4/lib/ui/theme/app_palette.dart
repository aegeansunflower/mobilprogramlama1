// DART KONUSU: Classes & objects — `ThemeExtension<T>` alt sınıfı (generics),
// const constructor, `copyWith`, `lerp` override, factory constructor, records
// ile çoklu dönüş. Metadata — `@override`, `@immutable`.

/// Semantik renk token'ları (rol ve tema bazlı).
library;

import 'package:flutter/material.dart';
import 'package:sarkisla_yoklama/attendance/attendance.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Uygulamaya özgü renkler. Bileşenlerde ham hex yerine yalnızca bu
/// token'lar kullanılır.
///
/// Renk dili: sıcak kâğıt tonlu nötr zemin, ince çizgili yüzeyler ve tek bir
/// mat vurgu rengi.
/// * Öğretim görevlisi: bordo (okulun kırmızısıyla uyumlu).
/// * Öğrenci: koyu yeşil.
/// * Rol seçilmemişken: mürekkep siyahı.
///
/// Tüm metin/zemin çiftleri WCAG AA (≥ 4.5:1) sağlar.
@immutable
final class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.brand,
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textMuted,
    required this.present,
    required this.late,
    required this.absent,
    required this.excused,
  });

  /// Rol ve parlaklığa göre palet.
  factory AppPalette.of(Brightness brightness, Role? role) {
    final dark = brightness == Brightness.dark;
    final (Color accent, Color soft, Color on) = switch ((role, dark)) {
      (Role.instructor, false) => (
        const Color(0xFF8C1C2B),
        const Color(0xFFF6E8E9),
        Colors.white,
      ),
      (Role.instructor, true) => (
        const Color(0xFFEBA3AB),
        const Color(0xFF2E1B1D),
        const Color(0xFF2A0A0F),
      ),
      (Role.student, false) => (
        const Color(0xFF1F5F4A),
        const Color(0xFFE5EFEA),
        Colors.white,
      ),
      (Role.student, true) => (
        const Color(0xFF8FD1B8),
        const Color(0xFF17261F),
        const Color(0xFF0B2A20),
      ),
      (null, false) => (
        const Color(0xFF1A1814),
        const Color(0xFFEEECE7),
        Colors.white,
      ),
      (null, true) => (
        const Color(0xFFF3F1EC),
        const Color(0xFF2A2824),
        const Color(0xFF141311),
      ),
    };
    return dark
        ? AppPalette(
            accent: accent,
            accentSoft: soft,
            onAccent: on,
            brand: const Color(0xFFF0626B),
            background: const Color(0xFF141311),
            surface: const Color(0xFF1C1A17),
            surfaceMuted: const Color(0xFF23211D),
            border: const Color(0xFF2F2C27),
            borderStrong: const Color(0xFF45413A),
            textPrimary: const Color(0xFFF3F1EC),
            textMuted: const Color(0xFFA8A39A),
            present: const Color(0xFF6FCF97),
            late: const Color(0xFFF2B45C),
            absent: const Color(0xFFF28B82),
            excused: const Color(0xFFB9A3F5),
          )
        : AppPalette(
            accent: accent,
            accentSoft: soft,
            onAccent: on,
            brand: const Color(0xFFE20613),
            background: const Color(0xFFF7F6F3),
            surface: Colors.white,
            surfaceMuted: const Color(0xFFF1EFEA),
            border: const Color(0xFFE6E3DD),
            borderStrong: const Color(0xFFCFCAC1),
            textPrimary: const Color(0xFF1A1814),
            textMuted: const Color(0xFF5B5750),
            present: const Color(0xFF1E7A46),
            late: const Color(0xFF9A5A06),
            absent: const Color(0xFFB42318),
            excused: const Color(0xFF6941C6),
          );
  }

  /// Rol vurgu rengi (butonlar, seçili öğeler, rozetler).
  final Color accent;

  /// Vurgu renginin çok açık tonu (ikon zeminleri, seçili satırlar).
  final Color accentSoft;
  final Color onAccent;

  /// Okulun kurumsal kırmızısı. Yalnızca logo çevresinde kullanılır.
  final Color brand;

  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color border;
  final Color borderStrong;
  final Color textPrimary;
  final Color textMuted;
  final Color present;
  final Color late;
  final Color absent;
  final Color excused;

  /// Yoklama durumunun rengi. `sealed` hiyerarşi sayesinde eksiksiz.
  Color statusColor(AttendanceStatus status) => switch (status) {
    Present() => present,
    Late() => late,
    Absent() => absent,
    Excused() => excused,
  };

  @override
  AppPalette copyWith({Color? accent, Color? accentSoft, Color? onAccent}) =>
      AppPalette(
        accent: accent ?? this.accent,
        accentSoft: accentSoft ?? this.accentSoft,
        onAccent: onAccent ?? this.onAccent,
        brand: brand,
        background: background,
        surface: surface,
        surfaceMuted: surfaceMuted,
        border: border,
        borderStrong: borderStrong,
        textPrimary: textPrimary,
        textMuted: textMuted,
        present: present,
        late: late,
        absent: absent,
        excused: excused,
      );

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      accent: l(accent, other.accent),
      accentSoft: l(accentSoft, other.accentSoft),
      onAccent: l(onAccent, other.onAccent),
      brand: l(brand, other.brand),
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceMuted: l(surfaceMuted, other.surfaceMuted),
      border: l(border, other.border),
      borderStrong: l(borderStrong, other.borderStrong),
      textPrimary: l(textPrimary, other.textPrimary),
      textMuted: l(textMuted, other.textMuted),
      present: l(present, other.present),
      late: l(late, other.late),
      absent: l(absent, other.absent),
      excused: l(excused, other.excused),
    );
  }
}

/// `context.palette` kısayolu.
extension PaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
