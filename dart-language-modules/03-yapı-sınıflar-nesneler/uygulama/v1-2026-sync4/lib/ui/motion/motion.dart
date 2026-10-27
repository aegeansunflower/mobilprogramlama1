// DART KONUSU: Classes & objects — `Curve` alt sınıfı (const constructor,
// `@override`), extension methods (`Widget`, `BuildContext`), static üyeler.
// Class modifiers — `final class`, `abstract final class`. Libraries &
// imports — `show`.

/// Framer Motion ilkelerinin Flutter karşılığı: yay (spring) eğrisi, sıralı
/// (stagger) girişler ve "animasyonları azalt" desteği.
library;

import 'package:flutter/physics.dart' show SpringDescription, SpringSimulation;
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sarkisla_yoklama/ui/theme/tokens.dart';

/// Fiziksel yay eğrisi (Framer Motion'daki `type: "spring"`).
///
/// [stiffness] ve [damping] Framer Motion'daki değerlerle aynı anlamdadır.
/// Sönüm oranı 1'in altında olduğu için hafif bir taşma (overshoot) olur.
final class SpringCurve extends Curve {
  const SpringCurve({
    this.mass = 1,
    this.stiffness = 210,
    this.damping = 22,
    this.settleSeconds = 0.75,
  });

  final double mass;
  final double stiffness;
  final double damping;

  /// Yayın "oturduğu" kabul edilen süre; t ∈ [0, 1] bu süreye eşlenir.
  final double settleSeconds;

  @override
  double transformInternal(double t) => SpringSimulation(
    SpringDescription(mass: mass, stiffness: stiffness, damping: damping),
    0,
    1,
    0,
  ).x(t * settleSeconds);
}

/// Hareket sabitleri.
abstract final class Motion {
  /// Varsayılan giriş yayı.
  static const Curve spring = SpringCurve();

  /// Daha sert, taşmasız yay (liste öğeleri).
  static const Curve gentle = SpringCurve(stiffness: 170, damping: 26);

  /// Çıkışlar: hızlı ve sade.
  static const Curve exit = Curves.easeInCubic;
}

/// Hareket tercihi.
extension MotionContext on BuildContext {
  /// Kullanıcı sistemde "animasyonları azalt"ı açtı mı?
  bool get reduceMotion => MediaQuery.maybeDisableAnimationsOf(this) ?? false;
}

/// Giriş animasyonları. "Animasyonları azalt" açıksa widget olduğu gibi
/// döner; hiçbir animasyon denetleyicisi oluşturulmaz.
extension EntranceX on Widget {
  /// Aşağıdan [dy] piksel kayarak, sönerek giriş. [index] sıralı gecikme
  /// sağlar (stagger).
  Widget enter(BuildContext context, {int index = 0, double dy = 10}) {
    if (context.reduceMotion) return this;
    return animate(delay: MotionDurations.stagger * index.clamp(0, 12))
        .fadeIn(duration: MotionDurations.medium, curve: Curves.easeOut)
        .moveY(
          begin: dy,
          end: 0,
          duration: MotionDurations.slow,
          curve: Motion.gentle,
        );
  }

  /// Yayla büyüyerek giriş (başarı ikonları, rozetler).
  Widget pop(BuildContext context, {Duration delay = Duration.zero}) {
    if (context.reduceMotion) return this;
    return animate(delay: delay)
        .fadeIn(duration: MotionDurations.fast)
        .scaleXY(
          begin: 0.6,
          end: 1,
          duration: MotionDurations.slow,
          curve: Motion.spring,
        );
  }
}
