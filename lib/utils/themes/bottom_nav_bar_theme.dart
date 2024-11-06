import 'package:flutter/material.dart';
import 'package:flutter_example_project/utils/themes/app_color.dart';

class TBottomNavBarTheme {
  TBottomNavBarTheme._();


  static BottomNavigationBarThemeData bottomNavigationBarThemeData = const BottomNavigationBarThemeData(
    backgroundColor: AppColors.white,
    selectedItemColor: AppColors.orange80,
    unselectedItemColor: AppColors.grey40Blue10,
  );
}