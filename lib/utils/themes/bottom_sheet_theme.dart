import 'package:flutter/material.dart';

import 'app_color.dart';

class TBottomSheetTheme {
  static BottomSheetThemeData lightBottomSheetThemeData = const BottomSheetThemeData(
    shape:  RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20)
      )
    ),
    modalBackgroundColor: AppColors.white,
    backgroundColor: AppColors.white,
    /// todo consider this attribute
    constraints:  BoxConstraints(minWidth: double.infinity)
  );

  ///todo implement later
  static BottomSheetThemeData darkBottomSheetThemeData = const BottomSheetThemeData(
      shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20)
          )
      ),
      modalBackgroundColor: AppColors.white,
      backgroundColor: AppColors.white,
      /// todo consider this attribute
      constraints:  BoxConstraints(minWidth: double.infinity)
  );
}