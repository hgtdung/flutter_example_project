

import 'dart:math';

import 'package:flutter_example_project/features/page_flip/page_curl_effect/model/coordinates/FPoint.dart';

/// Oxy coordinates point
class OPoint extends Point<double> {
  OPoint(super.x, super.y);

  FPoint toFPoint() {
    return FPoint(x, -y);
  }

}

