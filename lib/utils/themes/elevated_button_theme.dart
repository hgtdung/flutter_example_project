import 'package:flutter/material.dart';
import 'package:flutter_example_project/utils/themes/app_color.dart';
import 'package:google_fonts/google_fonts.dart';


class TElevatedButtonTheme {
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.orange80,
          disabledBackgroundColor: AppColors.grey70,
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          textStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.notoSansKr().fontFamily)));

  /// todo implements
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.orange80,
          disabledBackgroundColor: AppColors.grey70,
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 7, top: 6),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          textStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.notoSansKr().fontFamily)));
}
