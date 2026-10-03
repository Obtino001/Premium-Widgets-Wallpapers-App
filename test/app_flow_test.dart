import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_personalize/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onboarding leads to discovery and bottom navigation', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(const FormApp());
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();
    expect(find.text('Your screen,\nyour style.'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Make it yours.'), findsOneWidget);
    await tester.tap(find.text('Widgets').last);
    await tester.pumpAndSettle();
    expect(find.text('Small things that make your screen yours.'), findsOneWidget);
    await tester.tap(find.text('Wallpapers').last);
    await tester.pumpAndSettle();
    expect(find.text('A new perspective for your everyday.'), findsOneWidget);
    await tester.tap(find.text('Saved').last);
    await tester.pumpAndSettle();
    expect(find.text('Nothing saved yet.'), findsOneWidget);
  });
}
