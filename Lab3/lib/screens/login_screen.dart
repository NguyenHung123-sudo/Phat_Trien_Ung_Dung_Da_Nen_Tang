import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'signup_screen.dart';
import 'reset_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = await _apiService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (!mounted) return;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
        );
      } else {
        _showError('Sai email hoặc mật khẩu!');
      }
    } catch (e) {
      if (mounted) _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(msg),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Title
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 40),

                // Person icon
                Center(
                  child: Icon(
                    Icons.person_outline,
                    size: 80,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 40),

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    filled: false,
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Nhập email' : null,
                ),

                const SizedBox(height: 12),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    filled: false,
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Nhập mật khẩu' : null,
                ),

                const SizedBox(height: 20),

                // Sign in button (text style, centered)
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF4EDFA),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _login,
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Color(0xFF7B5EA7),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 6),

                // Sign up button (outlined)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: Colors.black87,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUpScreen()),
                      );
                    },
                    child: const Text('Sign up', style: TextStyle(fontSize: 14)),
                  ),
                ),

                const SizedBox(height: 16),

                // Forgot password link
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
                      );
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
