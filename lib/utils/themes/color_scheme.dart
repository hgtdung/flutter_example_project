import 'package:flutter/material.dart';

import 'app_color.dart';

class TColorScheme {
  static ColorScheme lightTheme() {
    return const ColorScheme(
        primary: AppColors.orange80,
        onPrimary: AppColors.orange10,
        primaryContainer: AppColors.orange30,
        onPrimaryContainer: AppColors.orange80,
        secondary: AppColors.white,
        onSecondary: Colors.blueAccent,
        brightness: Brightness.light,
        error: AppColors.red,
        onError: AppColors.white,
        /// color for scrollable area
        surface: AppColors.white,
        /// color of card
        onSurface: AppColors.black90,
        onSurfaceVariant: AppColors.grey);
  }

  ///TODO:
  static ColorScheme darkTheme() {
    return const ColorScheme(
        primary: AppColors.orange80,
        onPrimary: AppColors.orange10,
        primaryContainer: AppColors.orange30,
        onPrimaryContainer: AppColors.orange80,
        secondary: AppColors.white,
        onSecondary: Colors.blueAccent,
        brightness: Brightness.light,
        error: AppColors.red,
        onError: AppColors.white,
        /// color for scrollable area
        surface: AppColors.white,
        /// color of card
        onSurface: AppColors.black90,
        onSurfaceVariant: AppColors.grey);
  }
}
