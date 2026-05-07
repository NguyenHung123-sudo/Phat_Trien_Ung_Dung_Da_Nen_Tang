import 'package:flutter/material.dart';

/// CommonLogo - Logo chung hiển thị ở Register và Login
class CommonLogo extends StatelessWidget {
  const CommonLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          "https://pluspng.com/img-png/avengers-logo-png-avengers-logo-png-1376.png",
          width: 100,
          errorBuilder: (_, __, ___) => Container(
            width: 100, height: 100,
            decoration: const BoxDecoration(
              color: Colors.white24, shape: BoxShape.circle,
            ),
            child: const Icon(Icons.task_alt, size: 60, color: Colors.white),
          ),
        ),
        const Text(
          "To-Do App",
          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
        const Text(
          "Make A List of your task",
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w300, letterSpacing: 1.5),
        ),
      ],
    );
  }
}
