import 'package:flutter_example_project/features/page_flip/page_curl_effect/model/coordinates/FPoint.dart';

/// Page curl will be drawn by Quadratic Bezier curve and Conic Bezier curve
class MiddlePageCurl {
  FPoint startPoint;
  FPoint controlPoint;
  FPoint endPoint;

  double weight;

  /// for drawn part of curve
  double endT;

  MiddlePageCurl({
    required this.startPoint,
    required this.controlPoint,
    required this.endPoint,
    required this.weight,
    required this.endT
  });
}