// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:osrs_bot_dashboard/main.dart';

void main() {
  testWidgets('Settings button exists in app bar', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    
    // Wait for the app to load
    await tester.pumpAndSettle();

    // Verify that the settings button exists
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('Settings dialog can be opened', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    
    // Wait for the app to load
    await tester.pumpAndSettle();

    // Tap the settings icon
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Verify that the settings dialog is shown
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('API Server Configuration'), findsOneWidget);
    expect(find.text('API IP Address'), findsOneWidget);
  });
}
