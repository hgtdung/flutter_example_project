import 'package:flutter/cupertino.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/constants.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/model/coordinates/FPoint.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/model/coordinates/OPoint.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/model/cylinder.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/state_management/state/horizontal_page_curl.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/state_management/state/middle_paper_curl.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/page_curl_math/page_curl_math.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/state_management/events/page_curl_events.dart';
import 'dart:math';

import 'package:flutter_example_project/features/page_flip/page_curl_effect/state_management/state/page_curl_state.dart';

class PageCurlController extends ChangeNotifier {
  final double PAGE_LEFT_LIMIT = 50;

  /// Size of the page
  final Size paperSize;

  int pageCurlIndex;
  final int numberOfPage;

  PageCurlController(this.paperSize,
      {required this.pageCurlIndex, required this.numberOfPage});

  /// The place where user touches to the screen
  FPoint? startPoint;

  /// Pointer point for calculating the distance from start point
  FPoint? touchPoint;

  /// The cylinder that represents the transition of the page
  double newCylinderAngle = 0;
  Cylinder? cylinder;
  Cylinder? lastCylinder;

  /// Represent the fold point of the corner of the page
  FPoint? bottomCornerPoint;
  FPoint? topCornerPoint;

  /// Degree that make perpendicular edge of the page
  /// Using to calculate  fold point of the upper or lower page curl
  double? perpendicularDegree;

  /// Middle curl will be draw by Conic Bezier Curve, find Conic Bezier weight and T
  double? conicTStartFallingAnglePoint;
  double? conicTStartRisingAngle;
  double? conicT;
  double? conicWeight;

  /// User event
  PageCurlEvent pageCurlEvent = SketchEvent();

  /// Page curl state
  PageCurlState pageCurlState = SketchState();

  /// Two curl of the page
  MiddlePageCurl? middlePageCurl;
  HorizontalPageCurl? horizontalPageCurl;

  void onPanStart(DragStartDetails dragStartDetails) {}

  void onPanEnd(DragEndDetails dragEndDetails) {
    reset();
    notifyListeners();
  }

  void reset() {
    startPoint = null;
    touchPoint = null;
    cylinder = null;

    perpendicularDegree = null;

    conicTStartFallingAnglePoint = null;
    conicTStartRisingAngle = null;
    conicT = null;
    conicWeight = null;

    pageCurlEvent = SketchEvent();
    pageCurlState = SketchState();
  }

  void onCompleteTurnPage() {
    reset();
  }

  void onPanUpdate(DragUpdateDetails dragUpdateDetails) {
    cylinder ??= Cylinder.from(dragUpdateDetails.localPosition, 10, paperSize);

    touchPoint = FPoint(
        dragUpdateDetails.localPosition.dx, dragUpdateDetails.localPosition.dy);
    startPoint = startPoint ?? touchPoint;
    newCylinderAngle = calculateAngle(startPoint!, touchPoint!);
    publishingEvents(cylinder!, newCylinderAngle, dragUpdateDetails);
    onEvents(touchPoint!, cylinder!, newCylinderAngle);

    lastCylinder = cylinder;
  }

  void onAutoPanUpdate(Offset touchPointOffset) {
    touchPoint = FPoint(touchPointOffset.dx, touchPointOffset.dy);
    startPoint = startPoint ?? touchPoint;
    newCylinderAngle = calculateAngle(startPoint!, touchPoint!);
    pageCurlEvent = CurlNormalEvent();
    onEvents(touchPoint!, cylinder!, newCylinderAngle);

    lastCylinder = cylinder;
  }

