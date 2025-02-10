import 'package:flutter/material.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/src/constants.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/src/model/cylinder.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/src/page_curl_math/page_curl_math.dart';

import '../model/coordinates/FPoint.dart';
import '../state_management/state/horizontal_page_curl.dart';
import '../state_management/state/middle_paper_curl.dart';

class PageCurlPainter extends CustomPainter {
  Cylinder? nullableCylinder;
  HorizontalPageCurl? nullableHorizontalPageCurl;
  MiddlePageCurl? nullableMiddlePageCurl;

  PageCurlPainter(
      {this.nullableCylinder,
      this.nullableHorizontalPageCurl,
      this.nullableMiddlePageCurl});
  @override
  void paint(Canvas canvas, Size size) {
    if (nullableCylinder == null) {
      return;
    }

    var cylinder = nullableCylinder!;

    drawShadow(cylinder, nullableHorizontalPageCurl, nullableMiddlePageCurl,
        canvas, size);

    drawTurnPagePart(cylinder, nullableHorizontalPageCurl,
        nullableMiddlePageCurl, canvas, size);
  }

  void drawShadow(
      Cylinder cylinder,
      HorizontalPageCurl? nullableHorizontalPageCurl,
      MiddlePageCurl? nullableMiddlePageCurl,
      Canvas canvas,
      Size size) {
    var shadowPath = Path();

    if (cylinder.angle == 0) {
      shadowPath.moveTo(cylinder.topLeft.x, cylinder.topLeft.y);
      shadowPath.lineTo(cylinder.topRight.x, cylinder.topRight.y);
      shadowPath.lineTo(cylinder.bottomRight.x, cylinder.bottomRight.y);
      shadowPath.lineTo(cylinder.bottomLeft.x, cylinder.bottomLeft.y);
      shadowPath.lineTo(cylinder.topLeft.x, cylinder.topLeft.y);
    } else {
      var horizontalPageCurl = nullableHorizontalPageCurl!;
      var middlePageCurl = nullableMiddlePageCurl!;
      var conicWeight = middlePageCurl.weight!;
      var conicT = middlePageCurl.endT!;
      shadowPath.moveTo(
          horizontalPageCurl.endPoint.x, horizontalPageCurl.endPoint.y);
      if ((middlePageCurl.endPoint.x <= cylinder.topRight.x &&
              cylinder.topRight.x < size.width &&
              cylinder.angle > 0) ||
          (middlePageCurl.endPoint.x <= cylinder.bottomRight.x &&
              cylinder.bottomRight.x < size.width &&
              cylinder.angle < 0)) {
        var crossPoint = conicToCross(
            middlePageCurl.startPoint,
            middlePageCurl.controlPoint,
            middlePageCurl.endPoint,
            conicWeight,
            cylinder.topRight,
            cylinder.bottomRight,
            shadowPath);
        if (crossPoint == null) {
          cylinder.angle > 0
              ? shadowPath.lineTo(cylinder.topRight.x, cylinder.topRight.y)
              : shadowPath.lineTo(
                  cylinder.bottomRight.x, cylinder.bottomRight.y);
        }
      } else {
        for (double t = 0.0; t <= conicT; t += 0.01) {
          final point = PCMath.getPointOnConicCurve(
              t,
              middlePageCurl.startPoint,
              middlePageCurl.controlPoint,
              middlePageCurl.endPoint,
              conicWeight);
          shadowPath.lineTo(point.x, point.y);
        }
      }
      shadowPath.lineTo(
          horizontalPageCurl.foldPoint.x, horizontalPageCurl.foldPoint.y);

      /// Calculate t of the bezier curve by angle [angle, maximumAgle] => [0.5, 0.25]
      double t_c =
          0.5 - ((cylinder.angle.abs() / PCConstants.MAXIMUM_ANGLE) * 0.25);
      if (cylinder.angle.abs() > PCConstants.MAXIMUM_ANGLE / 2) {
        t_c = 0.5;
      }
      FPoint horizontalControlPoint = PCMath.calculateControlPoint(
          horizontalPageCurl.startPoint,
          horizontalPageCurl.endPoint,
          horizontalPageCurl.foldPoint,
          t_c);
      for (double t = t_c; t <= 1; t += 0.01) {
        final point = PCMath.getPointOnQuadraticCurve(
            t,
            horizontalPageCurl.startPoint,
            horizontalControlPoint,
            horizontalPageCurl.endPoint);
        shadowPath.lineTo(point.x, point.y);
      }
      shadowPath.lineTo(
          horizontalPageCurl.endPoint.x, horizontalPageCurl.endPoint.y);
    }

    /// Offset matrix for shadow
    Offset shadowOffset = Offset(-10, -10); // Move left (-10) and up (-10)
    shadowPath = shadowPath.shift(shadowOffset);

    canvas.drawShadow(
      shadowPath,
      Colors.black45,
      10.0,
      true,
    );
  }

