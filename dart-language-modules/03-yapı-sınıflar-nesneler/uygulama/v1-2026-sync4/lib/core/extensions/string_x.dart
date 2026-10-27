// DART KONUSU: Classes & objects — extension methods (`String`, `List<int>`).
// Libraries & imports — `as` ile önekli içe aktarma (`crypto` paketinin
// kendi `Hash` sınıfı bizim `Hash` sınıfımızla çakışır).

/// Metin ve bayt yardımcıları.
library;

import 'dart:convert' show base64Url, utf8;

import 'package:crypto/crypto.dart' as crypto;

/// Metin yardımcıları.
extension StringX on String {
  /// UTF-8 baytlarının SHA-256 özetini onaltılık olarak döndürür.
  String get sha256Hex => crypto.sha256.convert(utf8.encode(this)).toString();

  /// Uzun hash'leri `a1b2c3d4…e5f6a7` biçiminde kısaltır.
  String shortened({int head = 8, int tail = 6}) => length <= head + tail + 1
      ? this
      : '${substring(0, head)}…${substring(length - tail)}';

  /// Türkçe büyük harf: `i → İ`, `ı → I`. Dart'ın `toUpperCase()` metodu
  /// dil kurallarını bilmez ve "Sivas"ı "SIVAS" yapar; bu metot "SİVAS"
  /// üretir.
  String get toUpperTr =>
      replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();

  /// Okul numarası biçimi: 9–12 hane.
  bool get isValidStudentNumber => RegExp(r'^\d{9,12}$').hasMatch(this);

  /// Onaltılık metni bayt listesine çevirir.
  List<int> get hexToBytes {
    if (length.isOdd) throw FormatException('Tek uzunlukta hex', this);
    return [
      for (var i = 0; i < length; i += 2)
        int.parse(substring(i, i + 2), radix: 16),
    ];
  }

  /// Base64url metni bayt listesine çevirir.
  List<int> get base64UrlToBytes => base64Url.decode(base64Url.normalize(this));
}

/// Bayt listesi yardımcıları.
extension BytesX on List<int> {
  /// Küçük harfli onaltılık gösterim.
  String get toHex => map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  /// Base64url gösterim (QR içeriğinde kısalık için).
  String get toBase64Url => base64Url.encode(this);
}
