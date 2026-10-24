/// FocusChain ağının sabitleri ve adres kuralları.
abstract final class FocusChainNetwork {
  /// Ağın kullanıcıya gösterilen adı.
  static const String name = 'FocusFlow Proof';

  /// Yerel cüzdanda kullanılan token sembolü.
  static const String tokenSymbol = 'FOCUS';

  /// Sistem tarafından üretilen ödüllerin kaynak adresi.
  static const String systemAddress = 'FOCUSFLOW_SYSTEM';

  /// Transferlerde yakılan tokenların hedef adresi.
  static const String burnAddress = 'FOCUSFLOW_BURN';

  /// Yeni blokların varsayılan proof-of-work zorluğu.
  static const int defaultDifficulty = 3;

  /// Yeni cüzdana genesis bloğunda verilen hoş geldin ödülü.
  static const int welcomeBonus = 10;

  /// Her başarıyla üretilen blok için madenciye verilen ödül.
  static const int blockReward = 1;

  /// Tamamlanan her beş odak dakikası için verilen token.
  static const int focusRewardPerFiveMinutes = 1;

  /// Tamamlanan her görev için verilen token.
  static const int taskReward = 2;

  /// Tek bir blokta yer alabilecek en fazla işlem sayısı.
  static const int maxTransactionsPerBlock = 20;

  /// Genesis bloğunun önceki hash değeri.
  static const String genesisPreviousHash =
      '0000000000000000000000000000000000000000000000000000000000000000';

  static final RegExp _addressPattern = RegExp(r'^0x[a-f0-9]{40}$');

  /// Yerel cüzdan adreslerinin `0x` ile başlayan 40 hex karakterli olmasını
  /// doğrular.
  static bool isValidUserAddress(String value) {
    return _addressPattern.hasMatch(value);
  }

  /// Proof-of-work hedefini (`000...`) üretir.
  static String difficultyTarget(int difficulty) {
    return List<String>.filled(difficulty, '0').join();
  }
}
