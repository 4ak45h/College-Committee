import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFF2B2F78);
  static const accent = Color(0xFF00C2D1);
  static const coral = Color(0xFFFF6B6B);
  static const bg = Color(0xFFFBFBFD);
  static const muted = Color(0xFF58607A);

  static ThemeData light() {
    final base = ThemeData.light();

    return base.copyWith(
      scaffoldBackgroundColor: bg,
      primaryColor: primary,

      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        secondary: accent,
      ),

      // ✅ Use default Material text theme (NO google_fonts)
      textTheme: base.textTheme.apply(
        bodyColor: muted,
        displayColor: primary,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          elevation: 2,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF7F8FB),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primary,
        centerTitle: true,
      ),
    );
  }
}
