import 'package:flutter/material.dart';

import 'app_color.dart';

class TChipTheme {
  static ChipThemeData lightChipTheme = const ChipThemeData(
    disabledColor: AppColors.grey,
    labelStyle:  TextStyle(color: Colors.black),
    selectedColor:  Colors.blue,
    padding:  EdgeInsets.symmetric(horizontal: 12),
    checkmarkColor: Colors.white
  );

  ///TODO
  static ChipThemeData darkChipTheme = const ChipThemeData(
      disabledColor: AppColors.grey,
      labelStyle:  TextStyle(color: Colors.black),
      selectedColor:  Colors.blue,
      padding:  EdgeInsets.symmetric(horizontal: 12),
      checkmarkColor: Colors.white
  );
}