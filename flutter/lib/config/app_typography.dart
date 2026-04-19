import 'package:flutter/material.dart';

/// Design System Typography - "The Academic Curator"
/// Manrope for headings, Inter for body text
class AppTypography {
  AppTypography._();

  // Manrope - Headings
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 20,
    fontWeight: FontWeight.w700, // Bold
    height: 1.4, // 28px line height
    letterSpacing: -0.5,
    color: Color(0xFF1A1C1D),
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.3,
    color: Color(0xFF1A1C1D),
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.5,
    color: Color(0xFF1A1C1D),
  );

  // Inter - Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5, // 24px line height
    color: Color(0xFF1A1C1D),
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    height: 1.43, // 20px line height
    color: Color(0xFF1A1C1D),
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33, // 16px line height
    color: Color(0xFF5F5E5E),
  );

  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.33,
    letterSpacing: 1.2,
    color: Color(0xFF5F5E5E),
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.5, // 15px line height
    letterSpacing: 2.0,
    color: Color(0xFF5F5E5E),
  );

  // Button Text
  static const TextStyle button = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.5,
    color: Colors.white,
  );

  // Placeholder Text
  static const TextStyle placeholder = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Color(0xFF94A3B8),
  );
}
