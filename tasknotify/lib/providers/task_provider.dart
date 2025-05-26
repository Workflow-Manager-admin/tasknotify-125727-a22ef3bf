import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final SharedPreferences _prefs;
  static const String _tasksKey = 'tasks';

  TaskProvider(this._prefs) {
    _loadTasks();
  }

  List<Task> get tasks => _tasks;

  void _loadTasks() {
    final String? tasksJson = _prefs.getString(_tasksKey);
    if (tasksJson != null) {
      final List<dynamic> decoded = jsonDecode(tasksJson);
      _tasks = decoded.map((item) => Task.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveTasks() async {
    final String encoded = jsonEncode(_tasks.map((task) => task.toJson()).toList());
    await _prefs.setString(_tasksKey, encoded);
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await _saveTasks();
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      await _saveTasks();
      notifyListeners();
    }
  }
}
