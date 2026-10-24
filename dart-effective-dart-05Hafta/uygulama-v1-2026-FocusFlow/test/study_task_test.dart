import 'package:flutter_test/flutter_test.dart';

import 'package:focus_flow/models/study_task.dart';

void main() {
  group('StudyTask.doğrulama', () {
    test('boş ve yalnızca boşluk içeren başlığı reddeder', () {
      expect(StudyTask.validateTitle(null), isNotNull);
      expect(StudyTask.validateTitle(''), isNotNull);
      expect(StudyTask.validateTitle('   '), isNotNull);
    });

    test('geçerli başlığı kabul eder', () {
      expect(StudyTask.validateTitle('Lineer cebir tekrarı'), isNull);
    });

    test('sınırı aşan başlığı reddeder', () {
      final longTitle = 'a' * (StudyTask.maxTitleLength + 1);
      expect(StudyTask.validateTitle(longTitle), isNotNull);
    });
  });

  group('StudyTask JSON', () {
    final task = StudyTask(
      id: 'task_1',
      title: 'Fizik ödevi',
      category: 'Fizik',
      dueDate: DateTime(2026, 10, 25),
      createdAt: DateTime(2026, 10, 24, 9, 30),
      isCompleted: true,
      completedAt: DateTime(2026, 10, 24, 11),
    );

    test('serileştirme ve geri yükleme değerleri korur', () {
      final restored = StudyTask.fromJson(task.toJson());

      expect(restored.id, task.id);
      expect(restored.title, task.title);
      expect(restored.category, task.category);
      expect(restored.dueDate, task.dueDate);
      expect(restored.createdAt, task.createdAt);
      expect(restored.isCompleted, isTrue);
      expect(restored.completedAt, task.completedAt);
    });

    test('geçersiz başlıklı JSON kaydını reddeder', () {
      final json = task.toJson()..['title'] = '   ';
      expect(() => StudyTask.fromJson(json), throwsFormatException);
    });

    test('copyWith null ile isteğe bağlı alanları temizler', () {
      final cleared = task.copyWith(
        category: null,
        dueDate: null,
        completedAt: null,
      );

      expect(cleared.category, isNull);
      expect(cleared.dueDate, isNull);
      expect(cleared.completedAt, isNull);
      expect(cleared.title, task.title);
    });

    test('toggleCompletion zaman damgasını ekler ve temizler', () {
      final pending = task.copyWith(isCompleted: false, completedAt: null);
      final completed = pending.toggleCompletion(
        changedAt: DateTime(2026, 10, 24, 12),
      );
      expect(completed.isCompleted, isTrue);
      expect(completed.completedAt, DateTime(2026, 10, 24, 12));

      final reopened = completed.toggleCompletion();
      expect(reopened.isCompleted, isFalse);
      expect(reopened.completedAt, isNull);
    });
  });
}
