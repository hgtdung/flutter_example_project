import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example_project/features/main_screen/main_screen.dart';


class Routes {
  Routes._();
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch(routeSettings.name) {
      case "/":  return MaterialPageRoute(builder: (context) => MainScreen());

      default: return MaterialPageRoute(builder: (context) => MainScreen());
    }
  }



}