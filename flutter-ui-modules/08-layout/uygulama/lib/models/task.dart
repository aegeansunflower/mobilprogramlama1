import 'package:flutter/material.dart';

enum TaskPriority { low, medium, high, urgent }

extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Düşük';
      case TaskPriority.medium:
        return 'Orta';
      case TaskPriority.high:
        return 'Yüksek';
      case TaskPriority.urgent:
        return 'Acil';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return Colors.blue;
      case TaskPriority.medium:
        return Colors.green;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.urgent:
        return Colors.red;
    }
  }
}

class SubTask {
  String id;
  String title;
  bool isCompleted;

  SubTask({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

class TaskModel {
  final String id;
  String title;
  String description;
  String categoryId;
  DateTime date;
  TimeOfDay startTime;
  int durationInMinutes;
  TaskPriority priority;
  bool isCompleted;
  bool isSkipped;
  List<SubTask> subtasks;

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.categoryId,
    required this.date,
    required this.startTime,
    this.durationInMinutes = 30,
    this.priority = TaskPriority.medium,
    this.isCompleted = false,
    this.isSkipped = false,
    List<SubTask>? subtasks,
  }) : subtasks = subtasks ?? [];

  DateTime get startDateTime => DateTime(
        date.year,
        date.month,
        date.day,
        startTime.hour,
        startTime.minute,
      );

  DateTime get endDateTime => startDateTime.add(Duration(minutes: durationInMinutes));

  double get subtasksProgress {
    if (subtasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    final completedCount = subtasks.where((s) => s.isCompleted).length;
    return completedCount / subtasks.length;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'date': date.toIso8601String(),
      'startHour': startTime.hour,
      'startMinute': startTime.minute,
      'durationInMinutes': durationInMinutes,
      'priority': priority.index,
      'isCompleted': isCompleted,
      'isSkipped': isSkipped,
      'subtasks': subtasks.map((s) => s.toJson()).toList(),
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      categoryId: json['categoryId'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: TimeOfDay(
        hour: json['startHour'] as int? ?? 9,
        minute: json['startMinute'] as int? ?? 0,
      ),
      durationInMinutes: json['durationInMinutes'] as int? ?? 30,
      priority: TaskPriority.values[json['priority'] as int? ?? 1],
      isCompleted: json['isCompleted'] as bool? ?? false,
      isSkipped: json['isSkipped'] as bool? ?? false,
      subtasks: (json['subtasks'] as List<dynamic>?)
              ?.map((s) => SubTask.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? categoryId,
    DateTime? date,
    TimeOfDay? startTime,
    int? durationInMinutes,
    TaskPriority? priority,
    bool? isCompleted,
    bool? isSkipped,
    List<SubTask>? subtasks,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      durationInMinutes: durationInMinutes ?? this.durationInMinutes,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      isSkipped: isSkipped ?? this.isSkipped,
      subtasks: subtasks ?? this.subtasks.map((s) => SubTask(id: s.id, title: s.title, isCompleted: s.isCompleted)).toList(),
    );
  }
}
