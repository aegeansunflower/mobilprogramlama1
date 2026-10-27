/// Antrenman Veri Depolama Servisi
/// Set geçmişini, toplam hacimleri ve günlük özetleri yönetir.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';
import '../models/workout_set.dart';

class WorkoutStorageService {
  static const String _storageKey = 'ppl_workout_sets_v1';
  final List<WorkoutSet> _sets = [];
  bool _isInitialized = false;

  List<WorkoutSet> get sets => List.unmodifiable(_sets);

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? dataString = prefs.getString(_storageKey);
      if (dataString != null) {
        final List<dynamic> decoded = jsonDecode(dataString);
        _sets.clear();
        for (final item in decoded) {
          _sets.add(WorkoutSet.fromJson(item as Map<String, dynamic>));
        }
      }
    } catch (e) {
      // SharedPreferences hatası durumunda varsayılan boş liste ile devam edilir
    }
    _isInitialized = true;
  }

  Future<void> addSet(WorkoutSet set) async {
    _sets.insert(0, set); // En yeni en başta
    await _save();
  }

  Future<void> removeSet(String id) async {
    _sets.removeWhere((item) => item.id == id);
    await _save();
  }

  Future<void> clearAll() async {
    _sets.clear();
    await _save();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_sets.map((s) => s.toJson()).toList());
      await prefs.setString(_storageKey, encoded);
    } catch (_) {}
  }

  /// Toplam Genel Hacim (kg) (double)
  double get totalOverallVolume {
    double sum = 0.0;
    for (final s in _sets) {
      sum += s.totalVolume;
    }
    return sum;
  }

  /// Kategoriye göre toplam hacim (Push, Pull, Legs) (double)
  double getVolumeForCategory(WorkoutCategory category) {
    double sum = 0.0;
    for (final s in _sets) {
      if (s.exercise.category == category) {
        sum += s.totalVolume;
      }
    }
    return sum;
  }

  /// Kategoriye göre set sayısı (int)
  int getSetCountForCategory(WorkoutCategory category) {
    int count = 0;
    for (final s in _sets) {
      if (s.exercise.category == category) {
        count += s.sets;
      }
    }
    return count;
  }

  /// Tükenişe gidilen setlerin toplamı (int)
  int get failureSetsCount {
    int count = 0;
    for (final s in _sets) {
      if (s.reachedFailure) {
        count++;
      }
    }
    return count;
  }
}
