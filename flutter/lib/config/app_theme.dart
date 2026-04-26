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
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.glassBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.heading1,
        iconTheme: IconThemeData(
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
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundTertiary,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.borderPrimary,
            width: 2,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.borderPrimary,
            width: 2,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryRed,
            width: 2,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(16, 18, 16, 20),
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

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimaryRed,
        secondary: AppColors.darkPrimaryRedLight,
        surface: AppColors.darkBackgroundSecondary,
        onSurface: AppColors.darkTextPrimary,
        error: AppColors.error,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.darkBackgroundPrimary,

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkGlassBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.heading1.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.darkTextPrimary,
          size: 24,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.heading1.copyWith(color: AppColors.darkTextPrimary),
        displayMedium: AppTypography.heading2.copyWith(color: AppColors.darkTextPrimary),
        displaySmall: AppTypography.heading3.copyWith(color: AppColors.darkTextPrimary),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.darkTextPrimary),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.darkTextPrimary),
        bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.darkTextSecondary),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.darkTextPrimary),
        labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.darkTextSecondary),
      ),

      // Input Decoration
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkBackgroundTertiary,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.darkBorderPrimary,
            width: 2,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.darkBorderPrimary,
            width: 2,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.darkPrimaryRed,
            width: 2,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(16, 18, 16, 20),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimaryRed,
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
        color: AppColors.darkBackgroundSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorderSecondary,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