  void publishingEvents(
      Cylinder cylinder, double newAngle, DragUpdateDetails dragDetail) {
    if (cylinder.bottomRight.x < PAGE_LEFT_LIMIT &&
            newAngle >= PCConstants.MAXIMUM_ANGLE ||
        cylinder.topRight.x < PAGE_LEFT_LIMIT &&
            newAngle <= -PCConstants.MAXIMUM_ANGLE) {
      pageCurlEvent = CurlFreezeEvent();
      return;
    }

    /// Curl normal state
    if ((newAngle > 0 &&
            cylinder.bottomRight.x.round() > PAGE_LEFT_LIMIT &&
            newAngle < PCConstants.MAXIMUM_ANGLE) ||
        (newAngle < 0 &&
            cylinder.topRight.x.round() > PAGE_LEFT_LIMIT &&
            newAngle > -PCConstants.MAXIMUM_ANGLE)) {
      pageCurlEvent = CurlNormalEvent();
    } else if ((newAngle > 0 &&
            cylinder.bottomRight.x < PAGE_LEFT_LIMIT &&
            newAngle <= PCConstants.MAXIMUM_ANGLE) ||
        (newAngle < 0 &&
            cylinder.topRight.x < PAGE_LEFT_LIMIT &&
            newAngle >= -PCConstants.MAXIMUM_ANGLE)) {
      /// Curl edge state
      if (pageCurlEvent is! CurlEdgeEvent) {
        pageCurlEvent = CurlEdgeEvent(
            leftLimitationAngle: newAngle,
            newPivot: newAngle > 0
                ? FPoint(PAGE_LEFT_LIMIT, paperSize.height)
                : FPoint(PAGE_LEFT_LIMIT, 0));
      }
      if (dragDetail.delta.dx > 0 ||
          dragDetail.delta.dy < 0 ||
          dragDetail.delta.dy > 0) {
        if (newAngle.abs() <
            (pageCurlEvent as CurlEdgeEvent).leftLimitationAngle.abs()) {
          pageCurlEvent = CurlNormalEvent();
        }
      }
    } else if (newAngle == 0) {
      pageCurlEvent = CurlNormalEvent();
    }
  }

  void onEvents(FPoint touchPoint, Cylinder cylinder, double newCylinderAngle) {
    var cylinderRange = (paperSize.width - touchPoint.x) / pi;
    var noRotateCylinder = cylinder.updateRange(touchPoint, cylinderRange);

    switch (pageCurlEvent) {
      case CurlEdgeEvent(
          leftLimitationAngle: double _,
          newPivot: FPoint newPivot
        ):
        {
          var offset = (PAGE_LEFT_LIMIT -
                  (newCylinderAngle > 0
                      ? noRotateCylinder.bottomRight.x
                      : noRotateCylinder.topRight.x))
              .abs();
          var translatedCylinder = noRotateCylinder.translateXby(offset);

          /// State update
          var newCylinder =
              translatedCylinder.rotateBy(newCylinderAngle, newPivot: newPivot);
          createTwoPageCurls(newCylinder, noRotateCylinder, touchPoint);
          this.cylinder = newCylinder;
          notifyListeners();
        }
      case CurlNormalEvent():
        {
          var newCylinder =
              noRotateCylinder.rotateBy(newCylinderAngle, newPivot: touchPoint);

          /// State update
          createTwoPageCurls(newCylinder, noRotateCylinder, touchPoint);
          this.cylinder = newCylinder;
          pageCurlState = CurlNormalState();
          notifyListeners();
        }

      case CurlFreezeEvent():
        {
          pageCurlState = CurlFreezeState();
        }
      case SketchEvent():
        {
          pageCurlState = SketchState();
          horizontalPageCurl = null;
          middlePageCurl = null;
          this.cylinder = null;
          notifyListeners();
        }
    }
  }

  void createTwoPageCurls(
    Cylinder newCylinder,
    Cylinder noRotateCylinder,
    FPoint touchPoint,
  ) {
    bottomCornerPoint = findBottomCornerPoints(newCylinder, noRotateCylinder,
        touchPoint, newCylinder.range, newCylinderAngle);
    topCornerPoint = findTopCornerPoint(newCylinder, noRotateCylinder,
        touchPoint, newCylinder.range, newCylinderAngle);

    var horizontalCurlEndPoint =
        newCylinderAngle > 0 ? bottomCornerPoint : topCornerPoint;
    var horizontalCurlFoldPoint = findHorizontalCurlFoldPoint(
        newCylinder, lastCylinder, horizontalCurlEndPoint, newCylinderAngle);
    var horizontalCurlBezierStartPoint =
        findHorizontalCurlBezierStartPoint(newCylinderAngle, newCylinder);

    if (newCylinder.angle != 0) {
      horizontalPageCurl = HorizontalPageCurl(
          startPoint: horizontalCurlBezierStartPoint!,
          foldPoint: horizontalCurlFoldPoint!,
          endPoint: horizontalCurlEndPoint!);

      middlePageCurl = createMiddlePageCurl(touchPoint, horizontalCurlEndPoint!,
          topCornerPoint!, bottomCornerPoint!, newCylinderAngle, newCylinder);
    } else {
      horizontalPageCurl = null;
      middlePageCurl = null;
    }
  }

