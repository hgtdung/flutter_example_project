import 'package:flutter/material.dart';
import 'package:flutter_example_project/utils/themes/app_color.dart';


class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
  displayLarge:  const TextStyle().copyWith(
      color: AppColors.black,
      fontSize: 16,
      fontWeight: FontWeight.w400
  ),
    titleMedium: const TextStyle().copyWith(
        color: AppColors.black90,
        fontSize: 22,
        fontWeight: FontWeight.w500
    ),
    titleSmall: const TextStyle().copyWith(
        color: AppColors.black90,
        fontSize: 20,
        fontWeight: FontWeight.w500
    ),
    bodyLarge:  const TextStyle().copyWith(
      color: AppColors.black90,
      fontSize: 14,
      fontWeight: FontWeight.w400
  ),
    bodyMedium: const TextStyle().copyWith(
        color: AppColors.black90,
        fontSize: 13,
        fontWeight: FontWeight.w500
    ),
    bodySmall: const TextStyle().copyWith(
        color: AppColors.grey70,
        fontSize: 11,
        fontWeight: FontWeight.w400
    ),
    labelMedium:  const TextStyle().copyWith(
        color: AppColors.grey70,
        fontSize: 12,
        fontWeight: FontWeight.w400
    ),

  );

  ///TODO
  static TextTheme darkTextTheme = TextTheme(
    titleMedium: const TextStyle().copyWith(
        color: AppColors.black90,
        fontSize: 22,
        fontWeight: FontWeight.w500
    ),
    bodyMedium:  const TextStyle().copyWith(
        color: AppColors.black90,
        fontSize: 13,
        fontWeight: FontWeight.w400
    ),
    bodySmall: const TextStyle().copyWith(
        color: AppColors.grey70,
        fontSize: 11,
        fontWeight: FontWeight.w400
    ),
  );
}
