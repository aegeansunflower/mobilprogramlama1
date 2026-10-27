// DART KONUSU: Class modifiers — `abstract mixin class`. Classes & objects —
// mixin içinde extension kullanımı.

/// Zaman damgası taşıyan nesneler için ortak davranış.
library;

import 'package:sarkisla_yoklama/core/extensions/date_time_x.dart';

/// Zaman damgası olan nesneler (bloklar, yoklama kayıtları, QR jetonları).
///
/// `abstract mixin class` seçildi: [timestamp] her türde farklı bir alandan
/// gelir (soyut), ancak tazelik ve sıralama yardımcıları ortaktır.
abstract mixin class Timestamped {
  /// Nesnenin oluşturulma anı (UTC).
  DateTime get timestamp;

  /// [now] anına göre [maxAge] süresinden eski mi?
  bool isExpired(Duration maxAge, {required DateTime now}) =>
      now.difference(timestamp) > maxAge;

  /// [other] ile aynı zaman penceresinde mi?
  bool isCloseTo(Timestamped other, Duration window) =>
      timestamp.isWithin(window, other.timestamp);

  /// Zaman sıralaması için karşılaştırıcı.
  static int compare(Timestamped a, Timestamped b) =>
      a.timestamp.compareTo(b.timestamp);
}