  void drawTurnPagePart(
      Cylinder cylinder,
      HorizontalPageCurl? nullableHorizontalPageCurl,
      MiddlePageCurl? nullableMiddlePageCurl,
      Canvas canvas,
      Size size) {
    /// Turn page area
    var paint = Paint()
      ..color = const Color(0xffF6F6F6)
      // ..color = Colors.blue
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    /// border
    var borderPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (cylinder.angle == 0) {
      path.moveTo(cylinder.topLeft.x, cylinder.topLeft.y);
      path.lineTo(cylinder.topRight.x, cylinder.topRight.y);
      path.lineTo(cylinder.bottomRight.x, cylinder.bottomRight.y);
      path.lineTo(cylinder.bottomLeft.x, cylinder.bottomLeft.y);
      path.lineTo(cylinder.topLeft.x, cylinder.topLeft.y);
      canvas.drawPath(path, paint);
      canvas.drawPath(path, borderPaint);
    } else {
      var horizontalPageCurl = nullableHorizontalPageCurl!;
      var middlePageCurl = nullableMiddlePageCurl!;
      var conicWeight = middlePageCurl.weight;
      var conicT = middlePageCurl.endT;
      path.moveTo(horizontalPageCurl.endPoint.x, horizontalPageCurl.endPoint.y);

      /// draw conic curve
      if ((middlePageCurl.endPoint.x <= cylinder.topRight.x &&
              cylinder.topRight.x < size.width &&
              cylinder.angle > 0) ||
          (middlePageCurl.endPoint.x <= cylinder.bottomRight.x &&
              cylinder.bottomRight.x < size.width &&
              cylinder.angle < 0)) {
        var crossPoint = conicToCross(
            middlePageCurl.startPoint,
            middlePageCurl.controlPoint,
            middlePageCurl.endPoint,
            conicWeight,
            cylinder.topRight,
            cylinder.bottomRight,
            path);
        if (crossPoint == null) {
          cylinder.angle > 0
              ? path.lineTo(cylinder.topRight.x, cylinder.topRight.y)
              : path.lineTo(cylinder.bottomRight.x, cylinder.bottomRight.y);
        }
      } else {
        FPoint? crossOffset;
        bool wasCrossing = false;

        for (double t = 0.0; t <= conicT; t += 0.01) {
          final point = PCMath.getPointOnConicCurve(
              t,
              middlePageCurl.startPoint,
              middlePageCurl.controlPoint,
              middlePageCurl.endPoint,
              conicWeight);
          path.lineTo(point.x, point.y);

          if (crossOffset == null &&
              PCMath.isCrossingLine(point.x, point.y, cylinder.topRight,
                  cylinder.bottomRight, wasCrossing)) {
            crossOffset = point;
          }
          if (crossOffset != null && cylinder.angle.abs() < 10) {
            break;
          }
        }

        /// Fix the last t not draw to
        if (conicT == 1) {
          path.lineTo(middlePageCurl.endPoint.x, middlePageCurl.endPoint.y);
        }
      }

      path.lineTo(
          horizontalPageCurl.foldPoint.x, horizontalPageCurl.foldPoint.y);

      /// Fix t_c of Quadratic Bezier curve
      double t_c = 0.3;
      FPoint horizontalControlPoint = PCMath.calculateControlPoint(
          horizontalPageCurl.startPoint,
          horizontalPageCurl.endPoint,
          horizontalPageCurl.foldPoint,
          t_c);
      for (double t = t_c; t <= 1; t += 0.01) {
        final point = PCMath.getPointOnQuadraticCurve(
            t,
            horizontalPageCurl.startPoint,
            horizontalControlPoint,
            horizontalPageCurl.endPoint);
        path.lineTo(point.x, point.y);
      }
      path.lineTo(horizontalPageCurl.endPoint.x, horizontalPageCurl.endPoint.y);
      canvas.drawPath(path, paint);
      canvas.drawPath(path, borderPaint);
    }
  }

  FPoint? conicToCross(FPoint start, FPoint control, FPoint end,
      double conicWeight, FPoint lineStart, FPoint lineEnd, Path? path) {
    bool wasCrossing = false;

    /// Draw Conic curl manually
    for (double t = 0; t <= 1; t += 0.01) {
      var point =
          PCMath.getPointOnConicCurve(t, start, control, end, conicWeight);
      path?.lineTo(point.x, point.y);
      if (PCMath.isCrossingLine(
          point.x, point.y, lineStart, lineEnd, wasCrossing)) {
        return point;
      }
    }
    path?.lineTo(end.x, end.y);
    return null;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
