import 'package:flutter/material.dart';

class Brand {
  static const name = 'FORM';
  static const tagline = 'Make your screen yours.';
}

class AppColors {
  static const ivory = Color(0xFFF7F6F2);
  static const ink = Color(0xFF171717);
  static const muted = Color(0xFF77736F);
  static const white = Color(0xFFFFFFFF);
  static const secondary = Color(0xFFEEECE7);
  static const sage = Color(0xFFA7B29D);
  static const blue = Color(0xFF9FAFC0);
  static const clay = Color(0xFFC69E89);
  static const dark = Color(0xFF20201F);
}

class Space {
  static const xs = 6.0;
  static const sm = 12.0;
  static const md = 18.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 44.0;
}

class RadiusSize {
  static const card = 22.0;
  static const small = 17.0;
  static const button = 17.0;
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.ivory,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.sage, surface: AppColors.ivory),
    textTheme: const TextTheme(
      displaySmall: TextStyle(fontSize: 33, height: 1.15, fontWeight: FontWeight.w600, color: AppColors.ink, letterSpacing: -1.3),
      headlineMedium: TextStyle(fontSize: 27, height: 1.2, fontWeight: FontWeight.w600, color: AppColors.ink, letterSpacing: -.7),
      titleLarge: TextStyle(fontSize: 20, height: 1.25, fontWeight: FontWeight.w600, color: AppColors.ink, letterSpacing: -.3),
      titleMedium: TextStyle(fontSize: 16, height: 1.3, fontWeight: FontWeight.w600, color: AppColors.ink),
      bodyMedium: TextStyle(fontSize: 15, height: 1.5, color: AppColors.ink),
      bodySmall: TextStyle(fontSize: 13, height: 1.45, color: AppColors.muted),
      labelSmall: TextStyle(fontSize: 12, height: 1.3, fontWeight: FontWeight.w600, color: AppColors.muted),
    ),
    splashFactory: NoSplash.splashFactory,
  );
}
