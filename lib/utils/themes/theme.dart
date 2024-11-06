import 'package:flutter/material.dart';

export 'app_theme.dart';

class ThemeHelper {
  ThemeHelper._();

  static TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;
}