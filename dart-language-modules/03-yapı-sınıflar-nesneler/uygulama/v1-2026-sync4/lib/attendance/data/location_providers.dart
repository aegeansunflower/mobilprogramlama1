// DART KONUSU: Libraries & imports — `show`. Class modifiers — `final class`.

/// Konum sağlayıcıları.
library;

import 'package:geolocator/geolocator.dart'
    show Geolocator, LocationAccuracy, LocationPermission, LocationSettings;
import 'package:sarkisla_yoklama/attendance/domain/geofence.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// `geolocator` ile gerçek cihaz konumu.
final class DeviceLocationProvider implements LocationProvider {
  const DeviceLocationProvider();

  @override
  Future<bool> isAvailable() => Geolocator.isLocationServiceEnabled();

  @override
  Future<Result<GeoPoint>> current() async {
    if (!await isAvailable()) {
      return const Err(ValidationFailure('Konum servisi kapalı.'));
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return const Err(PermissionFailure('Konum izni verilmedi.'));
    }
    final p = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
    return Ok((latitude: p.latitude, longitude: p.longitude));
  }
}

/// Sabit konum (demo ve testler).
final class FixedLocationProvider implements LocationProvider {
  const FixedLocationProvider(this.point);

  final GeoPoint point;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<Result<GeoPoint>> current() async => Ok(point);
}
