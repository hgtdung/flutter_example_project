import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';

class TAppBarTheme {
  static AppBarTheme lightAppBarTheme = AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 50,
      titleTextStyle: TextStyle(
          fontFamily: GoogleFonts.notoSansKr().fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: AppColors.black),
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.black),
      actionsIconTheme: const IconThemeData(color: AppColors.black));

  ///TODO
  static AppBarTheme darkAppBarTheme = AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 50,
      titleTextStyle: TextStyle(
          fontFamily: GoogleFonts.notoSansKr().fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: AppColors.black),
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.black),
      actionsIconTheme: const IconThemeData(color: AppColors.black));
}
