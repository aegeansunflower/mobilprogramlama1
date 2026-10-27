// DART KONUSU: Libraries & imports — `show` ile seçici import. Class
// modifiers — `final class` uygulamalar. Classes & objects — private alan,
// önbellek (`??=`).

/// Cihaz kimliği (bir cihaz = bir öğrenci kuralı için).
library;

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:sarkisla_yoklama/auth/domain/auth_services.dart';
import 'package:sarkisla_yoklama/core/core.dart';
import 'package:uuid/uuid.dart' show Uuid;

/// Kimliği ilk açılışta üretip güvenli depoda saklar.
///
/// Android 10+ ve iOS kalıcı donanım kimliği vermediği için kurulum başına
/// rastgele bir UUID kullanılır. Uygulama silinip yeniden kurulursa kimlik
/// değişir ve öğrenci, hesabının cihaz eşleşmesini sıfırlatmak için
/// bölüm sekreterliğine başvurur.
final class SecureDeviceIdentity implements DeviceIdentity {
  SecureDeviceIdentity(this._store);

  static const String _key = 'device.id';

  final KeyValueStore _store;
  String? _cached;

  @override
  Future<String> deviceId() async {
    if (_cached case final id?) return id;
    final stored = await _store.read(_key);
    if (stored != null) return _cached = stored;
    final created = const Uuid().v4();
    await _store.write(_key, created);
    return _cached = created;
  }

  /// Platform adı. (Marka/model okumak için ek bir yerel eklenti gerekir;
  /// kimlik eşleştirmesi bu ada değil, [deviceId]'ye dayanır.)
  @override
  Future<String> deviceLabel() async => kIsWeb
      ? 'Web tarayıcı'
      : switch (defaultTargetPlatform) {
          TargetPlatform.android => 'Android',
          TargetPlatform.iOS => 'iPhone',
          final other => other.name,
        };
}

/// Sabit kimlik (demo modu ve testler).
final class FixedDeviceIdentity implements DeviceIdentity {
  const FixedDeviceIdentity(this.id, {this.label = 'Demo cihaz'});

  final String id;
  final String label;

  @override
  Future<String> deviceId() async => id;

  @override
  Future<String> deviceLabel() async => label;
}
