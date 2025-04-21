import 'package:flutter/material.dart';
import 'package:mini_taskhub_personal_task_tracker/app/theme.dart';
import 'package:mini_taskhub_personal_task_tracker/app/theme_provider.dart';
import 'package:mini_taskhub_personal_task_tracker/auth/auth_service.dart';
import 'package:mini_taskhub_personal_task_tracker/dashboard/task_model.dart';
import 'package:mini_taskhub_personal_task_tracker/dashboard/task_provider.dart';
import 'package:mini_taskhub_personal_task_tracker/dashboard/task_tile.dart';
import 'package:mini_taskhub_personal_task_tracker/main.dart';
import 'package:mini_taskhub_personal_task_tracker/utils/validators.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  Future<void> _showAddTaskBottomSheet(BuildContext context) {
    final taskController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) { 
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20.0, right: 20.0, top: 20.0),
          child: Form( key: formKey, child: Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ Text('Create New Task', style: Theme.of(ctx).textTheme.titleLarge), IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx), tooltip: 'Close', iconSize: 24, color: Theme.of(ctx).hintColor)]),
                 const SizedBox(height: 20.0),
                 TextFormField(controller: taskController, decoration: const InputDecoration(hintText: 'Enter task title'), validator: Validators.validateTaskTitle, autovalidateMode: AutovalidateMode.onUserInteraction, textInputAction: TextInputAction.done, style: Theme.of(ctx).textTheme.bodyLarge, onFieldSubmitted: (_) => _submitAddTask(ctx, formKey, taskController, taskProvider, authService)),
                 const SizedBox(height: 25.0),
                 ElevatedButton(onPressed: () => _submitAddTask(ctx, formKey, taskController, taskProvider, authService), child: const Text('Create Task')),
                 const SizedBox(height: 20.0),
               ],
            ),),
        );
      },
    );
  }
  Future<void> _submitAddTask(BuildContext sheetContext, GlobalKey<FormState> formKey, TextEditingController controller, TaskProvider taskProvider, AuthService authService) async {
     if (formKey.currentState!.validate()) {
        final taskTitle = controller.text.trim();
        FocusScope.of(sheetContext).unfocus();
        try {
          await taskProvider.addTask(taskTitle);
          if (sheetContext.mounted) Navigator.pop(sheetContext);
           if (context.mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task "$taskTitle" added!'), backgroundColor: AppColors.successGreen)); }
        } catch (e) { if (sheetContext.mounted) { authService.showErrorSnackBar(sheetContext, 'Error adding task: $e'); } }
      }
  }


  // --- EDIT TASK BOTTOM SHEET (Using state's context) ---
  Future<void> _showEditTaskBottomSheet(Task task) { // No BuildContext parameter needed
    debugPrint('[DashboardScreen] _showEditTaskBottomSheet called for task: ${task.title} (ID: ${task.id})');

    final taskController = TextEditingController(text: task.title);
    final formKey = GlobalKey<FormState>();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    return showModalBottomSheet(
      context: context, // Use state's context
      isScrollControlled: true,
      builder: (BuildContext ctx) { // ctx is specific to bottom sheet builder
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20.0, right: 20.0, top: 20.0),
          child: Form(key: formKey, child: Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ Text('Edit Task', style: Theme.of(ctx).textTheme.titleLarge), IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx), tooltip: 'Close', iconSize: 24, color: Theme.of(ctx).hintColor)]),
                 const SizedBox(height: 20.0),
                 TextFormField(controller: taskController, decoration: const InputDecoration(hintText: 'Enter updated task title'), validator: Validators.validateTaskTitle, autovalidateMode: AutovalidateMode.onUserInteraction, textInputAction: TextInputAction.done, style: Theme.of(ctx).textTheme.bodyLarge, onFieldSubmitted: (_) => _submitEditTask(ctx, formKey, taskController, task.id, taskProvider, authService)),
                 const SizedBox(height: 25.0),
                 ElevatedButton(onPressed: () => _submitEditTask(ctx, formKey, taskController, task.id, taskProvider, authService), child: const Text('Update Task')),
                 const SizedBox(height: 20.0),
               ],
            ),),
        );
      },
    );
  }
  Future<void> _submitEditTask(BuildContext sheetContext, GlobalKey<FormState> formKey, TextEditingController controller, String taskId, TaskProvider taskProvider, AuthService authService) async {
     debugPrint('[DashboardScreen] _submitEditTask called for Task ID: $taskId');
     if (formKey.currentState!.validate()) {
        final newTitle = controller.text.trim();
        debugPrint('[DashboardScreen] Form valid. Attempting to update Task ID: $taskId to Title: "$newTitle"');
        FocusScope.of(sheetContext).unfocus();
        try {
          await taskProvider.updateTaskTitle(taskId, newTitle);
           debugPrint('[DashboardScreen] taskProvider.updateTaskTitle completed for Task ID: $taskId');
          if (sheetContext.mounted) Navigator.pop(sheetContext);
           if (context.mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task updated!'), backgroundColor: AppColors.successGreen)); }
        } catch (e) {
           debugPrint('[DashboardScreen] Error during task update: $e');
           if (sheetContext.mounted) { authService.showErrorSnackBar(sheetContext, 'Error updating task: $e'); }
        }
      } else {
         debugPrint('[DashboardScreen] Edit form is invalid.');
      }
  }


  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentUser = supabase.auth.currentUser;
    final userEmail = currentUser?.email ?? 'User';
    final userName = currentUser?.userMetadata?['full_name'] as String? ?? userEmail.split('@')[0];
    final userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : '?';
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [ Text('Welcome Back!', style: Theme.of(context).textTheme.bodySmall), Text(userName, style: Theme.of(context).textTheme.titleLarge?.copyWith(height: 1.2))]),
         actions: [
           IconButton( // Theme Toggle
             icon: Icon(isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_outlined),
             tooltip: isDarkMode ? 'Switch to Light Theme' : 'Switch to Dark Theme',
             onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
             color: Theme.of(context).appBarTheme.actionsIconTheme?.color, // Use theme color
           ),
           Padding( // Profile/Logout Menu
             padding: const EdgeInsets.only(right: 8.0),
             child: PopupMenuButton<String>(
                // Use theme for styling menu items
                onSelected: (value) async { if (value == 'logout') { try { await authService.signOut(); } catch (e) { if (context.mounted){ authService.showErrorSnackBar(context, e.toString()); } } } else if (value == 'profile') { ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Profile screen not implemented')), ); } },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[ PopupMenuItem<String>( value: 'profile', child: ListTile( leading: Icon(Icons.person_outline, color: Theme.of(context).listTileTheme.iconColor), title: Text('Profile', style: Theme.of(context).popupMenuTheme.textStyle))), const PopupMenuDivider(), PopupMenuItem<String>( value: 'logout', child: ListTile( leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error), title: Text('Logout', style: Theme.of(context).popupMenuTheme.textStyle?.copyWith(color: Theme.of(context).colorScheme.error))))],
                 child: CircleAvatar( backgroundColor: AppColors.primaryYellow, child: Text( userInitial, style: const TextStyle(color: AppColors.backgroundDark, fontWeight: FontWeight.bold, fontSize: 18))),
              ),
           ),
           const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => taskProvider.fetchTasks(),
         color: AppColors.primaryYellow,
        backgroundColor: Theme.of(context).cardColor,
        child: _buildTaskList(context, taskProvider),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskBottomSheet(context),
        tooltip: 'Add Task',
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, TaskProvider taskProvider) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: _buildContentBasedOnState(context, taskProvider)
    );
  }

  Widget _buildContentBasedOnState(BuildContext context, TaskProvider taskProvider) {
     final textTheme = Theme.of(context).textTheme;
     final hintColor = Theme.of(context).hintColor;

     switch (taskProvider.state) {
      case TaskState.initial: case TaskState.loading:
        return Center(key: const ValueKey('loading'), child: CircularProgressIndicator(color: AppColors.primaryYellow));
      case TaskState.error:
        return Container(key: const ValueKey('error'), alignment: Alignment.center, padding: const EdgeInsets.all(32.0), child: Column( mainAxisAlignment: MainAxisAlignment.center, children: [ Icon(Icons.cloud_off_rounded, color: hintColor, size: 60), const SizedBox(height: 16), Text('Failed to Load Tasks', style: textTheme.titleLarge, textAlign: TextAlign.center), const SizedBox(height: 8), Text(taskProvider.errorMessage ?? 'An error occurred. Pull down to retry.', style: textTheme.bodyMedium, textAlign: TextAlign.center)]));
      case TaskState.loaded:
        final tasks = taskProvider.tasks;
        if (tasks.isEmpty) {
          return Container(key: const ValueKey('empty'), alignment: Alignment.center, padding: const EdgeInsets.all(32.0), child: Column( mainAxisAlignment: MainAxisAlignment.center, children: [ Icon(Icons.check_circle_outline_rounded, size: 70, color: hintColor.withOpacity(0.6)), const SizedBox(height: 16), Text('All Tasks Done!', style: textTheme.headlineSmall), const SizedBox(height: 8), Text("Tap the '+' button to add a new task.", style: textTheme.bodyMedium, textAlign: TextAlign.center)]));
        } else {
          return ListView.builder(
            key: const ValueKey('taskList'),
            padding: const EdgeInsets.only(top: 10.0, bottom: 80.0), // Padding for FAB
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskTile(
                task: task,
                onEdit: _showEditTaskBottomSheet,
              );
            },
          );
        }
    }
  }
}