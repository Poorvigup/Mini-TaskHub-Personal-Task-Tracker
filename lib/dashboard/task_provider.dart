import 'package:flutter/material.dart';
import 'package:mini_taskhub_personal_task_tracker/dashboard/task_model.dart';
import 'package:mini_taskhub_personal_task_tracker/services/supabase_service.dart';

enum TaskState { initial, loading, loaded, error }

class TaskProvider extends ChangeNotifier {
  final SupabaseService _supabaseService;

  TaskProvider(this._supabaseService);

  List<Task> _tasks = [];
  TaskState _state = TaskState.initial;
  String? _errorMessage;

  List<Task> get tasks => _tasks;
  TaskState get state => _state;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTasks() async {
     if (_state == TaskState.loading) return;
    _state = TaskState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _tasks = await _supabaseService.getTasks();
      _state = TaskState.loaded;
    } catch (e) {
      debugPrint("Error in TaskProvider fetchTasks: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      _state = TaskState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
      _errorMessage = null;
    try {
      final newTask = await _supabaseService.addTask(title);
      _tasks.insert(0, newTask);
      _state = TaskState.loaded;
      notifyListeners();
    } catch (e) {
       debugPrint("Error in TaskProvider addTask: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      notifyListeners();
      throw e;
    }
  }

  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
      _errorMessage = null;
     final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
     if (taskIndex == -1) return;
     final originalTask = _tasks[taskIndex];
     _tasks[taskIndex] = originalTask.copyWith(isCompleted: isCompleted);
     notifyListeners();
    try {
      await _supabaseService.updateTaskStatus(taskId, isCompleted);
    } catch (e) {
       debugPrint("Error in TaskProvider updateTaskStatus: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      _tasks[taskIndex] = originalTask;
      notifyListeners();
      throw e;
    }
  }

  Future<void> deleteTask(String taskId) async {
      _errorMessage = null;
     final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
     if (taskIndex == -1) return;
     final taskToRemove = _tasks[taskIndex];
     _tasks.removeAt(taskIndex);
     notifyListeners();
    try {
      await _supabaseService.deleteTask(taskId);
    } catch (e) {
      debugPrint("Error in TaskProvider deleteTask: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      _tasks.insert(taskIndex, taskToRemove);
      notifyListeners();
      throw e;
    }
  }

  Future<void> updateTaskTitle(String taskId, String newTitle) async {    // Debug Print: Entry point
    debugPrint('[TaskProvider] updateTaskTitle called. TaskID: $taskId, New Title: "$newTitle"');

    if (newTitle.trim().isEmpty) {
       _errorMessage = "Task title cannot be empty.";
       debugPrint('[TaskProvider] Validation failed: Title empty.');
       notifyListeners();
       throw Exception(_errorMessage);
    }
     _errorMessage = null;
     final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
     if (taskIndex == -1) {
       debugPrint('[TaskProvider] Task not found in local list for ID: $taskId');
       return; // Task not found
     }

     final originalTask = _tasks[taskIndex];
     debugPrint('[TaskProvider] Optimistically updating UI for Task ID: $taskId');
     _tasks[taskIndex] = originalTask.copyWith(title: newTitle.trim());
     notifyListeners();

    try {
      debugPrint('[TaskProvider] Calling _supabaseService.updateTaskTitle for Task ID: $taskId');
      await _supabaseService.updateTaskTitle(taskId, newTitle);
      debugPrint('[TaskProvider] _supabaseService.updateTaskTitle completed successfully for Task ID: $taskId');
    } catch (e) {
       debugPrint("[TaskProvider] Error calling SupabaseService: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
       debugPrint("[TaskProvider] Reverting optimistic update for Task ID: $taskId");
      _tasks[taskIndex] = originalTask;
      notifyListeners();
      throw e; 
    }
  }
}