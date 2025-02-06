

import 'dart:math';

import 'package:flutter_example_project/features/page_flip/page_curl_effect/model/coordinates/OPoint.dart';

/// Flutter coordinates point
/// From left to right x = [0, size.width]
/// From top to bottom  y = [0, size.height]
class FPoint extends Point<double> {
  FPoint(super.x, super.y);

  OPoint toOrigin() {
    return OPoint(x, -y);
  }

}

