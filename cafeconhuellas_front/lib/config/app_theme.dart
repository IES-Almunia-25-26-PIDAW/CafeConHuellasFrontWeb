import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:flutter/material.dart';


class AppTheme {
  ThemeData getTheme() {

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.vanilla,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.purple,
        primary: AppColors.purple,
        secondary: AppColors.lavender,
      ),

      cardTheme: const CardThemeData(
        color: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.darkPurple,
      ),
    );
  }
}