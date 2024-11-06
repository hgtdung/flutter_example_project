import 'package:flutter/material.dart';

import 'app_color.dart';

class TCheckBoxTheme {
  TCheckBoxTheme._();

  static CheckboxThemeData lightCheckBoxThemeData = CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      checkColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.orange80;
          } else {
            return AppColors.black;
          }
        },
      ),
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.orange80;
          } else {
            return AppColors.black;
          }
        },
      ));

  ///TODO later
  static CheckboxThemeData darkCheckBoxThemeData = CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      checkColor: WidgetStateProperty.resolveWith(
            (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.orange80;
          } else {
            return AppColors.black;
          }
        },
      ),
      fillColor: WidgetStateProperty.resolveWith(
            (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.orange80;
          } else {
            return AppColors.black;
          }
        },
      ));
}
