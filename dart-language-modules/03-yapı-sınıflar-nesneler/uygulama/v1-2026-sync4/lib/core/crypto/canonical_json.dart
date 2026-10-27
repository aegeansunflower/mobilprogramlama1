// DART KONUSU: Libraries & imports — kütüphane düzeyinde gizlilik (`_`
// önekli üst düzey fonksiyon dışarıya görünmez), `show` ile seçici import.

/// Hash için deterministik (kanonik) JSON üretimi.
library;

import 'dart:convert' show jsonEncode, utf8;

/// Anahtarları özyinelemeli olarak sıralanmış JSON üretir.
///
/// Aynı veri her cihazda aynı bayt dizisini vermelidir; aksi halde aynı
/// blok farklı cihazlarda farklı hash üretir.
String canonicalJson(Object? value) => jsonEncode(_sorted(value));

/// [canonicalJson] çıktısının UTF-8 baytları.
List<int> canonicalBytes(Object? value) => utf8.encode(canonicalJson(value));

// Kütüphaneye özel: yalnızca bu dosyadan erişilebilir.
Object? _sorted(Object? value) => switch (value) {
  final Map<Object?, Object?> map => {
    for (final key in map.keys.map((k) => k.toString()).toList()..sort())
      key: _sorted(map[key]),
  },
  final List<Object?> list => [for (final item in list) _sorted(item)],
  _ => value,
};
