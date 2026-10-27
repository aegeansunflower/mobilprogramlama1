import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../models/routine.dart';
import 'mock_data.dart';

class StorageService {
  static const String _tasksKey = 'dayplanner_tasks_v1';
  static const String _routinesKey = 'dayplanner_routines_v1';
  static const String _isDarkModeKey = 'dayplanner_is_dark_mode';
  static const String _userNameKey = 'dayplanner_user_name';
  static const String _userAgeKey = 'dayplanner_user_age';
  static const String _userLocationKey = 'dayplanner_user_location';
  static const String _userUniversityKey = 'dayplanner_user_university';
  static const String _seedColorKey = 'dayplanner_seed_color';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<List<TaskModel>> loadTasks() async {
    await init();
    final jsonString = _prefs?.getString(_tasksKey);
    if (jsonString == null || jsonString.isEmpty) {
      final initialTasks = MockData.getInitialTasks();
      await saveTasks(initialTasks);
      return initialTasks;
    }
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((item) => TaskModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      return MockData.getInitialTasks();
    }
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    await init();
    final encoded = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await _prefs?.setString(_tasksKey, encoded);
  }

  Future<List<RoutineModel>> loadRoutines() async {
    await init();
    final jsonString = _prefs?.getString(_routinesKey);
    if (jsonString == null || jsonString.isEmpty) {
      final initialRoutines = MockData.getInitialRoutines();
      await saveRoutines(initialRoutines);
      return initialRoutines;
    }
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((item) => RoutineModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      return MockData.getInitialRoutines();
    }
  }

  Future<void> saveRoutines(List<RoutineModel> routines) async {
    await init();
    final encoded = jsonEncode(routines.map((r) => r.toJson()).toList());
    await _prefs?.setString(_routinesKey, encoded);
  }

  Future<bool> loadIsDarkMode() async {
    await init();
    return _prefs?.getBool(_isDarkModeKey) ?? false;
  }

  Future<void> saveIsDarkMode(bool value) async {
    await init();
    await _prefs?.setBool(_isDarkModeKey, value);
  }

  Future<String> loadUserName() async {
    await init();
    return _prefs?.getString(_userNameKey) ?? 'Ege';
  }

  Future<void> saveUserName(String name) async {
    await init();
    await _prefs?.setString(_userNameKey, name);
  }

  Future<int> loadUserAge() async {
    await init();
    return _prefs?.getInt(_userAgeKey) ?? 19;
  }

  Future<void> saveUserAge(int age) async {
    await init();
    await _prefs?.setInt(_userAgeKey, age);
  }

  Future<String> loadUserLocation() async {
    await init();
    return _prefs?.getString(_userLocationKey) ?? 'Sivas, Şarkışla';
  }

  Future<void> saveUserLocation(String location) async {
    await init();
    await _prefs?.setString(_userLocationKey, location);
  }

  Future<String> loadUserUniversity() async {
    await init();
    return _prefs?.getString(_userUniversityKey) ?? 'Uygulamalı bilimler YO';
  }

  Future<void> saveUserUniversity(String university) async {
    await init();
    await _prefs?.setString(_userUniversityKey, university);
  }

  Future<int> loadSeedColorValue() async {
    await init();
    return _prefs?.getInt(_seedColorKey) ?? 0xFF6750A4;
  }

  Future<void> saveSeedColorValue(int colorValue) async {
    await init();
    await _prefs?.setInt(_seedColorKey, colorValue);
  }

  Future<void> clearAllData() async {
    await init();
    await _prefs?.remove(_tasksKey);
    await _prefs?.remove(_routinesKey);
  }
}
