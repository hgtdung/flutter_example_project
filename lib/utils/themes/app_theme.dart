import 'package:flutter/material.dart';
import 'package:flutter_example_project/utils/themes/app_bar_theme.dart';
import 'package:flutter_example_project/utils/themes/app_color.dart';
import 'package:flutter_example_project/utils/themes/bottom_nav_bar_theme.dart';
import 'package:flutter_example_project/utils/themes/bottom_sheet_theme.dart';
import 'package:flutter_example_project/utils/themes/chip_theme.dart';
import 'package:flutter_example_project/utils/themes/divider_theme.dart';
import 'package:flutter_example_project/utils/themes/elevated_button_theme.dart';
import 'package:flutter_example_project/utils/themes/outlined_button_theme.dart';
import 'package:flutter_example_project/utils/themes/text_theme.dart';
import 'package:google_fonts/google_fonts.dart';

import 'text_form_field_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.notoSansKr().fontFamily,
      brightness: Brightness.light,
      primaryColor: AppColors.orange80,
      textTheme: TTextTheme.lightTextTheme,
      scaffoldBackgroundColor: AppColors.white,
      elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
      appBarTheme: TAppBarTheme.lightAppBarTheme,
      chipTheme: TChipTheme.lightChipTheme,
      inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
      dividerTheme: TDividerTheme.lightDividerThemeData,
      outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
      bottomSheetTheme: TBottomSheetTheme.lightBottomSheetThemeData,
      bottomNavigationBarTheme:
          TBottomNavBarTheme.bottomNavigationBarThemeData);

  ///TODO:
  static ThemeData dartTheme = ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.notoSansKr().fontFamily,
      brightness: Brightness.dark,
      primaryColor: AppColors.orange80,
      textTheme: TTextTheme.darkTextTheme,
      scaffoldBackgroundColor: AppColors.white,
      elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
      appBarTheme: TAppBarTheme.darkAppBarTheme);
}
