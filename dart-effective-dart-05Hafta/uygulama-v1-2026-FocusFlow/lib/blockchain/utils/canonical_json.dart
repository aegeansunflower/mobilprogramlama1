import 'dart:convert';

import 'package:crypto/crypto.dart';

/// JSON değerlerini anahtar sırasından bağımsız, deterministik biçimde kodlar.
///
/// Blok ve işlem kimlikleri bu çıktı üzerinden hesaplanır. Aynı içerik her
/// zaman aynı bayt dizisini üretmelidir; aksi halde aynı işlem farklı
/// platformlarda farklı hash üretebilir.
String canonicalJsonEncode(Object? value) {
  final buffer = StringBuffer();
  _writeCanonical(value, buffer);
  return buffer.toString();
}

void _writeCanonical(Object? value, StringBuffer buffer) {
  if (value is Map) {
    final entries = value.entries.toList()
      ..sort(
        (first, second) =>
            first.key.toString().compareTo(second.key.toString()),
      );
    buffer.write('{');
    for (var index = 0; index < entries.length; index++) {
      if (index > 0) {
        buffer.write(',');
      }
      buffer.write(jsonEncode(entries[index].key.toString()));
      buffer.write(':');
      _writeCanonical(entries[index].value, buffer);
    }
    buffer.write('}');
    return;
  }

  if (value is Iterable) {
    buffer.write('[');
    var first = true;
    for (final item in value) {
      if (!first) {
        buffer.write(',');
      }
      first = false;
      _writeCanonical(item, buffer);
    }
    buffer.write(']');
    return;
  }

  if (value == null || value is String || value is num || value is bool) {
    buffer.write(jsonEncode(value));
    return;
  }

  throw ArgumentError.value(
    value,
    'value',
    'Kanonik JSON yalnızca ilkel değerleri, listeleri ve haritaları destekler.',
  );
}

/// Verilen metnin SHA-256 özetini küçük harfli hex olarak döndürür.
String sha256Hex(String input) {
  return sha256.convert(utf8.encode(input)).toString();
}
