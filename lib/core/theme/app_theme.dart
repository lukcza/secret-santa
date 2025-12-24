import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFD32F2F);
  static const Color primaryDark = Color(0xFFB71C1C);
  static const Color primaryLight = Color(0xFFEF5350);

  static const Color forest = Color(0xFF2E7D32);
  static const Color gold = Color(0xFFFFC107);

  static const Color backgroundLight = Color(0xFFFCF8F9);
  static const Color surfaceLight = Color(0xFFFFFFFF);

  static const Color backgroundDark = Color(0xFF0F0505);
  static const Color surfaceDark = Color(0xFF2a1215);
  static const Color surfaceHighlight = Color(0xFF2D1519);

  static const Color textMain = Color(0xFF1B0E10);
  static const Color textInverse = Color(0xFFFDF2F4);
  static const Color textMuted = Color(0xFF994D5C);

  static const Color borderDark = Color(0xFF4a2328);

  static OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(15),
    );
  }

  static final ThemeData lightThemeMode = ThemeData.light().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      secondary: forest,
      onSecondary: Colors.white,
      tertiary: gold,
      surface: surfaceLight,
      onSurface: textMain,
      error: primaryDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      filled: true,
      fillColor: surfaceLight,
      enabledBorder: _border(Colors.grey.shade300),
      focusedBorder: _border(primary),
      errorBorder: _border(primaryDark),
      focusedErrorBorder: _border(primaryDark),
      hintStyle: const TextStyle(color: textMuted),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
  );

  static final ThemeData darkThemeMode = ThemeData.dark().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      onPrimary: Colors.white,
      secondary: forest,
      onSecondary: Colors.white,
      tertiary: gold,
      surface: surfaceDark,
      onSurface: textInverse,
      background: backgroundDark,
      error: primaryLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: textInverse,
      centerTitle: true,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      filled: true,
      fillColor: surfaceDark,
      border: _border(borderDark),
      enabledBorder: _border(surfaceHighlight),
      focusedBorder: _border(primary),
      errorBorder: _border(primaryLight),
      focusedErrorBorder: _border(primaryLight),
      hintStyle: TextStyle(color: textInverse.withOpacity(0.5)),
      prefixIconColor: textMuted,
      suffixIconColor: textMuted,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
  );
}