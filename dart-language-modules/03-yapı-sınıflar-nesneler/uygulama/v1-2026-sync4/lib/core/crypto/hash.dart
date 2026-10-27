// DART KONUSU: Class modifiers — `final class`. Classes & objects — private
// named constructor, const constructor, factory constructor'lar, static üye,
// getter, `operator ==` / `hashCode`, `toString`. Libraries & imports — `as`.
// Metadata — `@immutable`.

/// SHA-256 özetini temsil eden değer nesnesi.
library;

import 'dart:convert' show utf8;

import 'package:crypto/crypto.dart' as crypto;
import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/core/extensions/string_x.dart';

/// 32 baytlık SHA-256 özeti.
///
/// `final class` seçildi: hash'in eşitlik ve biçim kuralları zincir güvenliği
/// için kritik. Dışarıdan alt sınıflanırsa (`extends`) ya da taklit edilirse
/// (`implements`) bu kurallar delinebilirdi.
@immutable
final class Hash {
  // Private const constructor: yalnızca doğrulanmış hex ile çağrılır.
  const Hash._(this.hex);

  /// Onaltılık metinden oluşturur ve biçimi doğrular.
  factory Hash.fromHex(String hex) {
    final normalized = hex.toLowerCase();
    if (!_hexPattern.hasMatch(normalized)) {
      throw FormatException('Geçersiz SHA-256 hex', hex);
    }
    return Hash._(normalized);
  }

  /// Ham baytların SHA-256 özeti.
  factory Hash.of(List<int> bytes) =>
      Hash._(crypto.sha256.convert(bytes).toString());

  /// Metnin UTF-8 baytlarının SHA-256 özeti.
  factory Hash.ofString(String text) => Hash.of(utf8.encode(text));

  /// Genesis bloğunun `previousHash` değeri (64 sıfır).
  static const Hash zero = Hash._(
    '0000000000000000000000000000000000000000000000000000000000000000',
  );

  static final RegExp _hexPattern = RegExp(r'^[0-9a-f]{64}$');

  /// Küçük harfli 64 karakterlik onaltılık gösterim.
  final String hex;

  /// 32 baytlık ham değer.
  List<int> get bytes => hex.hexToBytes;

  /// Arayüz için kısaltılmış gösterim.
  String get short => hex.shortened();

  @override
  bool operator ==(Object other) => other is Hash && other.hex == hex;

  @override
  int get hashCode => hex.hashCode;

  @override
  String toString() => 'Hash($short)';
}
