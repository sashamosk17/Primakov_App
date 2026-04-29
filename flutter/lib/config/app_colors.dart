import 'package:flutter/material.dart';

/// Design System Colors - "The Academic Curator"
/// Based on Figma design: node-id 1:21197
class AppColors {
  AppColors._();

  // Tailwind Dark Theme Colors
  static const Color darkSurface = Color(0xFF121416);
  static const Color darkSurfaceContainerLowest = Color(0xFF0F1113);
  static const Color darkSurfaceContainerLow = Color(0xFF1A1C1D);
  static const Color darkSurfaceContainer = Color(0xFF1E2124);
  static const Color darkSurfaceContainerHigh = Color(0xFF2A2D31);
  static const Color darkSurfaceContainerHighest = Color(0xFF33363A);
  static const Color darkOnSurface = Color(0xFFE2E2E4);
  static const Color darkOnSurfaceVariant = Color(0xFFDEC0BB);
  static const Color darkInverseSurface = Color(0xFFF0F0F2);
  static const Color darkInverseOnSurface = Color(0xFF1A1C1D);
  static const Color darkOutline = Color(0xFF8B716D);
  static const Color darkOutlineVariant = Color(0xFF534341);
  static const Color darkSurfaceTint = Color(0xFFFFB4A9);
  static const Color darkPrimary = Color(0xFFFFA396);
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  static const Color darkPrimaryContainer = Color(0xFF8C251C);
  static const Color darkOnPrimaryContainer = Color(0xFFFFA396);
  static const Color darkInversePrimary = Color(0xFFA7382D);
  static const Color darkSecondary = Color(0xFFC8C6C5);
  static const Color darkOnSecondary = Color(0xFFFFFFFF);
  static const Color darkSecondaryContainer = Color(0xFF474746);
  static const Color darkOnSecondaryContainer = Color(0xFFE2DFDE);
  static const Color darkTertiary = Color(0xFFC4C6CB);
  static const Color darkOnTertiary = Color(0xFF2C3135);
  static const Color darkTertiaryContainer = Color(0xFF484B4F);
  static const Color darkOnTertiaryContainer = Color(0xFFB9BBC0);
  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkOnError = Color(0xFF690005);
  static const Color darkErrorContainer = Color(0xFF93000A);
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6);
  static const Color darkPrimaryFixed = Color(0xFFFFDAD5);
  static const Color darkPrimaryFixedDim = Color(0xFFFFB4A9);
  static const Color darkOnPrimaryFixed = Color(0xFF410001);
  static const Color darkOnPrimaryFixedVariant = Color(0xFF862118);
  static const Color darkSecondaryFixed = Color(0xFFE5E2E1);
  static const Color darkSecondaryFixedDim = Color(0xFFC8C6C5);
  static const Color darkOnSecondaryFixed = Color(0xFF1B1C1C);
  static const Color darkOnSecondaryFixedVariant = Color(0xFF474746);
  static const Color darkTertiaryFixed = Color(0xFFE0E2E7);
  static const Color darkTertiaryFixedDim = Color(0xFFC4C6CB);
  static const Color darkOnTertiaryFixed = Color(0xFF191C20);
  static const Color darkOnTertiaryFixedVariant = Color(0xFF44474B);
  static const Color darkBackground = Color(0xFF0F1113);

  static const Color darkSurfaceVariant = Color(0xFF534341);

  // Primary Brand Colors (Legacy mappings)
  static const Color primaryRed = Color(0xFF6C0C08);
  static const Color primaryRedLight = Color(0xFF8C251C);

  // Dark Theme Primary (Legacy mappings)
  static const Color darkPrimaryRed = darkPrimary;

  // Neutral Palette
  static const Color textPrimary = Color(0xFF1A1C1D);
  static const Color textSecondary = Color(0xFF5F5E5E);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Dark Theme Text
  static const Color darkTextPrimary = darkOnSurface;
  static const Color darkTextSecondary = darkOnSurfaceVariant;

  // Background Colors
  static const Color backgroundPrimary = Color(0xFFF9F9FB);
  static const Color backgroundSecondary = Color(0xFFFFFFFF);
  static const Color backgroundTertiary = Color(0xFFF3F3F5);

  // Dark Theme Background Colors
  static const Color darkBackgroundPrimary = darkBackground;
  static const Color darkBackgroundSecondary = darkSurface;
  static const Color darkBackgroundTertiary = darkSurfaceContainer;

  // Border Colors
  static const Color borderPrimary = Color(0xFFDEC0BB);
  static const Color borderSecondary = Color(0xFFE2DFDE);

  // Dark Theme Border Colors
  static const Color darkBorderPrimary = darkOutlineVariant;
  static const Color darkBorderSecondary = darkSurfaceContainerHighest;

  // Glassmorphism
  static const Color glassBackground = Color(0xCCF8FAFC); // rgba(248,250,252,0.8)
  static const Color modalBackdrop = Color(0x1A1A1C1D); // rgba(26,28,29,0.1)

  // Dark Theme Glassmorphism
  static const Color darkGlassBackground = Color(0xCC121416); // darkSurface with opacity

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryRed, primaryRedLight],
  );

  // Status Colors (for deadlines, alerts, etc.)
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);

  // Story Colors
  static const Color storyBackground = Color(0xFFFFEBEE);
  static const Color storyViewed = Color(0xFFE0E0E0);

  // Dark Theme Story Colors
  static const Color darkStoryBackground = darkSurfaceContainerHigh;
  static const Color darkStoryViewed = darkSurfaceContainerHighest;

  // Additional UI Colors
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFFE2E2E4);
  static const Color iconGray = Color(0xFF9E9E9E);

  // Dark Theme Additional UI Colors
  static const Color darkLightGray = darkSurfaceContainerHigh;
  static const Color darkMediumGray = darkSurfaceContainerHighest;
  static const Color darkIconGray = darkOnSurfaceVariant;

  // Shadows
  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primaryRed.withOpacity(0.2),
      blurRadius: 15,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: primaryRed.withOpacity(0.2),
      blurRadius: 6,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 50,
      offset: const Offset(0, 25),
    ),
  ];

  static List<BoxShadow> get toggleShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];
}