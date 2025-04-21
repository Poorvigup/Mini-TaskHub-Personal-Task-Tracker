import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Keep for potential future date use
import 'package:mini_taskhub_personal_task_tracker/app/theme.dart';
import 'package:mini_taskhub_personal_task_tracker/auth/auth_service.dart';
import 'package:mini_taskhub_personal_task_tracker/dashboard/task_model.dart';
import 'package:mini_taskhub_personal_task_tracker/dashboard/task_provider.dart';
import 'package:provider/provider.dart';

// Define the callback function signature for editing
typedef EditTaskCallback = void Function(Task taskToEdit);

// Enum for Popup Menu Actions
enum TaskAction { edit, delete }

class TaskTile extends StatelessWidget {
  final Task task;
  final EditTaskCallback onEdit; // Callback function parameter for editing

  const TaskTile({
    super.key,
    required this.task,
    required this.onEdit, // Make it required
  });

  // Helper to show delete confirmation dialog
  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dialogTheme = Theme.of(context).dialogTheme;
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Use theme styles
          shape: dialogTheme.shape,
          backgroundColor: dialogTheme.backgroundColor,
          title: Text('Delete Task?', style: dialogTheme.titleTextStyle ?? textTheme.titleLarge),
          content: Text(
            'Are you sure you want to delete this task "${task.title}"? This action cannot be undone.',
            style: dialogTheme.contentTextStyle ?? textTheme.bodyMedium,
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).hintColor.withOpacity(0.8)), // Use theme hint color
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error), // Use theme error color
            ),
          ],
        );
      },
    );
  }

  // Helper function to handle the actual deletion after confirmation via PopupMenu
  Future<void> _handleDelete(BuildContext context) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    // Get ScaffoldMessenger before async gap to avoid context issues
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Show confirmation dialog
    final bool? confirmed = await _showDeleteConfirmationDialog(context);

    // Proceed only if user confirmed
    if (confirmed == true) {
      try {
        await taskProvider.deleteTask(task.id);
        // Check mount status implicitly via scaffoldMessenger
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Task "${task.title}" deleted'),
            backgroundColor: AppColors.successGreen, // Use specific success color
          ),
        );
      } catch (e) {
        // Use authService helper for themed error snackbar
        // Check mount status implicitly
        authService.showErrorSnackBar(context, 'Failed to delete task: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // Get providers needed, listen: false as actions don't need rebuild here
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    // Get theme elements
    final textTheme = Theme.of(context).textTheme;
    final hintColor = Theme.of(context).hintColor;
    final iconColor = Theme.of(context).listTileTheme.iconColor ?? AppColors.iconGrey;
    final errorColor = Theme.of(context).colorScheme.error;
    final cardColor = Theme.of(context).cardTheme.color ?? AppColors.cardDark;
    final popupMenuTextStyle = Theme.of(context).popupMenuTheme.textStyle ?? textTheme.bodyMedium;

    // Determine status text and progress value
    final String statusText = task.isCompleted ? "Completed" : "Pending";
    final double progressValue = task.isCompleted ? 1.0 : 0.0; // Simple 0 or 100%
    final Color statusColor = task.isCompleted ? AppColors.successGreen : hintColor.withOpacity(0.9);
    final Color progressIndicatorColor = task.isCompleted ? AppColors.successGreen : AppColors.primaryYellow;


    return Dismissible(
      key: Key(task.id), // Unique key for dismissible
      direction: DismissDirection.endToStart, // Allow swipe delete
      background: Container( // Background shown during swipe
         decoration: BoxDecoration(
           color: errorColor.withOpacity(0.9),
           borderRadius: BorderRadius.circular(16) // Match card shape
         ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0), // Match card margin
        child: const Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(Icons.delete_sweep_outlined, color: Colors.white, size: 28),
             SizedBox(height: 4),
             Text('Delete', style: TextStyle(color: Colors.white, fontSize: 12)),
           ],
        ),
      ),
      // Confirm swipe delete action
       confirmDismiss: (direction) => _showDeleteConfirmationDialog(context),
      // Handle deletion after swipe confirmation
      onDismissed: (direction) async {
        try {
          await taskProvider.deleteTask(task.id);
          // Show snackbar on success (check mount status implicitly)
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task "${task.title}" deleted'), backgroundColor: AppColors.successGreen));
        } catch (e) {
           if (context.mounted){ authService.showErrorSnackBar(context, 'Failed to delete task: $e'); }
        }
       },
      child: Card( // Uses CardTheme from AppTheme
        // Card contains a Column to stack ListTile and Progress/Status row
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile( // Uses ListTileTheme from AppTheme
              leading: Checkbox( // Uses CheckboxTheme from AppTheme
                value: task.isCompleted,
                onChanged: (bool? newValue) async {
                  if (newValue != null) {
                    try {
                      await taskProvider.updateTaskStatus(task.id, newValue);
                    } catch (e) {
                      if (context.mounted){
                        authService.showErrorSnackBar(context, 'Failed to update task: $e');
                      }
                    }
                  }
                },
              ),
              title: Text(
                task.title,
                style: task.isCompleted
                    ? textTheme.titleMedium?.copyWith(decoration: TextDecoration.lineThrough, color: hintColor, fontWeight: FontWeight.normal) // Use theme hint color
                    : textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Popup Menu for Edit/Delete actions
              trailing: PopupMenuButton<TaskAction>( // Uses PopupMenuTheme from AppTheme
                icon: Icon(Icons.more_vert, color: iconColor.withOpacity(0.7)),
                tooltip: "Task Options",
                onSelected: (TaskAction action) {
                  switch (action) {
                    case TaskAction.edit:
                      debugPrint('[TaskTile] Edit action selected for task ID: ${task.id}');
                      onEdit(task); // Call the edit callback
                      break;
                    case TaskAction.delete:
                      debugPrint('[TaskTile] Delete action selected for task ID: ${task.id}');
                      _handleDelete(context); // Call delete helper (includes confirmation)
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<TaskAction>>[
                  PopupMenuItem<TaskAction>(
                    value: TaskAction.edit,
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined, size: 20, color: iconColor),
                      title: Text('Edit', style: popupMenuTextStyle),
                      contentPadding: EdgeInsets.zero, dense: true,
                    ),
                  ),
                  PopupMenuItem<TaskAction>(
                    value: TaskAction.delete,
                    child: ListTile(
                      leading: Icon(Icons.delete_outline, size: 20, color: errorColor),
                      title: Text('Delete', style: popupMenuTextStyle?.copyWith(color: errorColor)),
                      contentPadding: EdgeInsets.zero, dense: true,
                    ),
                  ),
                ],
              ),
              // Adjust padding to fit content better
              contentPadding: const EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 0),
              visualDensity: VisualDensity.compact,
            ),

            // Status Text and Progress Bar Section
            Padding(
              padding: const EdgeInsets.only(left: 58.0, right: 16.0, bottom: 12.0, top: 4), // Align with title, adjust vertical padding
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically
                children: [
                  // Status Text
                  Text(
                    statusText,
                    style: textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 10), // Spacer

                  // Progress Bar (takes remaining space)
                  Expanded(
                    child: SizedBox(
                      height: 6, // Bar height
                      child: ClipRRect( // Rounded corners for the bar
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: progressValue, // 0.0 for pending, 1.0 for completed
                          backgroundColor: cardColor.withOpacity(0.3), // Subtle background track
                          valueColor: AlwaysStoppedAnimation<Color>(progressIndicatorColor), // Yellow or Green
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}