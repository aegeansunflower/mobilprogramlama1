/// Yerel ödül mağazasında FOCUS karşılığında kullanılabilen ödüller.
enum RewardOffer {
  /// Kısa bir kahve molası.
  coffeeBreak(
    title: 'Kahve Molası',
    description: 'Kendine bir kahve ısmarla ve 10 dakika ekrandan uzaklaş.',
    cost: 10,
    iconName: 'local_cafe',
  ),

  /// Bir bölüm dizi veya video molası.
  episodeBreak(
    title: 'Bir Bölüm Dizi',
    description: 'Hak ettiğin bir bölümü izle, zihnini dinlendir.',
    cost: 20,
    iconName: 'movie',
  ),

  /// Oyun veya gezinme molası.
  gameBreak(
    title: 'Oyun Molası',
    description: '45 dakika oyun oyna veya sevdiğin bir yeri gez.',
    cost: 30,
    iconName: 'sports_esports',
  ),

  /// Tam bir dinlenme günü.
  restDay(
    title: 'Dinlenme Günü',
    description: 'Bir günü tamamen dinlenmeye ayır; deftere de bunu yaz.',
    cost: 50,
    iconName: 'beach_access',
  );

  const RewardOffer({
    required this.title,
    required this.description,
    required this.cost,
    required this.iconName,
  });

  /// Ödülün kullanıcıya gösterilen adı.
  final String title;

  /// Ödülün ne işe yaradığını anlatan kısa metin.
  final String description;

  /// Ödülün FOCUS cinsinden maliyeti.
  final int cost;

  /// UI katmanında Material ikonuna eşlenen ikon adı.
  final String iconName;

  /// Kayıtlı işlem metadata'sındaki kimlikle eşleşen ödülü bulur.
  static RewardOffer? fromId(String? id) {
    for (final offer in values) {
      if (offer.name == id) {
        return offer;
      }
    }
    return null;
  }
}
