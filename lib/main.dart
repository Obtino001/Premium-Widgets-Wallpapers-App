import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/design.dart';
import 'core/favorites.dart';
import 'screens/onboarding.dart';
import 'screens/app_shell.dart';

void main() { WidgetsFlutterBinding.ensureInitialized(); runApp(const FormApp()); }

class FormApp extends StatefulWidget {
  const FormApp({super.key});
  @override
  State<FormApp> createState() => _FormAppState();
}

class _FormAppState extends State<FormApp> {
  final favorites = Favorites();
  bool? onboarded;
  bool splash = true;

  @override
  void initState() { super.initState(); _init(); }
  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    await favorites.load();
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() { onboarded = prefs.getBool('form.onboarded.v1') ?? false; splash = false; });
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('form.onboarded.v1', true);
    if (mounted) setState(() => onboarded = true);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: Brand.name, theme: AppTheme.light, debugShowCheckedModeBanner: false,
    home: AnimatedSwitcher(duration: const Duration(milliseconds: 280), child: splash
      ? const SplashScreen(key: ValueKey('splash'))
      : onboarded == true
        ? AppShell(key: const ValueKey('shell'), favorites: favorites)
        : OnboardingScreen(key: const ValueKey('onboarding'), onFinished: _finish)),
  );
}
