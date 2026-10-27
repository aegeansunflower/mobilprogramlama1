import 'dart:convert';

import '../models/focus_session.dart';
import 'local_storage_service.dart';

/// Tamamlanan Pomodoro oturumlarının cihazdaki kalıcı kaydını yönetir.
class FocusSessionRepository {
  /// Verilen yerel depolama servisiyle repository oluşturur.
  FocusSessionRepository(this._storage);

  /// Oturum listesinin saklandığı anahtar.
  static const String storageKey = 'focus_flow.sessions.v1';

  final LocalStorageService _storage;

  /// Kayıtlı oturumları okur.
  ///
  /// Kayıt yoksa boş liste döner. Bozuk JSON veya geçersiz tek kayıt
  /// uygulamayı düşürmez; yalnızca o kayıt atlanır.
  List<FocusSession> loadSessions() {
    final raw = _storage.read(storageKey);
    if (raw == null || raw.trim().isEmpty) {
      return const <FocusSession>[];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) {
        return const <FocusSession>[];
      }

      final sessions = <FocusSession>[];
      for (final item in decoded) {
        if (item is! Map<String, dynamic>) {
          continue;
        }
        try {
          sessions.add(FocusSession.fromJson(item));
        } on FormatException {
          continue;
        }
      }
      return List<FocusSession>.unmodifiable(sessions);
    } on FormatException {
      return const <FocusSession>[];
    }
  }

  /// Oturum listesini JSON olarak cihaza yazar.
  Future<bool> saveSessions(List<FocusSession> sessions) async {
    try {
      final encoded = jsonEncode(
        sessions.map((session) => session.toJson()).toList(growable: false),
      );
      return await _storage.write(storageKey, encoded);
    } on Object {
      return false;
    }
  }

  /// Kayıtlı tüm oturumları siler.
  Future<bool> clear() => _storage.remove(storageKey);
}
