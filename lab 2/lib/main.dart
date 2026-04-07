import 'package:flutter/material.dart';
import 'part1_layout.dart';
import 'part2_responsive.dart';
import 'part3_navigation.dart';
import 'part4_form.dart';

void main() {
  runApp(const LabApp());
}

class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Lab 2',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenu(),
        '/part1': (context) => const Part1Layout(),
        '/part2': (context) => const Part2Responsive(),
        // Part 3 routes
        '/part3': (context) => const HomeScreen(),
        '/second': (context) => const SecondScreen(),
        '/part4': (context) => const Part4Form(),
      },
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Lab 2 Practice'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildProjectCard(
              context,
              title: 'Part 1: Layout Widgets',
              subtitle: 'Column, Row, Stack, Container, & Padding',
              icon: Icons.layers,
              route: '/part1',
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildProjectCard(
              context,
              title: 'Part 2: Responsive Layout',
              subtitle: 'MediaQuery & Breakpoints',
              icon: Icons.devices,
              route: '/part2',
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _buildProjectCard(
              context,
              title: 'Part 3: Navigation',
              subtitle: 'Named Routes & Screen Transitions',
              icon: Icons.navigation,
              route: '/part3',
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildProjectCard(
              context,
              title: 'Part 4: Form Application',
              subtitle: 'Custom TextFields & User Input',
              icon: Icons.edit_note,
              route: '/part4',
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
