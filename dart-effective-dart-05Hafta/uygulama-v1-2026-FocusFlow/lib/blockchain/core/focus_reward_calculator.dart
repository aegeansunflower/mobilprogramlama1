import '../core/focus_chain_network.dart';

/// Odak süresinden kazanılacak FOCUS miktarını hesaplar.
abstract final class FocusRewardCalculator {
  /// Tamamlanan oturumun saniye cinsinden süresine göre ödülü döndürür.
  ///
  /// Her tam beş dakika için [FocusChainNetwork.focusRewardPerFiveMinutes]
  /// FOCUS verilir. Beş dakikadan kısa oturumlarda en az bir FOCUS verilir.
  static int forSeconds(int seconds) {
    if (seconds <= 0) {
      return 0;
    }
    final units = seconds ~/ 300;
    return units < 1 ? 1 : units * FocusChainNetwork.focusRewardPerFiveMinutes;
  }

  /// Dakika cinsinden tahmini ödülü döndürür.
  static int forMinutes(int minutes) => forSeconds(minutes * 60);
}
