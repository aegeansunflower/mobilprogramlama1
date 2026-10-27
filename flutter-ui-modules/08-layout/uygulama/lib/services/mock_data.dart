import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/routine.dart';

class MockData {
  static List<TaskModel> getInitialTasks() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return [
      TaskModel(
        id: 'task_1',
        title: 'Sabah Yürüyüşü ve Zihin Açma',
        description: 'Şarkışla temiz havasında zinde başlamak için kısa yürüyüş.',
        categoryId: 'mindful',
        date: today,
        startTime: const TimeOfDay(hour: 7, minute: 0),
        durationInMinutes: 20,
        priority: TaskPriority.high,
        isCompleted: true,
      ),
      TaskModel(
        id: 'task_2',
        title: 'Uygulamalı Bilimler YO Ders Tekrarı',
        description: 'Görsel programlama ve veritabanı dersi hazırlık çalışması.',
        categoryId: 'study',
        date: today,
        startTime: const TimeOfDay(hour: 9, minute: 30),
        durationInMinutes: 45,
        priority: TaskPriority.urgent,
        isCompleted: true,
        subtasks: [
          SubTask(id: 'sub_1', title: 'Kod örneklerini incele', isCompleted: true),
          SubTask(id: 'sub_2', title: 'Ödev sorularını çöz', isCompleted: true),
        ],
      ),
      TaskModel(
        id: 'task_3',
        title: 'Flutter Mobil Proje Geliştirme',
        description: 'Günlük planlayıcı uygulaması için veritabanı ve tema tasarımı.',
        categoryId: 'work',
        date: today,
        startTime: const TimeOfDay(hour: 10, minute: 30),
        durationInMinutes: 90,
        priority: TaskPriority.high,
        isCompleted: false,
        subtasks: [
          SubTask(id: 'sub_3', title: 'Veri modellerini düzenle', isCompleted: true),
          SubTask(id: 'sub_4', title: 'Türkçe dil desteğini ekle', isCompleted: false),
          SubTask(id: 'sub_5', title: 'Arayüz testlerini tamamla', isCompleted: false),
        ],
      ),
      TaskModel(
        id: 'task_4',
        title: 'Öğle Egzersizi & Vücut Geliştirme',
        description: '30 dakika ağırlık çalışması + esneme hareketleri.',
        categoryId: 'health',
        date: today,
        startTime: const TimeOfDay(hour: 13, minute: 0),
        durationInMinutes: 45,
        priority: TaskPriority.medium,
        isCompleted: false,
      ),
      TaskModel(
        id: 'task_5',
        title: 'Kitap Okuma & Yazılım Makalesi',
        description: 'Teknoloji trendleri ve modern Flutter mimarisi üzerine okuma.',
        categoryId: 'study',
        date: today,
        startTime: const TimeOfDay(hour: 17, minute: 0),
        durationInMinutes: 30,
        priority: TaskPriority.low,
        isCompleted: false,
      ),
      TaskModel(
        id: 'task_6',
        title: 'Haftalık Market & İhtiyaç Alışverişi',
        description: 'Sebze, meyve ve sağlıklı atıştırmalık alışverişi.',
        categoryId: 'household',
        date: tomorrow,
        startTime: const TimeOfDay(hour: 11, minute: 0),
        durationInMinutes: 60,
        priority: TaskPriority.medium,
        isCompleted: false,
      ),
    ];
  }

  static List<RoutineModel> getInitialRoutines() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    String dateKey(DateTime d) {
      final y = d.year.toString().padLeft(4, '0');
      final m = d.month.toString().padLeft(2, '0');
      final day = d.day.toString().padLeft(2, '0');
      return '$y-$m-$day';
    }

    return [
      RoutineModel(
        id: 'rt_1',
        title: 'Güne 500ml Su İle Başla',
        description: 'Metabolizmayı canlandırmak ve güne enerjik başlamak için.',
        section: RoutineSection.morning,
        targetTime: const TimeOfDay(hour: 6, minute: 30),
        daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
        categoryId: 'health',
        iconCodePoint: Icons.water_drop_outlined.codePoint,
        colorValue: Colors.blue.value,
        streak: 5,
        bestStreak: 12,
        completionHistory: {
          dateKey(yesterday): true,
          dateKey(today): true,
        },
      ),
      RoutineModel(
        id: 'rt_2',
        title: '10 Dakika Sabah Esneme Hareketi',
        description: 'Omurga ve kas sağlığı için sabah esnemesi.',
        section: RoutineSection.morning,
        targetTime: const TimeOfDay(hour: 7, minute: 0),
        daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
        categoryId: 'health',
        iconCodePoint: Icons.accessibility_new.codePoint,
        colorValue: Colors.teal.value,
        streak: 3,
        bestStreak: 8,
        completionHistory: {
          dateKey(yesterday): true,
          dateKey(today): false,
        },
      ),
      RoutineModel(
        id: 'rt_3',
        title: 'Ders Arası 15 Dakika Yürüyüş',
        description: 'Taze hava almak ve odağı tazelemek için kısa yürüyüş.',
        section: RoutineSection.afternoon,
        targetTime: const TimeOfDay(hour: 13, minute: 45),
        daysOfWeek: [1, 2, 3, 4, 5],
        categoryId: 'health',
        iconCodePoint: Icons.directions_walk.codePoint,
        colorValue: Colors.orange.value,
        streak: 2,
        bestStreak: 5,
        completionHistory: {
          dateKey(yesterday): true,
          dateKey(today): false,
        },
      ),
      RoutineModel(
        id: 'rt_4',
        title: 'Akşam Günlük Değerlendirme & Şükür',
        description: 'Günün öne çıkan 3 güzel olayını ve öğrenimini yaz.',
        section: RoutineSection.evening,
        targetTime: const TimeOfDay(hour: 20, minute: 30),
        daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
        categoryId: 'mindful',
        iconCodePoint: Icons.edit_note.codePoint,
        colorValue: Colors.indigo.value,
        streak: 7,
        bestStreak: 14,
        completionHistory: {
          dateKey(yesterday): true,
          dateKey(today): false,
        },
      ),
      RoutineModel(
        id: 'rt_5',
        title: 'Yatmadan 30 Dk Önce Ekranları Kapat',
        description: 'Kaliteli uyku için mavi ışığı kesip kitap okumak.',
        section: RoutineSection.night,
        targetTime: const TimeOfDay(hour: 22, minute: 30),
        daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
        categoryId: 'mindful',
        iconCodePoint: Icons.phonelink_off_outlined.codePoint,
        colorValue: Colors.deepPurple.value,
        streak: 4,
        bestStreak: 9,
        completionHistory: {
          dateKey(yesterday): true,
          dateKey(today): false,
        },
      ),
    ];
  }
}
