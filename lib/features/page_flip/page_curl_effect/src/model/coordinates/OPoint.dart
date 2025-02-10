import 'dart:math';

import 'FPoint.dart';


/// Oxy coordinates point
class OPoint extends Point<double> {
  OPoint(super.x, super.y);

  FPoint toFPoint() {
    return FPoint(x, -y);
  }

}

