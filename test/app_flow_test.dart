import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_personalize/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onboarding leads to discovery and bottom navigation', (
    tester,
  ) async {
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
    expect(
      find.text('Small things that make your screen yours.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Wallpapers').last);
    await tester.pumpAndSettle();
    expect(find.text('A new perspective for your everyday.'), findsOneWidget);
    await tester.tap(find.text('Saved').last);
    await tester.pumpAndSettle();
    expect(find.text('Nothing saved yet.'), findsOneWidget);
  });

  testWidgets('a theme can be saved and found in Saved', (tester) async {
    SharedPreferences.setMockInitialValues({'form.onboarded.v1': true});
    await tester.binding.setSurfaceSize(const Size(360, 800));
    await tester.pumpWidget(const FormApp());
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View theme'));
    await tester.pumpAndSettle();
    expect(
      find.text('A calm neutral setup built for slow starts.'),
      findsOneWidget,
    );
    await tester.ensureVisible(find.text('Save').last);
    await tester.tap(find.text('Save').last);
    await tester.pumpAndSettle();
    expect(find.text('Saved').last, findsOneWidget);
    Navigator.of(
      tester.element(find.text('A calm neutral setup built for slow starts.')),
    ).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Saved').last);
    await tester.pumpAndSettle();
    expect(find.text('Your favorite looks, all in one place.'), findsOneWidget);
    expect(find.text('Quiet Morning'), findsOneWidget);
  });

  testWidgets('widget and wallpaper details open their Phase 1 actions', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'form.onboarded.v1': true});
    await tester.binding.setSurfaceSize(const Size(360, 800));
    await tester.pumpWidget(const FormApp());
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Widgets').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Minimal Clock').first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add Widget'));
    await tester.tap(find.text('Add Widget'));
    await tester.pumpAndSettle();
    expect(
      find.text('Home-screen widgets will be available in the next build.'),
      findsOneWidget,
    );
    Navigator.of(tester.element(find.text('Coming soon'))).pop();
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.text('Minimal Clock').first)).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wallpapers').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Morning Haze').first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Set Wallpaper'));
    await tester.tap(find.text('Set Wallpaper'));
    await tester.pumpAndSettle();
    expect(
      find.text('Wallpaper setting will be available in the next build.'),
      findsOneWidget,
    );
  });
}
