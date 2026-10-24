import 'dart:convert';

import '../models/app_settings.dart';
import 'local_storage_service.dart';

/// Kullanıcı ayarlarının cihazdaki kalıcı kaydını yönetir.
class SettingsRepository {
  /// Verilen yerel depolama servisiyle repository oluşturur.
  SettingsRepository(this._storage);

  /// Ayarların saklandığı anahtar.
  static const String storageKey = 'focus_flow.settings.v1';

  final LocalStorageService _storage;

  /// Kayıtlı ayarları okur.
  ///
  /// Kayıt yoksa veya okunan değerler bozuksa güvenli varsayılanlar döner.
  AppSettings loadSettings() {
    final raw = _storage.read(storageKey);
    if (raw == null || raw.trim().isEmpty) {
      return const AppSettings();
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return const AppSettings();
      }
      return AppSettings.fromJson(decoded);
    } on FormatException {
      return const AppSettings();
    }
  }

  /// Ayarları JSON olarak cihaza yazar.
  Future<bool> saveSettings(AppSettings settings) async {
    try {
      return await _storage.write(storageKey, jsonEncode(settings.toJson()));
    } on Object {
      return false;
    }
  }

  /// Kayıtlı ayarları siler.
  Future<bool> clear() => _storage.remove(storageKey);
}
