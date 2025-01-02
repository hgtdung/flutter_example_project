import 'dart:math';
import 'dart:ui';

import '2d_formular.dart';

class Chopstick {
  /// luu lai truc ox va oy xoay khi xoay quanh touch point, tu do tinh duoc dx va dy moi?
  ///
  Size paperSize;
  Offset topLeft;
  Offset topRight;
  Offset bottomLeft;
  Offset bottomRight;
  Offset center;
  double range;
  double angle;
  Offset centerTop;
  Offset centerBottom;
  Offset? pivot;
  Chopstick(
      this.paperSize,
      this.topLeft,
      this.topRight,
      this.bottomLeft,
      this.bottomRight,
      this.center,
      this.centerTop,
      this.centerBottom,
      this.range,
      this.angle,
      this.pivot);

  rotateBy(double degree,

      /// if != null, rotate around this point
      {Offset? pivot}) {
    late Offset centerOxy;
    if (pivot != null) {
      this.pivot = Offset(pivot.dx, -pivot.dy);
      centerOxy = Offset(pivot.dx, -pivot.dy);
    } else {
      centerOxy = Offset(center.dx, -center.dy);
    }
    var topLeftOxy = Offset(topLeft.dx, -topLeft.dy);
    var topRightOxy = Offset(topRight.dx, -topRight.dy);
    var bottomLeftOxy = Offset(bottomLeft.dx, -bottomLeft.dy);
    var bottomRightOxy = Offset(bottomRight.dx, -bottomRight.dy);
    var centerTopOxy = Offset(centerTop.dx, -centerTop.dy);
    var centerBottomOxy = Offset(centerBottom.dx, -centerBottom.dy);

    /// rotate
    topLeftOxy = rotateAround(topLeftOxy, centerOxy, degree);
    topRightOxy = rotateAround(topRightOxy, centerOxy, degree);
    bottomLeftOxy = rotateAround(bottomLeftOxy, centerOxy, degree);
    bottomRightOxy = rotateAround(bottomRightOxy, centerOxy, degree);
    centerTopOxy = Offset(topLeftOxy.dx + (topRightOxy.dx - topLeftOxy.dx) / 2,
        topRightOxy.dy + (topLeftOxy.dy - topRightOxy.dy) / 2);
    centerBottomOxy = Offset(
        bottomLeftOxy.dx + (bottomRightOxy.dx - bottomLeftOxy.dx) / 2,
        bottomLeftOxy.dy - (bottomLeftOxy.dy - bottomRightOxy.dy) / 2);

    /// MARK: top
    // /// Find intersection between the right chopstick line (topRight and bottomRight) and top (Ox)
    var topLeadingIntersection =
    TwoDFormula.findIntersectionWithOX(bottomLeftOxy, topLeftOxy);
    var topTrailingIntersection =
    TwoDFormula.findIntersectionWithOX(bottomRightOxy, topRightOxy);
    var topCenterIntersection =
    TwoDFormula.findIntersectionWithOX(centerBottomOxy, centerTopOxy);

    /// if overflow find intersection with vertical line zx = paperSize.width
    if (topLeadingIntersection!.dx > paperSize.width) {
      topLeadingIntersection = TwoDFormula.findIntersectionWithVerticalLine(
          bottomLeftOxy, topLeftOxy, paperSize.width);
    }

    if (topTrailingIntersection!.dx > paperSize.width) {
      topTrailingIntersection = TwoDFormula.findIntersectionWithVerticalLine(
          bottomRightOxy, topRightOxy, paperSize.width);
    }

    if (topCenterIntersection!.dx > paperSize.width) {
      topCenterIntersection = TwoDFormula.findIntersectionWithVerticalLine(
          centerTopOxy, centerBottomOxy, paperSize.width);
    }

    /// revert to dart coordinate
    topLeft = Offset(topLeadingIntersection!.dx, -topLeadingIntersection!.dy);
    topRight = Offset(topTrailingIntersection!.dx, -topTrailingIntersection.dy);
    centerTop = Offset(topCenterIntersection!.dx, -topCenterIntersection.dy);

    ///MARK: bottom
    var bottomLeadingIntersection =
    TwoDFormula.findIntersectionWithHorizontalLine(
        bottomLeftOxy, topLeftOxy, -paperSize.height);
    var bottomTrailingIntersection =
    TwoDFormula.findIntersectionWithHorizontalLine(
        bottomRightOxy, topRightOxy, -paperSize.height);
    var bottomCenterIntersection =
    TwoDFormula.findIntersectionWithHorizontalLine(
        centerTopOxy, centerBottomOxy, -paperSize.height);

    /// if overflow find intersection with vertical line x = paperSize.width
    if (bottomLeadingIntersection!.dx > paperSize.width) {
      bottomLeadingIntersection = TwoDFormula.findIntersectionWithVerticalLine(
          bottomLeftOxy, topLeftOxy, paperSize.width);
    }

    if (bottomTrailingIntersection!.dx > paperSize.width) {
      bottomTrailingIntersection = TwoDFormula.findIntersectionWithVerticalLine(
          bottomRightOxy, topRightOxy, paperSize.width);
    }

    if (bottomCenterIntersection!.dx > paperSize.width) {
      bottomCenterIntersection = TwoDFormula.findIntersectionWithVerticalLine(
          centerTopOxy, centerBottomOxy, paperSize.width);
    }

    /// revert to dart coordinate
    bottomLeft =
        Offset(bottomLeadingIntersection!.dx, -bottomLeadingIntersection.dy);
    bottomRight =
        Offset(bottomTrailingIntersection!.dx, -bottomTrailingIntersection.dy);
    centerBottom =
        Offset(bottomCenterIntersection!.dx, -bottomCenterIntersection.dy);

    angle = degree;
  }

