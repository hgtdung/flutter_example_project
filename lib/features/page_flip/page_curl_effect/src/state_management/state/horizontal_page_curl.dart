
import 'package:flutter_example_project/features/page_flip/page_curl_effect/src/model/coordinates/FPoint.dart';

/// Page curl will be drawn by Quadratic Bezier curve and Conic Bezier curve
class HorizontalPageCurl {
  FPoint startPoint;
  FPoint foldPoint;
  FPoint endPoint;


  HorizontalPageCurl({
    required this.startPoint,
    required this.foldPoint,
    required this.endPoint,
  });
}