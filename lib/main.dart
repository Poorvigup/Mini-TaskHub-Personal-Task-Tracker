import 'package:flutter/material.dart';
import 'package:mini_taskhub_personal_task_tracker/app/theme.dart';
import 'package:mini_taskhub_personal_task_tracker/app/theme_provider.dart';
import 'package:mini_taskhub_personal_task_tracker/auth/auth_service.dart';
import 'package:mini_taskhub_personal_task_tracker/auth/login_screen.dart';
import 'package:mini_taskhub_personal_task_tracker/dashboard/dashboard_screen.dart';
import 'package:mini_taskhub_personal_task_tracker/dashboard/task_provider.dart';
import 'package:mini_taskhub_personal_task_tracker/services/supabase_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

const supabaseUrl = 'https://jraqwcwmzclzkijtzgrt.supabase.co';
  const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpyYXF3Y3dtemNsemtpanR6Z3J0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxNTkzMzIsImV4cCI6MjA2MDczNTMzMn0.lyNfrCjWlSw14PSflAbhirqf9iSFXIxXYsQWYq56qt4';  // --- !!! ---

  // Add credential check (optional but recommended)
  if (supabaseUrl.startsWith('YOUR_') || supabaseAnonKey.startsWith('YOUR_')) {
     debugPrint("*************************************************");
     debugPrint("WARNING: Supabase URL/Key not set in main.dart!");
     debugPrint("Replace placeholders with your actual credentials.");
     debugPrint("App might not function correctly.");
     debugPrint("*************************************************");
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // App-wide state providers
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()), // Add ThemeProvider

        // Service Providers (usually don't need ChangeNotifier)
        Provider<SupabaseService>(create: (_) => SupabaseService(supabase)),
        Provider<AuthService>(create: (_) => AuthService(supabase.auth)),

        // Feature-specific state providers
        ChangeNotifierProvider<TaskProvider>(
          create: (context) => TaskProvider(context.read<SupabaseService>()),
        ),
      ],
      // Consume the ThemeProvider to set the themeMode dynamically
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'DayTask Tracker',
            theme: AppTheme.lightTheme, // Your light theme definition
            darkTheme: AppTheme.darkTheme, // Your dark theme definition
            themeMode: themeProvider.themeMode, // Set themeMode from provider
            debugShowCheckedModeBanner: false,
            home: const AuthGate(), // AuthGate remains the entry point
          );
        },
      ),
    );
  }
}


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Center(child: CircularProgressIndicator(color: AppColors.primaryYellow)));
        }

        final session = snapshot.data?.session;

        if (session != null) {
          return const DashboardScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}