import 'package:flutter/material.dart';

enum RoutineSection { morning, afternoon, evening, night }

extension RoutineSectionExtension on RoutineSection {
  String get displayName {
    switch (this) {
      case RoutineSection.morning:
        return 'Sabah Rutini';
      case RoutineSection.afternoon:
        return 'Öğle Rutini';
      case RoutineSection.evening:
        return 'Akşam Rutini';
      case RoutineSection.night:
        return 'Gece Rutini';
    }
  }

  IconData get icon {
    switch (this) {
      case RoutineSection.morning:
        return Icons.wb_sunny_outlined;
      case RoutineSection.afternoon:
        return Icons.wb_twilight;
      case RoutineSection.evening:
        return Icons.nights_stay_outlined;
      case RoutineSection.night:
        return Icons.bedtime_outlined;
    }
  }

  Color get color {
    switch (this) {
      case RoutineSection.morning:
        return Colors.amber.shade700;
      case RoutineSection.afternoon:
        return Colors.orange.shade700;
      case RoutineSection.evening:
        return Colors.indigo.shade600;
      case RoutineSection.night:
        return Colors.deepPurple.shade700;
    }
  }
}

class RoutineModel {
  final String id;
  String title;
  String description;
  RoutineSection section;
  TimeOfDay targetTime;
  List<int> daysOfWeek; // 1 = Pzt, 7 = Paz
  String categoryId;
  int iconCodePoint;
  int colorValue;
  int streak;
  int bestStreak;
  Map<String, bool> completionHistory; // 'YYYY-MM-DD' -> true/false

  RoutineModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.section,
    required this.targetTime,
    required this.daysOfWeek,
    required this.categoryId,
    int? iconCodePoint,
    int? colorValue,
    this.streak = 0,
    this.bestStreak = 0,
    Map<String, bool>? completionHistory,
  })  : iconCodePoint = iconCodePoint ?? Icons.check_circle_outline.codePoint,
        colorValue = colorValue ?? Colors.teal.value,
        completionHistory = completionHistory ?? {};

  String dateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  bool isCompletedOn(DateTime date) {
    final key = dateKey(date);
    return completionHistory[key] ?? false;
  }

  bool isScheduledForDay(DateTime date) {
    return daysOfWeek.contains(date.weekday);
  }

  void toggleCompletion(DateTime date) {
    final key = dateKey(date);
    final isCurrentlyDone = isCompletedOn(date);
    if (isCurrentlyDone) {
      completionHistory[key] = false;
      if (streak > 0) streak--;
    } else {
      completionHistory[key] = true;
      streak++;
      if (streak > bestStreak) {
        bestStreak = streak;
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'section': section.index,
      'targetHour': targetTime.hour,
      'targetMinute': targetTime.minute,
      'daysOfWeek': daysOfWeek,
      'categoryId': categoryId,
      'iconCodePoint': iconCodePoint,
      'colorValue': colorValue,
      'streak': streak,
      'bestStreak': bestStreak,
      'completionHistory': completionHistory,
    };
  }

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    return RoutineModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      section: RoutineSection.values[json['section'] as int? ?? 0],
      targetTime: TimeOfDay(
        hour: json['targetHour'] as int? ?? 8,
        minute: json['targetMinute'] as int? ?? 0,
      ),
      daysOfWeek: (json['daysOfWeek'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [1, 2, 3, 4, 5, 6, 7],
      categoryId: json['categoryId'] as String? ?? 'personal',
      iconCodePoint: json['iconCodePoint'] as int? ?? Icons.star_outline.codePoint,
      colorValue: json['colorValue'] as int? ?? Colors.teal.value,
      streak: json['streak'] as int? ?? 0,
      bestStreak: json['bestStreak'] as int? ?? 0,
      completionHistory: (json['completionHistory'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as bool),
          ) ??
          {},
    );
  }
}
