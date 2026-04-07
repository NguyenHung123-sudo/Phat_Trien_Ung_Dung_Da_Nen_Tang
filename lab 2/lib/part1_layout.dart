import 'package:flutter/material.dart';

class Part1Layout extends StatelessWidget {
  const Part1Layout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Part 1: Layout Widgets')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Task 3: Add Padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "I'm in a Coloum and Centered. The below is a row.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Task 1: Changed to center
                children: [
                  // Task 4: Replaced loop with manual Containers
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(width: 80, height: 80, color: Colors.red),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(width: 80, height: 80, color: Colors.green),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(width: 80, height: 80, color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Stack(
                alignment: Alignment.topLeft, // Task 2: Changed to topLeft
                children: [
                  Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Stacked on Yellow Box',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
