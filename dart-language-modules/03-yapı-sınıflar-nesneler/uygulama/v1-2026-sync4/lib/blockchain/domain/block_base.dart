// DART KONUSU: Class modifiers — `abstract base class` ve `base mixin`.
// Metadata — `@protected`, `@mustCallSuper`. Classes & objects — initializer
// list (`assert`), soyut getter'lar, mixin (`with Timestamped`), `on` kısıtlı
// mixin.

/// Blokların ortak taslağı ve imza mixin'i.
library;

import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/blockchain/domain/signing.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Tüm blok türlerinin ortak başlık (header) alanları ve hash hesabı.
///
/// `abstract base class` seçildi:
/// * `abstract`: başlık alanları tek başına bir blok değildir, örneklenemez.
/// * `base`: başka kütüphaneler bu sınıfı `implements` edemez, yalnızca
///   `extends` edebilir. Böylece [computeHash] mantığını atlayıp sahte bir
///   "blok" üretmek mümkün olmaz. Alt sınıflar da `base`, `final` ya da
///   `sealed` olmak zorundadır; zincir bu şekilde korunur.
abstract base class BlockBase with Timestamped {
  BlockBase({
    required this.index,
    required this.timestamp,
    required this.previousHash,
    required this.authorityId,
  }) : assert(index >= 0, 'Blok indeksi negatif olamaz'),
       assert(timestamp.isUtc, 'Blok zamanı UTC olmalıdır');

  /// Zincirdeki sıra numarası (genesis = 0).
  final int index;

  @override
  final DateTime timestamp;

  /// Bir önceki bloğun hash'i.
  final Hash previousHash;

  /// Bloğu imzalayan yetkilinin kimliği.
  final String authorityId;

  /// İşlemlerin Merkle kökü.
  Hash get merkleRoot;

  /// Bloğun hash'i (saklanan ya da hesaplanan).
  Hash get hash;

  /// Genesis bloğu mu?
  bool get isGenesis => index == 0;

  /// Hash'e giren başlık alanları. Alt sınıflar alan ekleyebilir ama
  /// `super.header()` çıktısını korumalıdır.
  @protected
  @mustCallSuper
  Map<String, Object?> header() => {
    'index': index,
    'timestamp': timestamp.millisecondsSinceEpoch,
    'previousHash': previousHash.hex,
    'merkleRoot': merkleRoot.hex,
    'authority': authorityId,
  };

  /// Başlıktan hash'i yeniden hesaplar.
  Hash computeHash() => Hash.of(canonicalBytes(header()));
}

/// İmzalı bloklar için ortak davranış.
///
/// `base mixin` seçildi: `on BlockBase` kısıtı, `base` bir sınıfa bağlı
/// olduğundan mixin'in de `base` olmasını gerektirir. Dart'ta `final mixin`
/// diye bir bildirim yoktur; mixin'lere yalnızca `base` değiştiricisi
/// uygulanabilir.
base mixin Signed on BlockBase {
  /// Yetkilinin, blok hash'i üzerine attığı imza.
  List<int>? get signature;

  /// İmzalı mı?
  bool get isSigned => signature != null;

  /// İmzayı [publicKey] ile doğrular.
  Future<bool> verifySignature(
    SignatureVerifier verifier,
    List<int> publicKey,
  ) async {
    final sig = signature;
    if (sig == null) return false;
    return await verifier.verify(
      hash.bytes,
      signature: sig,
      publicKey: publicKey,
    );
  }
}
