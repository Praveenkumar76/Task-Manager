import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/services/auth_service.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();

  DatabaseHelper._instance();

  String _getUserTasksKey() {
    final userId = AuthService().currentUser?.uid ?? 'guest';
    return 'tasks_$userId';
  }

  Future<List<Task>> getTaskList() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_getUserTasksKey()) ?? [];
    
    final List<Task> taskList = tasksJson.map((taskStr) {
      final Map<String, dynamic> taskMap = json.decode(taskStr);
      return Task.fromMap(taskMap);
    }).toList();
    
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }

  Future<int> insertTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getTaskList();
    
    // Generate a new ID
    int newId = 1;
    if (tasks.isNotEmpty) {
      newId = tasks.map((t) => t.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    }
    task.id = newId;
    
    tasks.add(task);
    await _saveTasks(tasks);
    return newId;
  }

  Future<int> updateTask(Task task) async {
    final tasks = await getTaskList();
    final index = tasks.indexWhere((t) => t.id == task.id);
    
    if (index != -1) {
      tasks[index] = task;
      await _saveTasks(tasks);
      return 1;
    }
    return 0;
  }

  Future<int> deleteTask(int id) async {
    final tasks = await getTaskList();
    final initialLength = tasks.length;
    tasks.removeWhere((task) => task.id == id);
    
    if (tasks.length < initialLength) {
      await _saveTasks(tasks);
      return 1;
    }
    return 0;
  }

  Future<int> deleteAllTask() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_getUserTasksKey());
    return 1;
  }

  Future<void> _saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => json.encode(task.toMap())).toList();
    await prefs.setStringList(_getUserTasksKey(), tasksJson);
  }
}
