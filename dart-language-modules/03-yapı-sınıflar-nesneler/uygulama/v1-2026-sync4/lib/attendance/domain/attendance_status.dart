// DART KONUSU: Class modifiers — `sealed class AttendanceStatus` (Present,
// Late, Absent, Excused) ve `final class` alt türler; `switch` ile eksiksiz
// (exhaustive) kontrol. Classes & objects — const / factory constructor,
// soyut getter, `operator ==` / `hashCode`. Metadata — `@immutable`.

/// Yoklama durumu.
library;

import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/core/crypto/canonical_json.dart';

/// Bir öğrencinin bir oturumdaki durumu.
///
/// `sealed` seçildi: rapor, istatistik ve arayüz kodu her durumu `switch`
/// ile ele alır. Örneğin "Mazeretli" eklenmeden önce yazılmış bir ekran, bu
/// tür eklendiği anda derleme hatası verir ve hiçbir durum sessizce
/// "devamsız" sayılmaz.
@immutable
sealed class AttendanceStatus {
  const AttendanceStatus();

  /// JSON'dan durum üretir (factory constructor + switch ifadesi).
  factory AttendanceStatus.fromJson(Map<String, Object?> json) =>
      switch (json['code']) {
        'present' => const Present(),
        'late' => Late(json['minutesLate']! as int),
        'absent' => const Absent(),
        'excused' => Excused(json['reason']! as String),
        final other => throw FormatException('Bilinmeyen durum', other),
      };

  /// Zincirde saklanan kısa kod.
  String get code;

  /// Türkçe etiket.
  String get label;

  /// Devam yüzdesine "katıldı" olarak sayılır mı?
  bool get countsAsAttended => switch (this) {
    Present() || Late() || Excused() => true,
    Absent() => false,
  };

  Map<String, Object?> toJson() => {'code': code};

  // İki durum, zincirdeki gösterimleri aynıysa eşittir.
  @override
  bool operator ==(Object other) =>
      other is AttendanceStatus && canonicalJson(other.toJson()) == _canonical;

  @override
  int get hashCode => _canonical.hashCode;

  String get _canonical => canonicalJson(toJson());

  @override
  String toString() => label;
}

/// Zamanında katıldı.
final class Present extends AttendanceStatus {
  const Present();

  @override
  String get code => 'present';

  @override
  String get label => 'Katıldı';
}

/// Geç katıldı.
final class Late extends AttendanceStatus {
  const Late(this.minutesLate) : assert(minutesLate > 0, 'Gecikme pozitif');

  final int minutesLate;

  @override
  String get code => 'late';

  @override
  String get label => 'Geç ($minutesLate dk)';

  @override
  Map<String, Object?> toJson() => {
    ...super.toJson(),
    'minutesLate': minutesLate,
  };
}

/// Katılmadı.
final class Absent extends AttendanceStatus {
  const Absent();

  @override
  String get code => 'absent';

  @override
  String get label => 'Devamsız';
}

/// Mazeretli (rapor, görevlendirme …). Yalnızca düzeltme bloğuyla verilir.
final class Excused extends AttendanceStatus {
  const Excused(this.reason);

  final String reason;

  @override
  String get code => 'excused';

  @override
  String get label => 'Mazeretli';

  @override
  Map<String, Object?> toJson() => {...super.toJson(), 'reason': reason};
}
