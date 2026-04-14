import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab3 - Form & Navigation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B5EA7),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black87,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
