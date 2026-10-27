// DART KONUSU: Classes & objects — extension methods (`DateTime` üzerine).

/// `DateTime` yardımcıları.
library;

import 'package:intl/intl.dart' show DateFormat;

/// Yoklama kurallarında ve arayüzde kullanılan tarih yardımcıları.
extension DateTimeX on DateTime {
  /// [other] ile arasındaki fark [window] süresini aşmıyor mu?
  /// QR tazeliği ve geç kalma hesabında kullanılır.
  bool isWithin(Duration window, DateTime other) =>
      difference(other).abs() <= window;

  /// Zincirde saklanan biçim: milisaniye hassasiyetinde UTC.
  int get epochMillisUtc => toUtc().millisecondsSinceEpoch;

  /// Günün başlangıcı (yerel saat).
  DateTime get startOfDay => DateTime(year, month, day);

  /// `07.10.2026 14:05` biçimi.
  String get trDateTime =>
      DateFormat('dd.MM.yyyy HH:mm', 'tr').format(toLocal());

  /// `07 Eki 2026` biçimi.
  String get trDate => DateFormat('dd MMM yyyy', 'tr').format(toLocal());

  /// `14:05:09` biçimi.
  String get trTime => DateFormat('HH:mm:ss', 'tr').format(toLocal());
}

/// Zincirden okunan milisaniyeleri `DateTime`'a çevirir.
extension EpochMillisX on int {
  /// UTC `DateTime`.
  DateTime get asUtcDateTime =>
      DateTime.fromMillisecondsSinceEpoch(this, isUtc: true);
}
