import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hitachi_exam/screens/screen1_login.dart';

void main() {
  testWidgets('login screen shows a disabled Enter button initially', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Screen1Login()));
    await tester.pump();

    expect(find.text('Enter'), findsOneWidget);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull, reason: 'Enter must be disabled with empty username');
  });

  testWidgets('typing special characters shows the alphanumeric error', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Screen1Login()));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'user_name');
    await tester.pump();

    expect(find.text('Values must be alphanumeric'), findsOneWidget);
  });

  testWidgets('valid username enables the Enter button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Screen1Login()));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'validuser');
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });
}
