// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stattrack/main.dart';

void main() {
  testWidgets('Signin page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify we're on login page
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Home page'), findsNothing);

    // Check for buttons
    expect(find.widgetWithText(ElevatedButton, 'Facebook'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Google'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Email'), findsOneWidget);
  });
}