  updateRange(Offset localPosition, double range) {
    var chopstickLeading = localPosition.dx;

    topLeft = Offset(chopstickLeading, 0);
    topRight = Offset(chopstickLeading + range, 0);
    bottomLeft = Offset(chopstickLeading, topLeft.dy + paperSize.height);
    bottomRight =
        Offset(chopstickLeading + range, topRight.dy + paperSize.height);
    center = Offset(chopstickLeading + range / 2, paperSize.height / 2);

    centerTop = Offset(chopstickLeading + (range / 2), 0);
    centerBottom = Offset(chopstickLeading + (range / 2), paperSize.height);

    this.range = range;
  }

  /// normally user will do two behavior at the same time
  ///
  Chopstick copyWith(
      {Size? paperSize,
        Offset? topLeft,
        Offset? topRight,
        Offset? bottomLeft,
        Offset? bottomRight,
        Offset? center,
        Offset? centerTop,
        Offset? centerBottom,
        double? range,
        double? angle,
        Offset? pivot}) {
    return Chopstick(
        paperSize ?? this.paperSize,
        topLeft ?? this.topLeft,
        topRight ?? this.topRight,
        bottomLeft ?? this.bottomLeft,
        bottomRight ?? this.bottomRight,
        center ?? this.center,
        centerTop ?? this.centerTop,
        centerBottom ?? this.centerBottom,
        range ?? this.range,
        angle ?? this.angle,
        pivot ?? this.pivot);
  }

  Chopstick translateXby(double offset) {
    // topRight = Offset(topRight.dx - offset, topRight.dy);
    // topLeft = Offset(topLeft.dx - offset, topLeft.dy);
    // bottomRight = Offset(bottomRight.dx - offset, bottomRight.dy);
    // bottomLeft = Offset(bottomLeft.dx - offset, bottomLeft.dy);
    return copyWith(
        topRight: Offset(topRight.dx - offset, topRight.dy),
        topLeft: Offset(topLeft.dx - offset, topLeft.dy),
        bottomRight: Offset(bottomRight.dx - offset, bottomRight.dy),
        bottomLeft: Offset(bottomLeft.dx - offset, bottomLeft.dy));
  }

  Chopstick revertRotation() {
    var topLeftOxy = Offset(this.topLeft.dx, -this.topLeft.dy);
    var topRightOxy = Offset(this.topRight.dx, -this.topRight.dy);
    var bottomLeftOxy = Offset(this.bottomLeft.dx, -this.bottomLeft.dy);
    var bottomRightOxy = Offset(this.bottomRight.dx, -this.bottomRight.dy);

    /// rotate
    topLeftOxy = rotateAround(topLeftOxy, pivot!, -this.angle);
    topRightOxy = rotateAround(topRightOxy, pivot!, -this.angle);
    bottomLeftOxy = rotateAround(bottomLeftOxy, pivot!, -this.angle);
    bottomRightOxy = rotateAround(bottomRightOxy, pivot!, -this.angle);

    ///
    var topLeadingIntersection =
    TwoDFormula.findIntersectionWithOX(bottomLeftOxy, topLeftOxy);
    var topTrailingIntersection =
    TwoDFormula.findIntersectionWithOX(bottomRightOxy, topRightOxy);
    var bottomLeadingIntersection =
    TwoDFormula.findIntersectionWithHorizontalLine(
        bottomLeftOxy, topLeftOxy, -paperSize.height);

    var bottomTrailingIntersection =
    TwoDFormula.findIntersectionWithHorizontalLine(
        bottomRightOxy, topRightOxy, -paperSize.height);

    var topLeft =
    Offset(topLeadingIntersection!.dx, -topLeadingIntersection!.dy);
    var topRight =
    Offset(topTrailingIntersection!.dx, -topTrailingIntersection.dy);
    var bottomLeft =
    Offset(bottomLeadingIntersection!.dx, -bottomLeadingIntersection.dy);
    var bottomRight =
    Offset(bottomTrailingIntersection!.dx, -bottomTrailingIntersection.dy);
    var angle = 0.0;
    var center = Offset(topLeft.dx + range / 2, paperSize.height / 2);
    var centerTop = Offset(topLeft.dx + (range / 2), 0);
    var centerBottom = Offset(topLeft.dx + (range / 2), paperSize.height);

    return copyWith(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
        angle: angle,
        pivot: null,
        center: center,
        centerTop: centerTop,
        centerBottom: centerBottom)
      ..rotateBy(-angle, pivot: center);
  }

  @override
  String toString() {
    return "topRight : ${topRight.toString()} - bottomRight: ${bottomRight.toString()}";
    return super.toString();
  }

  Offset rotateAround(Offset pointA, Offset pivotB, double angle) {
    double angleRadian = -angle * (pi / 180);
    // Translate A relative to B
    final double translatedX = pointA.dx - pivotB.dx;
    final double translatedY = pointA.dy - pivotB.dy;

    // Perform rotation
    final double rotatedX =
        translatedX * cos(angleRadian) - translatedY * sin(angleRadian);

    final double rotatedY =
        translatedX * sin(angleRadian) + translatedY * cos(angleRadian);

    // Translate back to the original position relative to B
    final double finalX = rotatedX + pivotB.dx;
    final double finalY = rotatedY + pivotB.dy;

    var finalResult = Offset(finalX, finalY);
    return finalResult;
  }
}