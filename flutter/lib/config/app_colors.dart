import 'package:flutter/material.dart';

/// Design System Colors - "The Academic Curator"
/// Based on Figma design: node-id 1:21197
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primaryRed = Color(0xFF6C0C08);
  static const Color primaryRedLight = Color(0xFF8C251C);

  // Neutral Palette
  static const Color textPrimary = Color(0xFF1A1C1D);
  static const Color textSecondary = Color(0xFF5F5E5E);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Background Colors
  static const Color backgroundPrimary = Color(0xFFF9F9FB);
  static const Color backgroundSecondary = Color(0xFFFFFFFF);
  static const Color backgroundTertiary = Color(0xFFF3F3F5);

  // Border Colors
  static const Color borderPrimary = Color(0xFFDEC0BB);
  static const Color borderSecondary = Color(0xFFE2DFDE);

  // Glassmorphism
  static const Color glassBackground = Color(0xCCF8FAFC); // rgba(248,250,252,0.8)
  static const Color modalBackdrop = Color(0x1A1A1C1D); // rgba(26,28,29,0.1)

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryRed, primaryRedLight],
  );

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
