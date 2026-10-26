import 'package:flutter_test/flutter_test.dart';

import 'package:focus_flow/features/focus/focus_timer_controller.dart';
import 'package:focus_flow/models/app_settings.dart';
import 'package:focus_flow/models/focus_session.dart';

void main() {
  test('sayaç hedef zamana göre tamamlanır ve oturumu bir kez kaydeder', () {
    var now = DateTime(2026, 10, 24, 10);
    final completedSessions = <FocusSession>[];
    final timer = FocusTimerController(
      settings: const AppSettings(
        focusDurationMinutes: 5,
        shortBreakMinutes: 5,
        longBreakMinutes: 15,
      ),
      clock: () => now,
      onSessionCompleted: completedSessions.add,
    );
    addTearDown(timer.dispose);

    expect(timer.status, FocusTimerStatus.idle);
    expect(timer.remainingSeconds, 300);

    timer.start();
    expect(timer.status, FocusTimerStatus.running);

    now = now.add(const Duration(minutes: 2));
    timer.syncNow();
    expect(timer.remainingSeconds, 180);

    timer.pause();
    expect(timer.status, FocusTimerStatus.paused);
    expect(timer.remainingSeconds, 180);

    now = now.add(const Duration(minutes: 20));
    timer.syncNow();
    expect(timer.remainingSeconds, 180);

    timer.resume();
    expect(timer.status, FocusTimerStatus.running);

    now = now.add(const Duration(minutes: 3));
    timer.syncNow();
    expect(timer.status, FocusTimerStatus.completed);
    expect(timer.remainingSeconds, 0);
    expect(completedSessions, hasLength(1));

    final session = completedSessions.single;
    expect(session.type, SessionType.focus);
    expect(session.plannedDurationSeconds, 300);
    expect(session.actualDurationSeconds, 300);
    expect(session.isCompleted, isTrue);

    timer.syncNow();
    expect(completedSessions, hasLength(1));
  });

  test('mod değişikliği süreyi ayarlardan alır', () {
    final timer = FocusTimerController(
      settings: const AppSettings(
        focusDurationMinutes: 25,
        shortBreakMinutes: 5,
        longBreakMinutes: 15,
      ),
      onSessionCompleted: (_) {},
    );
    addTearDown(timer.dispose);

    timer.selectType(SessionType.shortBreak);
    expect(timer.type, SessionType.shortBreak);
    expect(timer.status, FocusTimerStatus.idle);
    expect(timer.totalSeconds, 300);
    expect(timer.remainingSeconds, 300);

    timer.selectType(SessionType.longBreak);
    expect(timer.totalSeconds, 900);
  });

  test('ayar değişikliği yalnızca boştaki sayaca uygulanır', () {
    final timer = FocusTimerController(
      settings: const AppSettings(focusDurationMinutes: 25),
      onSessionCompleted: (_) {},
    );
    addTearDown(timer.dispose);

    timer.applySettings(const AppSettings(focusDurationMinutes: 40));
    expect(timer.totalSeconds, 2400);

    timer.start();
    timer.applySettings(const AppSettings(focusDurationMinutes: 50));
    expect(timer.totalSeconds, 2400);
  });
}
