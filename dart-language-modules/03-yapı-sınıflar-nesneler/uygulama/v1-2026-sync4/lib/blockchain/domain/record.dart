// DART KONUSU: Class modifiers — `abstract class`. Classes & objects — mixin
// (`with Hashable`), const constructor, soyut getter'lar, typedef ile generic
// fonksiyon tipi.

/// Zincire yazılabilen her işlemin ortak taslağı.
library;

import 'package:sarkisla_yoklama/core/core.dart';

/// Blok içindeki bir işlem (transaction).
///
/// `abstract class` seçildi: ortak davranış ([recordHash], [envelope]) ve
/// ortak sözleşme ([recordType], [toJson]) bir arada bulunur. Somut kayıtlar
/// (`AttendanceRecord`, `CorrectionRecord`) bunu `extends` ile genişletir.
/// Doğrudan örneklenemez.
abstract class Record with Hashable {
  const Record();

  /// `@OnChainRecord(type: ...)` ile aynı değer.
  String get recordType;

  /// Kaydın tekil kimliği.
  String get recordId;

  /// Kaydın veri alanları.
  Map<String, Object?> toJson();

  /// Zincirde saklanan zarf: `{type, data}`.
  Map<String, Object?> get envelope => {'type': recordType, 'data': toJson()};

  @override
  Object? hashPayload() => envelope;

  /// İşlem hash'i. Öğrenciye ilk makbuz olarak gösterilir.
  Hash get recordHash => contentHash;
}

/// Zarftan (`{type, data}`) somut kayıt üreten fonksiyon.
typedef RecordDecoder<T extends Record> = T Function(
  Map<String, Object?> envelope,
);
