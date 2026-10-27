// DART KONUSU: Class modifiers — `abstract final class` (yalnızca static
// sabitlerden oluşan, örneklenemeyen ve türetilemeyen ad alanları).
// Classes & objects — static const üyeler.

/// Tasarım sistemi token'ları: boşluk, köşe, süre, boyut.
library;

import 'package:flutter/widgets.dart';

/// 4/8 dp ritminde boşluklar.
abstract final class Space {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
  static const double huge = 64;

  /// Ekran kenar boşluğu.
  static const EdgeInsets screen = EdgeInsets.symmetric(horizontal: lg);
}

/// Köşe yarıçapları. Küçük ve tutarlı: abartılı yuvarlaklık yok.
abstract final class Radii {
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 14;
  static const double xl = 20;

  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius control = BorderRadius.all(Radius.circular(md));
  static const BorderRadius small = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}

/// Erişilebilirlik ve yerleşim boyutları.
abstract final class Sizes {
  /// Android en küçük dokunma alanı.
  static const double minTouch = 48;

  /// Birincil buton yüksekliği.
  static const double buttonHeight = 48;

  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;

  /// İçerik sütunu genişliği.
  static const double maxContentWidth = 760;

  /// Bu genişlikten sonra giriş ekranı ikiye bölünür.
  static const double splitBreakpoint = 880;
}

/// Animasyon süreleri. Çıkışlar girişlerden kısadır.
abstract final class MotionDurations {
  static const Duration fast = Duration(milliseconds: 140);
  static const Duration medium = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 420);
  static const Duration stagger = Duration(milliseconds: 45);
  static const Duration page = Duration(milliseconds: 320);
}
