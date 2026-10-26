import 'dart:convert';

import '../models/study_task.dart';
import 'local_storage_service.dart';

/// Görevlerin cihazdaki kalıcı kaydını yönetir.
class TaskRepository {
  /// Verilen yerel depolama servisiyle repository oluşturur.
  TaskRepository(this._storage);

  /// Görev listesinin saklandığı anahtar.
  static const String storageKey = 'focus_flow.tasks.v1';

  final LocalStorageService _storage;

  /// Kayıtlı görevleri okur.
  ///
  /// Kayıt yoksa boş liste döner. Bozuk JSON veya tek bir geçersiz görev
  /// uygulamayı düşürmez; geçersiz kayıt atlanır, geçerli olanlar yüklenir.
  List<StudyTask> loadTasks() {
    final raw = _storage.read(storageKey);
    if (raw == null || raw.trim().isEmpty) {
      return const <StudyTask>[];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) {
        return const <StudyTask>[];
      }

      final tasks = <StudyTask>[];
      for (final item in decoded) {
        if (item is! Map<String, dynamic>) {
          continue;
        }
        try {
          tasks.add(StudyTask.fromJson(item));
        } on FormatException {
          continue;
        }
      }
      return List<StudyTask>.unmodifiable(tasks);
    } on FormatException {
      return const <StudyTask>[];
    }
  }

  /// Görev listesini JSON olarak cihaza yazar.
  Future<bool> saveTasks(List<StudyTask> tasks) async {
    try {
      final encoded = jsonEncode(
        tasks.map((task) => task.toJson()).toList(growable: false),
      );
      return await _storage.write(storageKey, encoded);
    } on Object {
      return false;
    }
  }

  /// Kayıtlı tüm görevleri siler.
  Future<bool> clear() => _storage.remove(storageKey);
}
