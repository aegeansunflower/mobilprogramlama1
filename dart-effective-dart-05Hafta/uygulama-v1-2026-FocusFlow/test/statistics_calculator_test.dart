import 'package:flutter_test/flutter_test.dart';

import 'package:focus_flow/features/statistics/statistics_calculator.dart';
import 'package:focus_flow/models/focus_session.dart';
import 'package:focus_flow/models/study_task.dart';

void main() {
  final now = DateTime(2026, 10, 24, 15, 30);

  FocusSession session({
    required String id,
    required SessionType type,
    required DateTime completedAt,
    required int seconds,
    bool isCompleted = true,
  }) {
    return FocusSession(
      id: id,
      type: type,
      plannedDurationSeconds: seconds,
      actualDurationSeconds: seconds,
      startedAt: completedAt.subtract(Duration(seconds: seconds)),
      completedAt: completedAt,
      isCompleted: isCompleted,
    );
  }

  final sessions = <FocusSession>[
    session(
      id: 'today_focus',
      type: SessionType.focus,
      completedAt: DateTime(2026, 10, 24, 14),
      seconds: 1500,
    ),
    session(
      id: 'yesterday_focus',
      type: SessionType.focus,
      completedAt: DateTime(2026, 10, 23, 18),
      seconds: 600,
    ),
    session(
      id: 'today_break',
      type: SessionType.shortBreak,
      completedAt: DateTime(2026, 10, 24, 14, 30),
      seconds: 300,
    ),
    session(
      id: 'unfinished_focus',
      type: SessionType.focus,
      completedAt: DateTime(2026, 10, 24, 12),
      seconds: 300,
      isCompleted: false,
    ),
    session(
      id: 'old_focus',
      type: SessionType.focus,
      completedAt: DateTime(2026, 10, 16, 10),
      seconds: 1200,
    ),
  ];

  group('odak istatistikleri', () {
    test('yalnızca tamamlanmış odak oturumlarını toplar', () {
      expect(StatisticsCalculator.totalFocusSeconds(sessions), 3300);
      expect(StatisticsCalculator.totalCompletedFocusSessionCount(sessions), 3);
    });

    test('bugünkü odak süresini ve oturum sayısını hesaplar', () {
      expect(StatisticsCalculator.todayFocusSeconds(sessions, now: now), 1500);
      expect(
        StatisticsCalculator.todayFocusSessionCount(sessions, now: now),
        1,
      );
    });

    test('son yedi günü eskiden yeniye döndürür', () {
      final week = StatisticsCalculator.lastSevenDays(sessions, now: now);

      expect(week, hasLength(7));
      expect(week.last.date, DateTime(2026, 10, 24));
      expect(week.last.seconds, 1500);
      expect(week[5].date, DateTime(2026, 10, 23));
      expect(week[5].seconds, 600);
      expect(
        StatisticsCalculator.lastSevenDaysFocusSeconds(sessions, now: now),
        2100,
      );
    });
  });

  group('görev istatistikleri', () {
    final tasks = <StudyTask>[
      StudyTask(
        id: 'task_1',
        title: 'Bugün tamamlanan',
        createdAt: DateTime(2026, 10, 23),
        isCompleted: true,
        completedAt: DateTime(2026, 10, 24, 10),
      ),
      StudyTask(
        id: 'task_2',
        title: 'Dün tamamlanan',
        createdAt: DateTime(2026, 10, 22),
        isCompleted: true,
        completedAt: DateTime(2026, 10, 23, 10),
      ),
      StudyTask(
        id: 'task_3',
        title: 'Bekleyen',
        createdAt: DateTime(2026, 10, 24),
      ),
    ];

    test('bugün tamamlanan görev sayısını hesaplar', () {
      expect(StatisticsCalculator.todayCompletedTaskCount(tasks, now: now), 1);
    });

    test('bekleyen ve tamamlanan görev sayılarını hesaplar', () {
      expect(StatisticsCalculator.pendingTaskCount(tasks), 1);
      expect(StatisticsCalculator.totalCompletedTaskCount(tasks), 2);
    });
  });
}
