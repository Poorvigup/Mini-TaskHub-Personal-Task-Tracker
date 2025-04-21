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

  // --- Your Supabase Credentials ---
  const supabaseUrl = 'https://jraqwcwmzclzkijtzgrt.supabase.co';
  const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpyYXF3Y3dtemNsemtpanR6Z3J0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxNTkzMzIsImV4cCI6MjA2MDczNTMzMn0.lyNfrCjWlSw14PSflAbhirqf9iSFXIxXYsQWYq56qt4';
  // --- End Credentials ---

  // Optional Check (keep or remove)
  if (supabaseUrl.startsWith('YOUR_') || supabaseAnonKey.startsWith('YOUR_')) {
     debugPrint("*************************************************");
     debugPrint("WARNING: Supabase URL/Key might be incorrect!");
     debugPrint("*************************************************");
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

// Global Supabase client instance
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        Provider<SupabaseService>(create: (_) => SupabaseService(supabase)),
        Provider<AuthService>(create: (_) => AuthService(supabase.auth)),
        ChangeNotifierProvider<TaskProvider>(
          create: (context) => TaskProvider(context.read<SupabaseService>()),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Mini-TaskHub', // Updated Title
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}

// AuthGate with Debugging prints
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // --- DEBUG PRINT ADDED ---
        // This print will show every time the auth state stream emits an event
        debugPrint('[AuthGate StreamBuilder] State: ${snapshot.connectionState}, HasData: ${snapshot.hasData}, Session object: ${snapshot.data?.session}');
        // --- END OF DEBUG PRINT ---

        // Show loading indicator while waiting for the initial state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Center(child: CircularProgressIndicator(color: AppColors.primaryYellow)));
        }

        // Check if there's session data in the snapshot
        final session = snapshot.data?.session;

        if (session != null) {
          // --- DEBUG PRINT ADDED ---
          debugPrint('[AuthGate] Session found (User ID: ${session.user.id}), returning DashboardScreen.');
          // --- END OF DEBUG PRINT ---
          return const DashboardScreen();
        } else {
          // --- DEBUG PRINT ADDED ---
          debugPrint('[AuthGate] Session is null, returning LoginScreen.');
          // --- END OF DEBUG PRINT ---
          return const LoginScreen();
        }
      },
    );
  }
}