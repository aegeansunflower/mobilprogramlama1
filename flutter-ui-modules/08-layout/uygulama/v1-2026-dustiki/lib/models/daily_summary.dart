import 'package:flutter/foundation.dart';
import 'task.dart';
import 'routine.dart';

@immutable
class DailySummary {
  final DateTime date;
  final int totalTasks;
  final int completedTasks;
  final int totalRoutines;
  final int completedRoutines;

  const DailySummary({
    required this.date,
    required this.totalTasks,
    required this.completedTasks,
    required this.totalRoutines,
    required this.completedRoutines,
  });

  int get totalItems => totalTasks + totalRoutines;
  int get completedItems => completedTasks + completedRoutines;

  double get completionPercentage {
    if (totalItems == 0) return 0.0;
    return (completedItems / totalItems).clamp(0.0, 1.0);
  }

  int get productivityScore => (completionPercentage * 100).round();

  factory DailySummary.calculate(
    DateTime date,
    List<TaskModel> allTasks,
    List<RoutineModel> allRoutines,
  ) {
    final dayTasks = allTasks.where((t) =>
        t.date.year == date.year &&
        t.date.month == date.month &&
        t.date.day == date.day).toList();

    final scheduledRoutines = allRoutines.where((r) => r.isScheduledForDay(date)).toList();

    final completedTasksCount = dayTasks.where((t) => t.isCompleted).length;
    final completedRoutinesCount = scheduledRoutines.where((r) => r.isCompletedOn(date)).length;

    return DailySummary(
      date: date,
      totalTasks: dayTasks.length,
      completedTasks: completedTasksCount,
      totalRoutines: scheduledRoutines.length,
      completedRoutines: completedRoutinesCount,
    );
  }
}
