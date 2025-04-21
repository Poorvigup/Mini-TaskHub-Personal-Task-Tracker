import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themePrefKey = 'app_theme_mode';
  ThemeMode _themeMode = ThemeMode.dark; // Default to dark theme

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeMode(); // Load saved theme on initialization
  }

  // Load theme mode from shared preferences
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themePrefKey);

    if (savedTheme == 'light') {
      _themeMode = ThemeMode.light;
    } else if (savedTheme == 'system') {
      _themeMode = ThemeMode.system;
    } else {
      _themeMode = ThemeMode.dark; // Default to dark if nothing saved or invalid
    }
    notifyListeners(); // Notify listeners after loading
  }

  // Toggle theme and save preference
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }

    // Save the new preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePrefKey, _themeMode == ThemeMode.light ? 'light' : 'dark');

    notifyListeners(); // Notify UI to rebuild
  }

}