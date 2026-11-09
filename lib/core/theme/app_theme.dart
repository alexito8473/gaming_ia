import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData darkTheme = _buildDarkTheme();

  static final ThemeData lightTheme = _buildLightTheme();

  // =========================
  // DARK THEME
  // =========================

  static ThemeData _buildDarkTheme() {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF382568),
      onPrimaryContainer: Color(0xFFE9DDFF),

      secondary: AppColors.secondary,
      onSecondary: Color(0xFF00363D),

      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,

      error: AppColors.error,
      onError: Colors.white,

      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkDivider,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppColors.darkBackground,

      // Text
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.darkTextPrimary,
        ),
        bodyMedium: TextStyle(
          color: AppColors.darkTextSecondary,
        ),
        bodySmall: TextStyle(
          color: AppColors.darkTextSecondary,
        ),
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.darkBorder,
          ),
        ),
      ),

      // Inputs
      inputDecorationTheme: _inputDecorationTheme(
        fillColor: AppColors.darkSurfaceVariant,
        borderColor: AppColors.darkBorder,
        hintColor: AppColors.darkTextSecondary,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkTextPrimary,
          side: const BorderSide(
            color: AppColors.darkBorder,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
      ),

      // Icons
      iconTheme: const IconThemeData(
        color: AppColors.darkTextSecondary,
      ),

      // Navigation
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        labelTextStyle: const WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // =========================
  // LIGHT THEME
  // =========================

  static ThemeData _buildLightTheme() {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primaryDark,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFEDE5FF),
      onPrimaryContainer: Color(0xFF32156B),

      secondary: Color(0xFF0891B2),
      onSecondary: Colors.white,

      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,

      error: AppColors.error,
      onError: Colors.white,

      outline: AppColors.lightBorder,
      outlineVariant: AppColors.lightDivider,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppColors.lightBackground,

      // Text
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.lightTextPrimary,
        ),
        bodyMedium: TextStyle(
          color: AppColors.lightTextSecondary,
        ),
        bodySmall: TextStyle(
          color: AppColors.lightTextSecondary,
        ),
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.lightBorder,
          ),
        ),
      ),

      // Inputs
      inputDecorationTheme: _inputDecorationTheme(
        fillColor: AppColors.lightSurface,
        borderColor: AppColors.lightBorder,
        hintColor: AppColors.lightTextSecondary,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightTextPrimary,
          side: const BorderSide(
            color: AppColors.lightBorder,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
        ),
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: AppColors.lightDivider,
        thickness: 1,
      ),

      // Icons
      iconTheme: const IconThemeData(
        color: AppColors.lightTextSecondary,
      ),

      // Navigation
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        labelTextStyle: const WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // =========================
  // SHARED INPUT DECORATION
  // =========================

  static InputDecorationTheme _inputDecorationTheme({
    required Color fillColor,
    required Color borderColor,
    required Color hintColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      hintStyle: TextStyle(color: hintColor),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.error,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
      ),
    );
  }
}