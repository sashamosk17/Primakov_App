import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Main Theme Configuration
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryRed,
        secondary: AppColors.primaryRedLight,
        surface: AppColors.backgroundSecondary,
        error: Colors.red.shade700,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.backgroundPrimary,

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.glassBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.heading1,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: 24,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: AppTypography.heading1,
        displayMedium: AppTypography.heading2,
        displaySmall: AppTypography.heading3,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelSmall: AppTypography.labelSmall,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundTertiary,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.borderPrimary,
            width: 2,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.borderPrimary,
            width: 2,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryRed,
            width: 2,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
        hintStyle: AppTypography.placeholder,
        labelStyle: AppTypography.labelLarge,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          textStyle: AppTypography.button,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),

      // Card
      cardTheme: const CardThemeData(
        color: AppColors.backgroundSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSecondary,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