  FPoint? findBottomCornerPoints(
    Cylinder cylinder,
    Cylinder noRotateCylinder,
    FPoint touchPoint,
    double cylinderRange,
    double newAngle,
  ) {
    /// Angle > 0, corner point at the bot of the page
    if (newAngle >= 0) {
      var bottomCornerToMiddle =
          ((paperSize.width - touchPoint.x) / 2) - cylinderRange;

      return PCMath.findSymmetricPoint(
              OPoint(paperSize.width, -paperSize.height),
              OPoint(cylinder.bottomRight.x + bottomCornerToMiddle,
                  -cylinder.bottomRight.y),
              OPoint(cylinder.topRight.x + bottomCornerToMiddle,
                  -cylinder.topRight.y))
          .toFPoint();
    } else {
      var topCornerToMiddle =
          ((paperSize.width - touchPoint.x) / 2) - cylinderRange;
      var bottomCornerToMiddle = PCMath.mapValue(
          cylinder.centerBottom.x,
          noRotateCylinder.centerBottom.x,
          paperSize.width,
          topCornerToMiddle,
          0);

      if (bottomCornerToMiddle > 0) {
        var originBottomCornerPoint = PCMath.findSymmetricPoint(
            OPoint(paperSize.width, -paperSize.height),
            OPoint(cylinder.bottomRight.x + bottomCornerToMiddle,
                -cylinder.bottomRight.y),
            OPoint(cylinder.topRight.x + bottomCornerToMiddle,
                -cylinder.topRight.y));

        return PCMath.findIntersectionWithHorizontalLine(
                originBottomCornerPoint,
                cylinder.topRight.toOrigin(),
                -paperSize.height)!
            .toFPoint();
      } else {
        return FPoint(paperSize.width, paperSize.height);
      }
    }
  }

  FPoint? findTopCornerPoint(
    Cylinder cylinder,
    Cylinder noRotateCylinder,
    FPoint touchPoint,
    double cylinderRange,
    double newAngle,
  ) {
    /// Angle < 0, corner point at the top of the page
    if (newAngle <= 0) {
      var topCornerToMiddle =
          ((paperSize.width - touchPoint.x) / 2) - cylinderRange;

      return PCMath.findSymmetricPoint(
              OPoint(paperSize.width, 0),
              OPoint(cylinder.bottomRight.x + topCornerToMiddle,
                  -cylinder.bottomRight.y),
              OPoint(cylinder.topRight.x + topCornerToMiddle,
                  -cylinder.topRight.y))
          .toFPoint();
    } else if (newAngle > 0) {
      var bottomCornerToMiddle =
          ((paperSize.width - touchPoint.x) / 2) - cylinderRange;
      var topCornerToMiddle = PCMath.mapValue(
          cylinder.centerTop.x,
          noRotateCylinder.centerTop.x,
          paperSize.width,
          bottomCornerToMiddle,
          0);

      if (topCornerToMiddle > 0) {
        var originTopCorner = PCMath.findSymmetricPoint(
            OPoint(paperSize.width, 0),
            OPoint(cylinder.bottomRight.x + topCornerToMiddle,
                -cylinder.bottomRight.y),
            OPoint(
                cylinder.topRight.x + topCornerToMiddle, -cylinder.topRight.y));

        return PCMath.findIntersectionWithHorizontalLine(
                originTopCorner, cylinder.bottomRight.toOrigin(), 0)!
            .toFPoint();
      } else {
        return FPoint(paperSize.width, 0);
      }
    } else {
      return null;
    }
  }

