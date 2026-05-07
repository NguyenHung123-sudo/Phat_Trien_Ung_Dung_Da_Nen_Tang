import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../widgets/app_logo.dart';
import '../config/api_config.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) => prefs = p);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _loginUser() async {
    if (_emailCtrl.text.isNotEmpty && _passwordCtrl.text.isNotEmpty) {
      try {
        var response = await http.post(
          Uri.parse(ApiConfig.login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": _emailCtrl.text, "password": _passwordCtrl.text}),
        );
        var jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          final myToken = jsonResponse['token'];
          prefs.setString('token', myToken);
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardScreen(token: myToken)),
          );
        } else {
          setState(() => _isNotValidate = true);
        }
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không thể kết nối server')));
      }
    } else {
      setState(() => _isNotValidate = true);
    }
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
                    'Email Sign-In',
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
                        errorText: _isNotValidate ? "Enter Proper Info" : null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  // LogIn button
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: GestureDetector(
                      onTap: _loginUser,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(8)),
                        child: const Text('LogIn', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
          child: Container(
            height: 45,
            color: Colors.lightBlue,
            child: const Center(
              child: Text("Create a new Account..! Sign Up", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}
