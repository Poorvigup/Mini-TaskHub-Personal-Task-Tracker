import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart'; 

class AuthService {
  final GoTrueClient _auth;

  AuthService(this._auth);

  Future<AuthResponse> signUp(String email, String password, {SignUpOptions? options}) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      debugPrint('Sign Up Error: ${e.message}');
      throw Exception('Sign Up Failed: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected Sign Up Error: $e');
      throw Exception('An unexpected error occurred during sign up.');
    }
  }

  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      debugPrint('Sign In Error: ${e.message}');
      throw Exception('Sign In Failed: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected Sign In Error: $e');
      throw Exception('An unexpected error occurred during sign in.');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on AuthException catch (e) {
      debugPrint('Sign Out Error: ${e.message}');
      throw Exception('Sign Out Failed: ${e.message}');
    } catch (e) {
       debugPrint('Unexpected Sign Out Error: $e');
      throw Exception('An unexpected error occurred during sign out.');
    }
  }

  // Helper to show error messages using the app's theme
  void showErrorSnackBar(BuildContext context, String message) {
    final displayMessage = message.startsWith("Exception: ")
        ? message.substring("Exception: ".length)
        : message;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(displayMessage),
        backgroundColor: Theme.of(context).colorScheme.error, 
      ),
    );
  }
}

class SignUpOptions {
}