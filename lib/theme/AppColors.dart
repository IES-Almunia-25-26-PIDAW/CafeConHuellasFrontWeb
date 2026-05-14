import 'package:flutter/material.dart';

/// Centralized application color palette.
///
/// This class contains all reusable colors used
/// throughout the application UI in order to:
/// - Maintain visual consistency.
/// - Simplify theme management.
/// - Avoid duplicated color values.
///
/// Colors are grouped into:
/// - Primary colors.
/// - Secondary colors.
/// - Neutral colors.
class AppColors {
  // Primary colors
  /// Main dark violet color used for
  /// headers, titles, and primary UI elements.
  static const darkViolet = Color(0xFF33233D);
  /// Dark purple accent color used for
  /// buttons and highlighted sections.
  static const darkPurple = Color(0xFF7D4D73);
  /// Standard purple color used across
  /// interactive components.
  static const purple = Color(0xFFB78AB1);
  /// Soft lavender tone used for
  /// backgrounds and decorative elements.
  static const lavender = Color(0xFFD0B1C3);
  /// Light pink color used for
  /// subtle UI accents and backgrounds.
  static const pink = Color(0xFFF8D9E2);
  // Secondary colors
  /// Denim blue accent color.
  static const denimBlue = Color(0xFF326F7D);
  /// Dark charcoal color used for
  /// text and dark UI sections.
  static const charcoal = Color(0xFF313949);
  /// Green tone used for success states
  /// and natural-themed components.
  static const green = Color(0xFF6C7F61);
  /// Light green accent color.
  static const lightGreen = Color(0xFF7EA06B);
  // Neutral colors
  /// Pure white color.
  static const white = Color(0xFFFFFFFF);
  /// Pure black color.
  static const black = Color(0xFF000000);
  /// Brown accent color.
  static const brown = Color(0xFF5E5248);
  /// Neutral gray color used for
  /// secondary text and borders.
  static const gray = Color(0xFF76726E);
  /// Beige tone used for soft backgrounds.
  static const beige = Color(0xFFC1B7AB);
  /// Cream color used in cards,
  /// borders, and containers.
  static const cream = Color(0xFFE6D9C7);
  /// Vanilla background color used
  /// for light UI sections.
  static const vanilla = Color(0xFFFAF4F0);
}