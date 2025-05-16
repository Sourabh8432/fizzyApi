import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments in custom widget', (WidgetTester tester) async {
    // Define a minimal counter widget directly in the test
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Container(),
        ),
      ),
    );

    // Initial state
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Simulate user tap
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Check state after tap
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

