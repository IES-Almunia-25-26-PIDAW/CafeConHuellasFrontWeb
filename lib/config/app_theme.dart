import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:flutter/material.dart';


/// Global application theme configuration.
///
/// This class centralizes the application's visual style,
/// including:
/// - colors
/// - cards
/// - typography behavior
/// - Material Design settings
class AppTheme {

  /// Builds and returns the application's main [ThemeData].
  ///
  /// Includes:
  /// - Material 3 support
  /// - custom color scheme
  /// - card styling
  /// - list tile styling
  ThemeData getTheme() {

    return ThemeData(

      /// Enables Material Design 3.
      useMaterial3: true,

      /// Default scaffold background color.
      scaffoldBackgroundColor: AppColors.vanilla,

      /// Global color scheme configuration.
      colorScheme: ColorScheme.fromSeed(

        /// Main seed color used to generate the palette.
        seedColor: AppColors.purple,

        /// Primary application color.
        primary: AppColors.purple,

        /// Secondary application color.
        secondary: AppColors.lavender,
      ),

      /// Default card appearance configuration.
      cardTheme: const CardThemeData(

        /// Card background color.
        color: AppColors.cream,

        /// Removes Material 3 surface tint effect.
        surfaceTintColor: Colors.transparent,

        /// Card shadow elevation.
        elevation: 6,

        /// Default card border radius.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
      ),

      /// Default list tile styling.
      listTileTheme: const ListTileThemeData(

        /// Default icon color for list tiles.
        iconColor: AppColors.darkPurple,
      ),
    );
  }
}