import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString('token')));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    // Kiểm tra token: có và chưa hết hạn → Dashboard, ngược lại → Login
    final bool isLoggedIn = token != null && !JwtDecoder.isExpired(token!);

    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        useMaterial3: false,
      ),
      home: isLoggedIn
          ? DashboardScreen(token: token!)
          : const LoginScreen(),
    );
  }
}
