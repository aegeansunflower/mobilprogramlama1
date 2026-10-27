/// Zincir doğrulama işleminin sonucu.
class ChainValidationResult {
  /// Doğrulama sonucunu oluşturur.
  const ChainValidationResult({
    required this.isValid,
    required this.message,
    required this.checkedBlocks,
    required this.checkedTransactions,
    required this.checkedAt,
    this.invalidBlockIndex,
  });

  /// Zincir bütünlüğü ve imzalar geçerli mi?
  final bool isValid;

  /// Kullanıcıya gösterilecek kısa sonuç mesajı.
  final String message;

  /// Kontrol edilen blok sayısı.
  final int checkedBlocks;

  /// Kontrol edilen işlem sayısı.
  final int checkedTransactions;

  /// Doğrulamanın yapıldığı zaman.
  final DateTime checkedAt;

  /// Hata varsa ilgili blok indeksi.
  final int? invalidBlockIndex;

  /// Doğrulama başarısız mı?
  bool get hasError => !isValid;
}
