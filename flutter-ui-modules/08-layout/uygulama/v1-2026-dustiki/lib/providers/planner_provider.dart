import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/routine.dart';
import '../models/daily_summary.dart';
import '../services/storage_service.dart';

class PlannerProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  DateTime _selectedDate = DateTime.now();
  List<TaskModel> _tasks = [];
  List<RoutineModel> _routines = [];

  bool _isLoading = true;
  bool _isDarkMode = false;
  String _userName = 'Ege';
  int _userAge = 19;
  String _userLocation = 'Sivas, Şarkışla';
  String _userUniversity = 'Uygulamalı bilimler YO';
  Color _seedColor = const Color(0xFF6750A4);

  // Search & Filter state
  String _searchQuery = '';
  String? _selectedCategoryId;
  TaskPriority? _selectedPriority;
  bool? _filterCompletedStatus;

  // Getters
  DateTime get selectedDate => _selectedDate;
  List<TaskModel> get allTasks => _tasks;
  List<RoutineModel> get allRoutines => _routines;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;
  String get userName => _userName;
  int get userAge => _userAge;
  String get userLocation => _userLocation;
  String get userUniversity => _userUniversity;
  Color get seedColor => _seedColor;

  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;
  TaskPriority? get selectedPriority => _selectedPriority;
  bool? get filterCompletedStatus => _filterCompletedStatus;

  PlannerProvider() {
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _storageService.loadTasks();
    _routines = await _storageService.loadRoutines();
    _isDarkMode = await _storageService.loadIsDarkMode();
    _userName = await _storageService.loadUserName();
    _userAge = await _storageService.loadUserAge();
    _userLocation = await _storageService.loadUserLocation();
    _userUniversity = await _storageService.loadUserUniversity();
    final seedVal = await _storageService.loadSeedColorValue();
    _seedColor = Color(seedVal);

    _isLoading = false;
    notifyListeners();
  }

  // Date selection
  void setSelectedDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  // Filters & Search
  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void setCategoryFilter(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setPriorityFilter(TaskPriority? priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  void setCompletedStatusFilter(bool? completed) {
    _filterCompletedStatus = completed;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategoryId = null;
    _selectedPriority = null;
    _filterCompletedStatus = null;
    notifyListeners();
  }

  // Task Queries
  List<TaskModel> get tasksForSelectedDate {
    return _tasks.where((t) {
      final isSameDay = t.date.year == _selectedDate.year &&
          t.date.month == _selectedDate.month &&
          t.date.day == _selectedDate.day;
      if (!isSameDay) return false;

      if (_selectedCategoryId != null && t.categoryId != _selectedCategoryId) {
        return false;
      }
      if (_selectedPriority != null && t.priority != _selectedPriority) {
        return false;
      }
      if (_searchQuery.isNotEmpty &&
          !t.title.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !t.description.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      if (_filterCompletedStatus != null && t.isCompleted != _filterCompletedStatus) {
        return false;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        final minutesA = a.startTime.hour * 60 + a.startTime.minute;
        final minutesB = b.startTime.hour * 60 + b.startTime.minute;
        return minutesA.compareTo(minutesB);
      });
  }

  List<TaskModel> get filteredAllTasks {
    return _tasks.where((t) {
      if (_selectedCategoryId != null && t.categoryId != _selectedCategoryId) {
        return false;
      }
      if (_selectedPriority != null && t.priority != _selectedPriority) {
        return false;
      }
      if (_searchQuery.isNotEmpty &&
          !t.title.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !t.description.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      if (_filterCompletedStatus != null && t.isCompleted != _filterCompletedStatus) {
        return false;
      }
      return true;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Routine Queries
  List<RoutineModel> get routinesForSelectedDate {
    return _routines.where((r) => r.isScheduledForDay(_selectedDate)).toList();
  }

  DailySummary get selectedDateSummary {
    return DailySummary.calculate(_selectedDate, _tasks, _routines);
  }

  // Task Actions
  Future<void> addTask(TaskModel task) async {
    _tasks.add(task);
    await _storageService.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> updateTask(TaskModel updatedTask) async {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      await _storageService.saveTasks(_tasks);
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((t) => t.id == taskId);
    await _storageService.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      task.isCompleted = !task.isCompleted;
      if (task.isCompleted && task.subtasks.isNotEmpty) {
        for (var st in task.subtasks) {
          st.isCompleted = true;
        }
      }
      await _storageService.saveTasks(_tasks);
      notifyListeners();
    }
  }

  Future<void> toggleSubTaskCompletion(String taskId, String subTaskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      final stIndex = task.subtasks.indexWhere((st) => st.id == subTaskId);
      if (stIndex != -1) {
        task.subtasks[stIndex].isCompleted = !task.subtasks[stIndex].isCompleted;
        final allDone = task.subtasks.every((st) => st.isCompleted);
        task.isCompleted = allDone;
        await _storageService.saveTasks(_tasks);
        notifyListeners();
      }
    }
  }

  // Routine Actions
  Future<void> addRoutine(RoutineModel routine) async {
    _routines.add(routine);
    await _storageService.saveRoutines(_routines);
    notifyListeners();
  }

  Future<void> updateRoutine(RoutineModel updatedRoutine) async {
    final index = _routines.indexWhere((r) => r.id == updatedRoutine.id);
    if (index != -1) {
      _routines[index] = updatedRoutine;
      await _storageService.saveRoutines(_routines);
      notifyListeners();
    }
  }

  Future<void> deleteRoutine(String routineId) async {
    _routines.removeWhere((r) => r.id == routineId);
    await _storageService.saveRoutines(_routines);
    notifyListeners();
  }

  Future<void> toggleRoutineCompletion(String routineId, DateTime date) async {
    final index = _routines.indexWhere((r) => r.id == routineId);
    if (index != -1) {
      _routines[index].toggleCompletion(date);
      await _storageService.saveRoutines(_routines);
      notifyListeners();
    }
  }

  // Settings & Profile Actions
  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    await _storageService.saveIsDarkMode(value);
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    int? age,
    String? location,
    String? university,
  }) async {
    if (name != null) {
      _userName = name;
      await _storageService.saveUserName(name);
    }
    if (age != null) {
      _userAge = age;
      await _storageService.saveUserAge(age);
    }
    if (location != null) {
      _userLocation = location;
      await _storageService.saveUserLocation(location);
    }
    if (university != null) {
      _userUniversity = university;
      await _storageService.saveUserUniversity(university);
    }
    notifyListeners();
  }

  Future<void> setSeedColor(Color color) async {
    _seedColor = color;
    await _storageService.saveSeedColorValue(color.value);
    notifyListeners();
  }

  Future<void> resetToSampleData() async {
    await _storageService.clearAllData();
    await _loadAllData();
  }
}
