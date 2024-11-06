import 'package:flutter/material.dart';
import 'package:flutter_example_project/utils/themes/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

class TElevatedButtonIconTheme {
  static final lightElevatedButtonIconTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.orange80,
          backgroundColor: AppColors.orange30,
          disabledBackgroundColor: AppColors.grey70,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          textStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.notoSansKr().fontFamily)));

  /// todo implements
  static final darkElevatedButtonIconTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.orange80,
          disabledBackgroundColor: AppColors.grey70,
          padding:
          const EdgeInsets.only(left: 10, right: 10, bottom: 7, top: 6),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          textStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.notoSansKr().fontFamily)));
}
