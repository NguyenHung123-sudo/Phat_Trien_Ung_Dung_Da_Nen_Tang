import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../singleton/auth_singleton.dart';
import '../widgets/shared_button.dart';
import '../widgets/shared_text_field.dart';
import 'admin_screen.dart';
import 'customer_screen.dart';
import 'register_screen.dart';
import 'vendor_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) return;
    setState(() => _isLoading = true);
    final result = await ApiService.login(
        email: _emailController.text, password: _passwordController.text);
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (result['success']) {
      final auth = AuthSingleton();
      final data = result['data'];
      auth.token = data.token;
      auth.email = data.email;
      auth.role = data.role;
      auth.userId = data.userId;

      Widget screen;
      switch (auth.role?.toLowerCase()) {
        case 'admin':
          screen = const AdminScreen();
          break;
        case 'vendor':
          screen = const VendorScreen();
          break;
        default:
          screen = const CustomerScreen();
      }
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => screen));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0C0F14), Color(0xFF131820), Color(0xFF0E1520)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFEF6C00)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withOpacity(0.45),
                          blurRadius: 28,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.manage_accounts_rounded,
                        size: 46, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'HỆ THỐNG QUẢN LÝ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'User Management System',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFF59E0B),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Card form
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2030),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF2C3A50)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withOpacity(0.05),
                          blurRadius: 40,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 22,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF59E0B), Color(0xFFEF6C00)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Đăng nhập',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Padding(
                          padding: EdgeInsets.only(left: 14),
                          child: Text(
                            'Nhập thông tin tài khoản của bạn',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF7A8899)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SharedTextField(
                          controller: _emailController,
                          label: 'Email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        SharedTextField(
                          controller: _passwordController,
                          label: 'Mật khẩu',
                          obscureText: true,
                          prefixIcon: Icons.lock_outline,
                        ),
                        const SizedBox(height: 28),
                        SharedButton(
                          label: 'ĐĂNG NHẬP',
                          onPressed: _login,
                          isLoading: _isLoading,
                          icon: Icons.login_rounded,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Chưa có tài khoản?',
                          style: TextStyle(color: Color(0xFF7A8899))),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterScreen()),
                        ),
                        child: const Text(
                          'Đăng ký ngay',
                          style: TextStyle(
                            color: Color(0xFFF59E0B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
