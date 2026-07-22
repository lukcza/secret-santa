import 'package:flutter/material.dart';

class AppTheme {
  // Primary Festive Red palette
  static const Color primary = Color(0xFFD32F2F);
  static const Color primaryDark = Color(0xFFB71C1C);
  static const Color primaryLight = Color(0xFFEF5350);
  static const Color primaryAccent = Color(0xFFE53935);
  static const Color primaryTransparent = Color(0x80D32F2F);

  // Pine & Forest Green palette
  static const Color forest = Color(0xFF2E7D32);
  static const Color forestDark = Color(0xFF112217);
  static const Color forestElevated = Color(0xFF1E3A28);
  static const Color forestLight = Color(0xFF4CAF50);
  static const Color forestMoreDark = Color(0xFF66BB6A);

  // Accent Gold & Slate palette
  static const Color gold = Color(0xFFFFC107);
  static const Color goldLight = Color(0xFFFFB300);
  static const Color slateBlue = Color(0xFF90A4AE);

  // Light Theme Surface & Text
  static const Color backgroundLight = Color(0xFFFCF8F9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textMain = Color(0xFF1B0E10);

  // Dark Theme Surface & Text (Deep Pine Dark Theme)
  static const Color backgroundDark = Color(0xFF0A150E);
  static const Color surfaceDark = Color(0xFF112217);
  static const Color surfaceHighlight = Color(0xFF1E3A28);
  static const Color surfaceDarkTransparent = Color(0xFF14271B);

  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFFA1B0A6);

  static const Color borderDark = Color(0xFF1F3526);

  static OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(15),
    );
  }

  static const SearchBarThemeData searchBarTheme = SearchBarThemeData(
    elevation: WidgetStatePropertyAll(0),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        side: BorderSide.none,
      ),
    ),
    hintStyle: WidgetStatePropertyAll(TextStyle(color: textMuted)),
  );

  static final ThemeData lightThemeMode = ThemeData(
    useMaterial3: true,
    fontFamily: 'PlusJakartaSans',
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundLight,
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: 'PlusJakartaSans',
      bodyColor: textMain,
      displayColor: textMain,
    ),
    colorScheme: const ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      secondary: forest,
      secondaryFixed: forestDark,
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
      errorStyle: const TextStyle(
        color: primaryDark,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      errorMaxLines: 2,
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

  static final ThemeData darkThemeMode = ThemeData(
    useMaterial3: true,
    fontFamily: 'PlusJakartaSans',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,
    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: 'PlusJakartaSans',
      bodyColor: textInverse,
      displayColor: textInverse,
    ),
    colorScheme: const ColorScheme.dark(
      primary: primary,
      onPrimary: Colors.white,
      secondary: forest,
      secondaryFixed: forestDark,
      onSecondary: Colors.white,
      tertiary: gold,
      surface: surfaceDark,
      surfaceTint: surfaceDarkTransparent,
      onSurface: textInverse,
      secondaryContainer: textMuted,
      background: backgroundDark,
      error: primaryLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      foregroundColor: textInverse,
      centerTitle: true,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      filled: true,
      fillColor: surfaceDark,
      border: _border(textMuted),
      enabledBorder: _border(surfaceHighlight),
      focusedBorder: _border(primary),
      errorBorder: _border(primaryLight),
      focusedErrorBorder: _border(primaryLight),
      hintStyle: TextStyle(color: textInverse.withOpacity(0.5)),
      prefixIconColor: textMuted,
      suffixIconColor: textMuted,
      errorStyle: const TextStyle(
        color: primaryLight,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      errorMaxLines: 2,
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
    cardTheme: const CardThemeData(
      color: surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: surfaceHighlight, width: 1),
      ),
    ),
  );
}