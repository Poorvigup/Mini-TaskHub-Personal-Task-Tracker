import 'package:flutter/material.dart';
import 'package:mini_taskhub_personal_task_tracker/app/theme.dart';
import 'package:mini_taskhub_personal_task_tracker/auth/auth_service.dart';
import 'package:mini_taskhub_personal_task_tracker/auth/signup_screen.dart';
import 'package:mini_taskhub_personal_task_tracker/utils/validators.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    final authService = Provider.of<AuthService>(context, listen: false);
    FocusScope.of(context).unfocus();

    try {
      debugPrint('[LoginScreen] Calling authService.signIn for email: ${_emailController.text.trim()}');
      final response = await authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      debugPrint('[LoginScreen] authService.signIn completed.');
      debugPrint('[LoginScreen] signIn response: User ID: ${response.user?.id}, Session: ${response.session}');

       if (!mounted) return;

    } catch (e) {
      debugPrint('[LoginScreen] Error during signIn: $e');
       if (!mounted) return;
      authService.showErrorSnackBar(context, e.toString());
    } finally {
      if (mounted) {
         setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                  Text('Welcome Back!', style: textTheme.headlineMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('Log in to manage your tasks', style: textTheme.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 30),
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
                     onFieldSubmitted: (_) => _isLoading ? null : _login(),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                         onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Forgot Password not implemented'))),
                         style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 4)),
                         child: Text('Forgot Password?', style: textTheme.bodySmall),
                       ),
                   ),
                  const SizedBox(height: 25),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primaryYellow))
                      : ElevatedButton(onPressed: _login, child: const Text('Log In')),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      const Expanded(child: Divider(endIndent: 10)),
                      Text("Or continue with", style: textTheme.bodySmall),
                      const Expanded(child: Divider(indent: 10)),
                    ],
                  ),
                   const SizedBox(height: 20),
                  OutlinedButton.icon(
                     icon: Image.asset('assets/images/google_logo.png', height: 20.0, width: 20.0),
                     label: Text('Sign in with Google'),
                     onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Google Sign-In not implemented'))),
                   ),
                   const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?", style: textTheme.bodyMedium),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const SignUpScreen())),
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
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