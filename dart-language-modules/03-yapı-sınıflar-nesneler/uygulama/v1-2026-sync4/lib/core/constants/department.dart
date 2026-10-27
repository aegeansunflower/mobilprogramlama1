// DART KONUSU: Classes & objects — enhanced enum, const constructor, static
// metot.

/// Yüksekokuldaki iki bölüm.
library;

/// Şarkışla UBYO bölümleri. Uygulama yalnızca bu iki bölümü destekler.
enum Department {
  /// Bilişim Sistemleri ve Teknolojileri.
  informationSystems(code: 'BST', label: 'Bilişim Sistemleri ve Teknolojileri'),

  /// Yapay Zeka ve Makine Öğrenmesi.
  artificialIntelligence(code: 'YZM', label: 'Yapay Zeka ve Makine Öğrenmesi');

  const Department({required this.code, required this.label});

  /// Kısa bölüm kodu (Firestore'da saklanır).
  final String code;

  /// Tam bölüm adı.
  final String label;

  /// Koddan bölüm bulur; bilinmeyen kodda [ArgumentError] fırlatır.
  static Department fromCode(String code) => values.firstWhere(
    (d) => d.code == code,
    orElse: () => throw ArgumentError.value(code, 'code', 'Bilinmeyen bölüm'),
  );
}