  FPoint? findHorizontalCurlFoldPoint(Cylinder cylinder, Cylinder? lastCylinder,
      FPoint? horizontalCurlEndPoint, double newCylinderAngle) {
    if (newCylinderAngle == 0 ||
        lastCylinder == null ||
        horizontalCurlEndPoint == null) {
      return null;
    }

    if (newCylinderAngle > 0 &&
            horizontalCurlEndPoint.y < cylinder.topRight.y ||
        newCylinderAngle < 0 &&
            horizontalCurlEndPoint.y > cylinder.bottomRight.y) {
      perpendicularDegree ?? newCylinderAngle.abs();
    } else {
      perpendicularDegree = null;
    }

    double runValue;
    if (perpendicularDegree == null) {
      /// Map value from [0, perpendicularDegree] to [0,30]
      runValue = ((cylinder.angle.abs()) * 30) / PCConstants.MAXIMUM_ANGLE;
    } else {
      /// Map value from [perpendicularDegree, maximumDegree] to [lastRunValue, 20]
      var lastRunValue =
          ((lastCylinder.angle.abs()) * 30) / PCConstants.MAXIMUM_ANGLE;
      runValue = ((cylinder.angle.abs() - perpendicularDegree!) /
                  (PCConstants.MAXIMUM_ANGLE - perpendicularDegree!)) *
              (20 - lastRunValue) +
          lastRunValue;
    }

    /// Offset of horizontal line
    var m = newCylinderAngle < 0 ? -runValue : (-paperSize.height + runValue);
    return PCMath.findIntersectionWithHorizontalLine(
            cylinder.bottomRight.toOrigin(), cylinder.topRight.toOrigin(), m)!
        .toFPoint();
  }

  FPoint? findHorizontalCurlBezierStartPoint(double degree, Cylinder cylinder) {
    if (degree == 0) {
      return null;
    }

    var horizontalCurlStartPoint =
        cylinder.angle > 0 ? cylinder.centerBottom : cylinder.centerTop;

    if (horizontalCurlStartPoint.x < PAGE_LEFT_LIMIT) {
      horizontalCurlStartPoint =
          FPoint(PAGE_LEFT_LIMIT, horizontalCurlStartPoint.y);
    }
    return horizontalCurlStartPoint;
  }

  MiddlePageCurl? createMiddlePageCurl(
      FPoint touchPoint,
      FPoint horizontalCurlBezierEndPoint,
      FPoint topCornerPoint,
      FPoint bottomCornerPoint,
      double newCylinderAngle,
      Cylinder cylinder) {
    if (newCylinderAngle == 0) {
      return null;
    }

    FPoint? controlPointAnchor = PCMath.twoLineIntersection(
            OPoint(touchPoint.x, 0),
            OPoint(touchPoint.x, -paperSize.height),
            horizontalCurlBezierEndPoint.toOrigin(),
            (newCylinderAngle > 0 ? cylinder.topRight : cylinder.bottomRight)
                .toOrigin())
        ?.toFPoint();

    /// Corner point go to less than touchPoint.x
    controlPointAnchor ??= horizontalCurlBezierEndPoint;

    FPoint bezierEnd;
    if (newCylinderAngle > 0) {
      if (cylinder.topRight.x < paperSize.width) {
        if (topCornerPoint.x < cylinder.topRight.x) {
          bezierEnd = topCornerPoint;
        } else {
          bezierEnd = cylinder.topRight;
        }
      } else {
        if (cylinder.centerTop.x < paperSize.width) {
          bezierEnd = FPoint(paperSize.width, 0);
        } else {
          bezierEnd = cylinder.centerTop;
        }
      }
    } else {
      if (cylinder.bottomRight.x < paperSize.width) {
        if (bottomCornerPoint.x < cylinder.bottomRight.x) {
          bezierEnd = bottomCornerPoint;
        } else {
          bezierEnd = cylinder.bottomRight;
        }
      } else {
        if (cylinder.centerBottom.x < paperSize.width) {
          bezierEnd = FPoint(paperSize.width, paperSize.height);
        } else {
          bezierEnd = cylinder.centerBottom;
        }
      }
    }

    FPoint bezierControlPoint = PCMath.findPointOnPerpendicularBisector(
            controlPointAnchor.toOrigin(),
            bezierEnd.toOrigin(),
            30,
            newCylinderAngle > 0 ? false : true)!
        .toFPoint();

    /// Recalculate Conic weight and Conic T
    calculateConicCurveFactors(newCylinderAngle, cylinder, bezierEnd);

    var pageCurl = MiddlePageCurl(
        startPoint: horizontalCurlBezierEndPoint,
        controlPoint: bezierControlPoint,
        endPoint: bezierEnd,
        weight: conicWeight!,
        endT: conicT!);
    return pageCurl;
  }

