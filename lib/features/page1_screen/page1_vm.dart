

import 'dart:async';

import 'package:flutter_example_project/features/base/base_viewmodel.dart';

import 'dart:math';


class Page1VM extends BaseViewmodel {

  final  _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final _rnd = Random();


  String randomText = "Random string";
  Timer? timerCancelable;

  void changeText(int second) {
    timerCancelable= Timer.periodic( Duration(milliseconds: second), (timer) {
      randomText = getRandomString(10);
      notifyListeners();
    });

  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  void dispose() {
    timerCancelable?.cancel();
    super.dispose();
  }

}