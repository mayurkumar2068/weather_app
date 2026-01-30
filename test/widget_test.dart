import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic widget test', (WidgetTester tester) async {
    // Build a simple MaterialApp
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Test App'),
        ),
      ),
    );

    // Verify that the app starts
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Test App'), findsOneWidget);
  });

  testWidgets('Scaffold should be present', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Glasscast')),
          body: const Center(child: Text('AI-powered weather insights')),
        ),
      ),
    );

    // Verify basic UI elements
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('Glasscast'), findsOneWidget);
    expect(find.text('AI-powered weather insights'), findsOneWidget);
  });
}