  void calculateConicCurveFactors(
      double newCylinderAngle, Cylinder cylinder, FPoint bezierEnd) {
    conicWeight = PCMath.mapValue(
        newCylinderAngle.abs(), 0, PCConstants.MAXIMUM_ANGLE, 1, 4);

    /// Conic T starts falling
    if ((cylinder.topRight.x == bezierEnd.x) ||
        cylinder.bottomRight.x == bezierEnd.x) {
      conicTStartFallingAnglePoint ??=
          newCylinderAngle > 0 ? cylinder.centerTop.x : cylinder.center.x;
    } else if (bezierEnd.x < cylinder.topRight.x &&
            cylinder.topRight.x < paperSize.width ||
        bezierEnd.x < cylinder.bottomRight.x &&
            cylinder.bottomRight.x < paperSize.width) {
      conicTStartFallingAnglePoint = null;
    }

    /// Conic T starts rising
    if ((cylinder.centerTop.x == paperSize.width) ||
        cylinder.centerBottom.x == paperSize.width) {
      conicTStartRisingAngle ??= newCylinderAngle.abs();
    } else if (cylinder.topRight.x <= paperSize.width && newCylinderAngle > 0 ||
        cylinder.bottomRight.x <= paperSize.width && newCylinderAngle < 0) {
      conicTStartRisingAngle = null;
    }

    /// Calculate Conic T and Conic Weight
    if (conicTStartFallingAnglePoint != null &&
        conicTStartRisingAngle == null &&
        cylinder.centerTop.x < paperSize.width) {
      var mapRange = paperSize.width - conicTStartFallingAnglePoint!;
      var mapValue =
          newCylinderAngle > 0 ? cylinder.centerTop.x : cylinder.centerBottom.x;

      /// Reverse direction, the mapValue may go lower than conicTStartFallingAnglePoint lower point
      if (mapRange == 0 || mapValue < conicTStartFallingAnglePoint!) {
        conicT = 1;
      } else {
        conicT = PCMath.mapValue(
            mapValue, conicTStartFallingAnglePoint!, paperSize.width, 1, 0.6);
      }
    } else if (conicTStartFallingAnglePoint != null &&
        conicTStartRisingAngle != null) {
      conicT = PCMath.mapValue(newCylinderAngle.abs(),
          conicTStartRisingAngle!.abs(), PCConstants.MAXIMUM_ANGLE, 0.6, 0.9);

      /// Multi by 2 to increase the acceleration
      conicWeight = 2 *
          PCMath.mapValue(newCylinderAngle.abs(), conicTStartRisingAngle!.abs(),
              PCConstants.MAXIMUM_ANGLE, 1, 4);
      conicWeight = conicWeight! >= 4 ? 4 : conicWeight;
    } else {
      conicT = 0.99;
    }
  }

  /// TODO: find another k that make transition the same 3D
  double calculateAngle(FPoint startPoint, FPoint touchPoint) {
    /// calculate rotation angle
    var dy = startPoint.y - touchPoint.y;
    var dx = startPoint.x - touchPoint.x;
    var degree = 0.0;
    // The greater dx, the less kRotation
    var kxRotation = PCMath.mapRange2Range(
        value: dx, oldMin: 0, oldMax: paperSize.width, newMin: 1, newMax: 0.1);
    degree = dy * kxRotation;

    var kyRotation = PCMath.mapRange2Range(
        value: dy,
        oldMin: 0,
        oldMax: paperSize.height,
        newMin: 1,
        newMax: 0.005);
    degree = degree * kyRotation;
    var kDegree = degree > 0 ? 1.0 : -1.0;

    /// Todo handle PCConstants.MAXIMUM_ANGLE on Ipad
    if (degree.abs() > PCConstants.MAXIMUM_ANGLE) {
      degree = PCConstants.MAXIMUM_ANGLE * kDegree;
    }
    return degree;
  }

  void turnPageAnimation() {
    /// touch point move to (0, y);
  }
}
