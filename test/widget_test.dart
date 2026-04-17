// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:first_flutter/main.dart';

void main() {
  testWidgets('Tab bar switches between calculator and wikipedia', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Calculator'), findsWidgets);
    expect(find.text('First number'), findsOneWidget);

    await tester.tap(find.text('Wikipedia').last);
    await tester.pumpAndSettle();

    expect(find.text('Open Wikipedia Result'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Calculator adds numbers', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField).at(0), '10');
    await tester.enterText(find.byType(TextField).at(1), '5');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
    await tester.pump();

    expect(find.text('Result: 15.00'), findsOneWidget);
  });
}
