import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../widgets/app_logo.dart';
import '../config/api_config.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isNotValidate = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _registerUser() async {
    if (_emailCtrl.text.isNotEmpty && _passwordCtrl.text.isNotEmpty) {
      final username = _emailCtrl.text.split('@')[0];
      try {
        var response = await http.post(
          Uri.parse(ApiConfig.register),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": username,
            "email":    _emailCtrl.text,
            "password": _passwordCtrl.text,
          }),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng ký thành công! Hãy đăng nhập.'), backgroundColor: Colors.green),
          );
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        } else {
          final msg = jsonDecode(response.body)['message'] ?? 'Đã xảy ra lỗi';
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        }
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không thể kết nối server')));
      }
    } else {
      setState(() => _isNotValidate = true);
    }
  }

  String _generatePassword() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*';
    final rand = Random();
    return List.generate(16, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0XFFF95A3B), Color(0XFFF96713)],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomCenter,
              stops: [0.0, 0.8],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CommonLogo(),
                  const SizedBox(height: 10),
                  const Text(
                    'CREATE YOUR ACCOUNT',
                    style: TextStyle(fontSize: 22, color: Color(0xFFFFF9C4), fontWeight: FontWeight.bold),
                  ),
                  // Email
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true, fillColor: Colors.white,
                        hintText: "Email",
                        errorText: _isNotValidate ? "Enter Proper Info" : null,
                        errorStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  // Password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: TextField(
                      controller: _passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true, fillColor: Colors.white,
                        hintText: "Password",
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.password),
                          onPressed: () => setState(() => _passwordCtrl.text = _generatePassword()),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () => Clipboard.setData(ClipboardData(text: _passwordCtrl.text)),
                        ),
                        errorText: _isNotValidate ? "Enter Proper Info" : null,
                        errorStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  // Register button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: GestureDetector(
                      onTap: _registerUser,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(8)),
                        child: const Text('Register', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  // Sign In link
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Already Registered?"),
                        Text(" Sign In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
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
