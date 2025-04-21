import 'package:mini_taskhub_personal_task_tracker/dashboard/task_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  String? get currentUserId => _client.auth.currentUser?.id;

  Future<List<Task>> getTasks() async {
    if (currentUserId == null) return [];
    try {
      final response = await _client
          .from('tasks')
          .select()
          .eq('user_id', currentUserId!)
          .order('created_at', ascending: false);
      final List<dynamic> data = response;
      return data.map((item) => Task.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      debugPrint('Error fetching tasks: ${e.message}');
      throw Exception('Failed to fetch tasks: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error fetching tasks: $e');
      throw Exception('An unexpected error occurred while fetching tasks.');
    }
  }

  Future<Task> addTask(String title) async {
    if (currentUserId == null) throw Exception("User not logged in");
    try {
      final response = await _client
          .from('tasks')
          .insert({'title': title, 'user_id': currentUserId!})
          .select()
          .single();
      return Task.fromJson(response);
    } on PostgrestException catch (e) {
       debugPrint('Error adding task: ${e.message}');
      throw Exception('Failed to add task: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error adding task: $e');
      throw Exception('An unexpected error occurred while adding the task.');
    }
  }

  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
    if (currentUserId == null) throw Exception("User not logged in");
    try {
      await _client
          .from('tasks')
          .update({'is_completed': isCompleted})
          .eq('id', taskId)
          .eq('user_id', currentUserId!);
    } on PostgrestException catch (e) {
       debugPrint('Error updating task status: ${e.message}');
      throw Exception('Failed to update task: ${e.message}');
    } catch (e) {
       debugPrint('Unexpected error updating task: $e');
      throw Exception('An unexpected error occurred while updating the task.');
    }
  }

  Future<void> deleteTask(String taskId) async {
    if (currentUserId == null) throw Exception("User not logged in");
    try {
       await _client
          .from('tasks')
          .delete()
          .eq('id', taskId)
          .eq('user_id', currentUserId!);
    } on PostgrestException catch (e) {
       debugPrint('Error deleting task: ${e.message}');
      throw Exception('Failed to delete task: ${e.message}');
    } catch (e) {
       debugPrint('Unexpected error deleting task: $e');
      throw Exception('An unexpected error occurred while deleting the task.');
    }
  }

  Future<void> updateTaskTitle(String taskId, String newTitle) async {
    debugPrint('[SupabaseService] updateTaskTitle called. TaskID: $taskId, New Title: "$newTitle", UserID: $currentUserId');

    if (currentUserId == null) throw Exception("User not logged in");
    if (newTitle.trim().isEmpty) throw Exception("Task title cannot be empty");

    try {
      debugPrint('[SupabaseService] Executing Supabase update query...');
      await _client
          .from('tasks')
          .update({'title': newTitle.trim()})
          .eq('id', taskId)
          .eq('user_id', currentUserId!);

      debugPrint('[SupabaseService] Supabase update query completed successfully.');

    } on PostgrestException catch (e) {
       debugPrint('[SupabaseService] PostgrestException during update: ${e.message} (Code: ${e.code})');
       throw Exception('Failed to update task title: ${e.message}');
    } catch (e) {
       debugPrint('[SupabaseService] Unexpected error during update: $e');
       throw Exception('An unexpected error occurred while updating the task title.');
    }
  }
}