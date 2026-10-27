// DART KONUSU: Classes & objects — const constructor, static const örnek,
// records (`({double latitude, double longitude})`). Class modifiers —
// `abstract interface class` + `final class`.

/// Kampüs coğrafi sınırı.
library;

import 'dart:math' as math;

import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Konum.
typedef GeoPoint = ({double latitude, double longitude});

/// Daire biçimli coğrafi sınır.
@immutable
final class GeofencePolicy {
  const GeofencePolicy({
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
  });

  /// Şarkışla Uygulamalı Bilimler Yüksekokulu yerleşkesi (yaklaşık).
  static const GeofencePolicy sarkislaCampus = GeofencePolicy(
    latitude: 39.3540,
    longitude: 36.4090,
    radiusMeters: 1200,
  );

  final double latitude;
  final double longitude;
  final double radiusMeters;

  /// Haversine uzaklığı (metre).
  double distanceTo(GeoPoint p) {
    const earth = 6371000.0;
    double rad(double d) => d * math.pi / 180;
    final dLat = rad(p.latitude - latitude);
    final dLon = rad(p.longitude - longitude);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(latitude)) *
            math.cos(rad(p.latitude)) *
            math.pow(math.sin(dLon / 2), 2);
    return 2 * earth * math.asin(math.sqrt(a));
  }

  bool contains(GeoPoint p) => distanceTo(p) <= radiusMeters;
}

/// Cihaz konumu.
abstract interface class LocationProvider {
  /// Anlık konum; izin yoksa ya da konum kapalıysa hata.
  Future<Result<GeoPoint>> current();

  /// Konum servisi kullanılabilir mi?
  Future<bool> isAvailable();
}
