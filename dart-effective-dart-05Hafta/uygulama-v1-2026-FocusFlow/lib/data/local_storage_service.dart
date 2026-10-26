import 'package:shared_preferences/shared_preferences.dart';

/// [SharedPreferences] üzerine ince bir, hata toleranslı katman.
///
/// Repository sınıfları JSON kodlama/çözme işini üstlenir; bu sınıf yalnızca
/// anahtar-değer okuma ve yazma işlemlerini yönetir. Depolama hataları
/// uygulamayı düşürmemek için `false` olarak raporlanır.
class LocalStorageService {
  /// Mevcut [SharedPreferences] örneğiyle servisi oluşturur.
  const LocalStorageService(this._preferences);

  final SharedPreferences _preferences;

  /// Verilen anahtardaki metni döndürür; kayıt yoksa `null` döner.
  String? read(String key) => _preferences.getString(key);

  /// Metni kalıcı olarak yazar; işlem başarılıysa `true` döner.
  Future<bool> write(String key, String value) async {
    try {
      return await _preferences.setString(key, value);
    } catch (_) {
      return false;
    }
  }

  /// Verilen anahtardaki kaydı siler; başarılıysa `true` döner.
  Future<bool> remove(String key) async {
    try {
      return await _preferences.remove(key);
    } catch (_) {
      return false;
    }
  }
}
