import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:focus_flow/data/local_storage_service.dart';
import 'package:focus_flow/data/task_repository.dart';
import 'package:focus_flow/models/study_task.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('görevler kaydedilir ve yeniden yüklenir', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();
    final repository = TaskRepository(LocalStorageService(preferences));
    final task = StudyTask(
      id: 'task_1',
      title: 'Kalıcılık testi',
      category: 'Mobil Programlama',
      createdAt: DateTime(2026, 10, 24, 9),
    );

    expect(await repository.saveTasks(<StudyTask>[task]), isTrue);
    final loaded = repository.loadTasks();

    expect(loaded, hasLength(1));
    expect(loaded.single.id, task.id);
    expect(loaded.single.title, task.title);
    expect(loaded.single.category, task.category);
  });

  test('bozuk kayıt uygulamayı düşürmez', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      TaskRepository.storageKey: 'geçersiz json',
    });
    final preferences = await SharedPreferences.getInstance();
    final repository = TaskRepository(LocalStorageService(preferences));

    expect(repository.loadTasks(), isEmpty);
  });

  test('geçersiz görev kaydı atlanır, geçerli kayıt yüklenir', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      TaskRepository.storageKey:
          '[{"id":"bozuk","title":"  ","createdAt":"2026-10-24T09:00:00"},'
          '{"id":"gecerli","title":"Geçerli görev",'
          '"createdAt":"2026-10-24T09:00:00","isCompleted":false}]',
    });
    final preferences = await SharedPreferences.getInstance();
    final repository = TaskRepository(LocalStorageService(preferences));
    final loaded = repository.loadTasks();

    expect(loaded, hasLength(1));
    expect(loaded.single.id, 'gecerli');
  });
}
