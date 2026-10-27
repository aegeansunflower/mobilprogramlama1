// DART KONUSU: Class modifiers — `abstract interface class` (saf sözleşme) ve
// `final class` uygulamalar. Libraries & imports — `show`.

/// Gizli anahtarlar ve cihaz kimliği için anahtar-değer deposu.
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show FlutterSecureStorage;

/// Güvenli anahtar-değer deposu sözleşmesi.
///
/// `abstract interface class` seçildi: hiçbir ortak davranış içermeyen saf bir
/// sözleşmedir. Yalnızca `implements` edilebilir, örneklenemez.
abstract interface class KeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// `flutter_secure_storage` (Android Keystore / iOS Keychain) uygulaması.
final class SecureKeyValueStore implements KeyValueStore {
  const SecureKeyValueStore([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// Bellek içi uygulama (testler ve demo modu).
final class InMemoryKeyValueStore implements KeyValueStore {
  InMemoryKeyValueStore([Map<String, String>? initial])
    : _values = {...?initial};

  final Map<String, String> _values;

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async => _values[key] = value;

  @override
  Future<void> delete(String key) async => _values.remove(key);
}
