import 'package:flutter/material.dart';

/// Design System Colors - "The Academic Curator"
/// Based on Figma design: node-id 1:21197
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primaryRed = Color(0xFF6C0C08);
  static const Color primaryRedLight = Color(0xFF8C251C);

  // Dark Theme Primary
  static const Color darkPrimaryRed = Color(0xFFB35A52);
  static const Color darkPrimaryRedLight = Color(0xFFCC7A72);

  // Neutral Palette
  static const Color textPrimary = Color(0xFF1A1C1D);
  static const Color textSecondary = Color(0xFF5F5E5E);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Dark Theme Text
  static const Color darkTextPrimary = Color(0xFFF3F4F6);
  static const Color darkTextSecondary = Color(0xFFB0B3B8);
  static const Color darkTextTertiary = Color(0xFF8A9099);

  // Background Colors
  static const Color backgroundPrimary = Color(0xFFF9F9FB);
  static const Color backgroundSecondary = Color(0xFFFFFFFF);
  static const Color backgroundTertiary = Color(0xFFF3F3F5);

  // Dark Theme Background Colors
  static const Color darkBackgroundPrimary = Color(0xFF121315);
  static const Color darkBackgroundSecondary = Color(0xFF1A1C1D);
  static const Color darkBackgroundTertiary = Color(0xFF23262A);

  // Border Colors
  static const Color borderPrimary = Color(0xFFDEC0BB);
  static const Color borderSecondary = Color(0xFFE2DFDE);

  // Dark Theme Border Colors
  static const Color darkBorderPrimary = Color(0xFF4A2D2A);
  static const Color darkBorderSecondary = Color(0xFF34373B);

  // Glassmorphism
  static const Color glassBackground = Color(0xCCF8FAFC); // rgba(248,250,252,0.8)
  static const Color modalBackdrop = Color(0x1A1A1C1D); // rgba(26,28,29,0.1)

  // Dark Theme Glassmorphism
  static const Color darkGlassBackground = Color(0xCC1A1C1D);
  static const Color darkModalBackdrop = Color(0x66121315);

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
  static const Color storyUnviewed = primaryRed;

  // Dark Theme Story Colors
  static const Color darkStoryBackground = Color(0xFF3A2524);
  static const Color darkStoryViewed = Color(0xFF4A4A4A);
  static const Color darkStoryUnviewed = darkPrimaryRed;

  // Additional UI Colors
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFFE2E2E4);
  static const Color iconGray = Color(0xFF9E9E9E);

  // Dark Theme Additional UI Colors
  static const Color darkLightGray = Color(0xFF2A2D31);
  static const Color darkMediumGray = Color(0xFF3A3D41);
  static const Color darkIconGray = Color(0xFF8A9099);

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
