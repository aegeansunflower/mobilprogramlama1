// DART KONUSU: Class modifiers — `abstract mixin class`. Classes & objects —
// mixin, soyut metot, getter.

/// Kendi hash'ini hesaplayabilen nesneler için mixin.
library;

import 'package:sarkisla_yoklama/core/crypto/canonical_json.dart';
import 'package:sarkisla_yoklama/core/crypto/hash.dart';

/// Kanonik içeriğinden SHA-256 hash'i üreten nesneler.
///
/// `abstract mixin class` seçildi:
/// * `mixin` olarak `with Hashable` ile kayıt sınıflarına karıştırılır.
/// * `abstract class` olarak `extends Hashable` ile de kullanılabilir.
/// * `abstract` olduğu için [hashPayload] uygulanmadan örneklenemez.
abstract mixin class Hashable {
  /// Hash'e giren içerik. Kanonik JSON'a çevrilir.
  Object? hashPayload();

  /// İçeriğin SHA-256 hash'i.
  Hash get contentHash => Hash.of(canonicalBytes(hashPayload()));
}
