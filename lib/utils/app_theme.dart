import 'package:flutter/material.dart';

class AppTheme {
  static const Color earthDark = Color(0xFF2F2721);
  static const Color earthMid = Color(0xFF6E5B47);
  static const Color terracotta = Color(0xFFC56A4A);
  static const Color olive = Color(0xFF7B8A5B);
  static const Color cream = Color(0xFFF7F1E6);
  static const Color sand = Color(0xFFEADCC7);
  static const Color ink = Color(0xFF2B241F);
  static const Color muted = Color(0xFF8B7C6A);
  static const Color error = Color(0xFFB04735);

  static ThemeData buildTheme() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: terracotta,
      onPrimary: Colors.white,
      secondary: olive,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: ink,
      background: cream,
      onBackground: ink,
      error: error,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: cream,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStatePropertyAll(olive),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: sand,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: muted),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: sand),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: terracotta, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: earthDark,
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
