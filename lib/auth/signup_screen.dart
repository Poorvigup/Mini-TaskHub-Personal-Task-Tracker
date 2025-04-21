import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mini_taskhub_personal_task_tracker/app/theme.dart'; // Adjusted import path
import 'package:mini_taskhub_personal_task_tracker/auth/auth_service.dart'; // Adjusted import path
import 'package:mini_taskhub_personal_task_tracker/auth/login_screen.dart'; // Adjusted import path
import 'package:mini_taskhub_personal_task_tracker/utils/validators.dart'; // Adjusted import path
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Keep for potential future use, even if options are commented


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
     if (!_formKey.currentState!.validate()) {
       debugPrint('[SignUpScreen] Form validation failed.'); // Add debug for validation fail
       return;
      }
     if (!_agreedToTerms) {
      debugPrint('[SignUpScreen] Terms not agreed.'); // Add debug
      Provider.of<AuthService>(context, listen: false)
          .showErrorSnackBar(context, 'You must agree to the Terms & Conditions');
      return;
    }

    setState(() => _isLoading = true);
    final authService = Provider.of<AuthService>(context, listen: false);
    FocusScope.of(context).unfocus();

    try {
      debugPrint('[SignUpScreen] Calling authService.signUp for email: ${_emailController.text.trim()}');

      // --- MODIFICATION: Temporarily remove the 'options' parameter ---
      final response = await authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        // options: SignUpOptions(data: {'full_name': _nameController.text.trim()}), // <-- Commented out for testing
      );
      // --- END OF MODIFICATION ---

      debugPrint('[SignUpScreen] authService.signUp completed.');
      debugPrint('[SignUpScreen] signUp response: User ID: ${response.user?.id}, Session exists: ${response.session != null}');

      if (!mounted) return;

      if (response.user != null) {
         debugPrint('[SignUpScreen] SignUp successful according to response.user.');
         ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Registration Successful! Checking session...'), backgroundColor: AppColors.successGreen),
         );
         // AuthGate handles navigation
      } else {
         debugPrint('[SignUpScreen] SignUp response.user was null, even without exception.');
         authService.showErrorSnackBar(context,"Sign up process initiated. Check email if confirmation is required, or try logging in.");
         // Avoid navigating here - let AuthGate handle state changes.
      }
    } catch (e) {
      debugPrint('[SignUpScreen] Error during signUp: $e');
       if (!mounted) return;
       authService.showErrorSnackBar(context, e.toString());
    } finally {
       if (mounted) {
         setState(() => _isLoading = false);
       }
    }
  }

  // --- build method remains unchanged ---
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hintColor = Theme.of(context).hintColor; // Use theme hint color

    return Scaffold(
       body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                   Text('DayTask', textAlign: TextAlign.center, style: textTheme.headlineLarge),
                  const SizedBox(height: 40),
                  Text('Create your account', style: textTheme.headlineMedium, textAlign: TextAlign.center),
                   const SizedBox(height: 30),
                   TextFormField(
                     controller: _nameController,
                     decoration: const InputDecoration(hintText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                     keyboardType: TextInputType.name,
                     validator: Validators.validateName,
                     autovalidateMode: AutovalidateMode.onUserInteraction,
                     style: textTheme.bodyLarge,
                     textInputAction: TextInputAction.next,
                   ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: 'Email Address', prefixIcon: Icon(Icons.email_outlined)),
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                     style: textTheme.bodyLarge,
                     textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                        onPressed: () => setState(() { _passwordVisible = !_passwordVisible; }),
                      ),
                    ),
                    obscureText: !_passwordVisible,
                    validator: Validators.validatePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                     style: textTheme.bodyLarge,
                     textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _isLoading ? null : _signUp(),
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile( // Uses CheckboxListTileTheme from AppTheme
                    value: _agreedToTerms,
                    onChanged: (bool? value) => setState(() { _agreedToTerms = value ?? false; }),
                    title: RichText(
                        text: TextSpan(
                            style: textTheme.bodySmall?.copyWith(color: hintColor), // Use theme hint color
                            children: [
                              const TextSpan(text: "I have read & agreed to DayTask "),
                              TextSpan(
                                  text: "Privacy Policy",
                                  style: const TextStyle(color: AppColors.primaryYellow, fontWeight: FontWeight.w500),
                                  recognizer: TapGestureRecognizer()..onTap = () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigate to Privacy Policy (not implemented)'))),
                              ),
                              const TextSpan(text: ", "),
                               TextSpan(
                                  text: "Terms & Condition",
                                  style: const TextStyle(color: AppColors.primaryYellow, fontWeight: FontWeight.w500),
                                   recognizer: TapGestureRecognizer()..onTap = () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigate to Terms & Conditions (not implemented)'))),
                              ),
                            ]
                        )
                    ),
                    // Theme takes care of controlAffinity, padding, dense, shape, activeColor
                  ),
                   const SizedBox(height: 25),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primaryYellow))
                      : ElevatedButton(onPressed: _signUp, child: const Text('Sign Up')),
                   const SizedBox(height: 20),
                  Row( children: <Widget>[ const Expanded(child: Divider(endIndent: 10)), Text("Or continue with", style: textTheme.bodySmall), const Expanded(child: Divider(indent: 10))]),
                   const SizedBox(height: 20),
                   OutlinedButton.icon( // Uses OutlinedButtonTheme from AppTheme
                      icon: Image.asset('assets/images/google_logo.png', height: 20.0, width: 20.0),
                      label: Text('Sign in with Google'),
                     onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Google Sign-In not implemented')))),
                   const SizedBox(height: 30),
                   Row( mainAxisAlignment: MainAxisAlignment.center, children: [ Text("Already have an account?", style: textTheme.bodyMedium), TextButton( onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen())), child: const Text('Log In'))]), // Uses TextButtonTheme
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}