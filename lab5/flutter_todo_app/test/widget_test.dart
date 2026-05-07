import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo_app/main.dart';

void main() {
  testWidgets('TodoApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());
    // App khởi động → SplashScreen hiện lên
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
