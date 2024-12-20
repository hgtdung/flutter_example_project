import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_example_project/features/page1_screen/page1_screen.dart';
import 'package:flutter_example_project/features/page_flip/2d_formular.dart';

class PageFlipWidget extends StatefulWidget {
  const PageFlipWidget({super.key});

  @override
  State<PageFlipWidget> createState() => _PageFlipWidgetState();
}

class _PageFlipWidgetState extends State<PageFlipWidget>
    with SingleTickerProviderStateMixin {
  /// constants
  late final Size screen_size;
  late final Size paper_size;
  final barrierLenght = 100;

  /// point for display
  Offset startPoint = Offset(0, 0);
  // Offset lastUpdatePoint = Offset(321.0, 292.7);
  Offset touchPoint = Offset(0, 0);
  Offset pointerPoint = Offset(0, 0);

  /// manage front layer
  Chopstick? chopstick;
  Offset? lastUpdatePoint = null;
  double? fontLayerWidth;
  Offset center = Offset(0, 0);

  late Offset bottomCornerPoint;
  late Offset topCornerPoint;

  late Offset testBottomCornerPoint;

  Offset? bottomFoldPoint;
  Offset? topFoldPoint;

  /// manage increase and rotate front layer
  late final Offset topRightLimitation;
  late final Offset topLeftLimitation;
  late final Offset bottomLeftLimitation;
  late final Offset bottomRightLimitation;

  Offset? bezierStart;
  Offset? bezierEnd;
  Offset? bezierControlPoint;

  double? overFlowDegree;

  /// [bottomCorner] greater [chopstick.topRight] than an amount of 50
  bool isBottomCornerOverflow = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    screen_size = MediaQuery.of(context).size;
    paper_size = Size(screen_size.width, 600);
    onPanUpdate(Offset(217.0, 177.7), test: false);

    bottomCornerPoint = Offset(paper_size.width, paper_size.height);

    topCornerPoint = Offset(paper_size.width, 0);

    topRightLimitation = Offset(paper_size.width - 20, 0);
    bottomLeftLimitation = Offset(50, paper_size.height);

    bottomRightLimitation = Offset(paper_size.width - 20, paper_size.height);
    topLeftLimitation = Offset(50, 0);

    testBottomCornerPoint = Offset(paper_size.width, paper_size.height);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final boxSize = const Size(100, 100);
    // print(Matrix4.identity()..rotateX(pi / 4));
    // print(MediaQuery.of(context).size.width);
    /// tim diem gap tren va diem gap duoi
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: ElevatedButton(
              onPressed: () {
                testRotate();
              },
              child: Text("test rotate")),
        ),
        Spacer(),
        Align(
          alignment: Alignment.bottomLeft,
          child: GestureDetector(
            onPanUpdate: (panUpdate) {
              // print("dsd ${panUpdate.localPosition}");

              onPanUpdate(panUpdate.localPosition);
              setState(() {
                lastUpdatePoint = panUpdate.localPosition;
              });
            },
            onPanStart: (panStart) {
              setState(() {
                startPoint = panStart.localPosition;
              });
              onPanStart(panStart.localPosition);
            },
            child: Container(
              color: Color(0xffF5DEB3),
              child: CustomPaint(
                // painter: PageFlipPainter(),
                painter: PageCurlPainter(
                    startPoint: bezierStart, endPoint: bezierEnd),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: 600,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Text("Hello this is the title"),
                          ElevatedButton(
                              onPressed: () {
                                var p =
                                    turnPageTransform(Offset3D(200, 150, 0));
                                print("Point P ${p}");
                                findFoldPoint(Size(200, 200));
                              },
                              child: Text("test calculate func")),
                          Spacer(),
                          Text("Hello")
                        ],
                      ),
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                        ),
                        child: SizedBox(
                          height: 600,
                          width: fontLayerWidth ?? paper_size.width,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: BoxDecoration(
                                // color: Color(0xffF5DEB3),
                                color: Color(0xffF5DEB3),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black,
                                      // offset: Offset(-3, 0),
                                      // spreadRadius: 4,
                                      blurRadius: 6)
                                ],
                              ),
                              height: 600,
                              width: chopstick?.range ?? 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        left: startPoint.dx,
                        top: startPoint.dy,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                        )),
                    Positioned(
                        left: touchPoint.dx - 5,
                        top: touchPoint.dy - 5,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.green),
                        )),

                    // PageAnchor(chopstick: chopstick,),
                    ...getPageAnchor(chopstick),

                    /// vertical line
                    // Positioned(
                    //     left: lastUpdatePoint?.dx ??0,
                    //     // top: updatePoint.dy - pageHeight / 2,
                    //     top: 0,
                    //     child: Container(
                    //       height: pageSize.height,
                    //       width: 1,
                    //       decoration:const BoxDecoration(
                    //         boxShadow: [
                    //           BoxShadow(
                    //               color: Colors.black,
                    //           offset: Offset(4, 0),
                    //           // spreadRadius: 4,
                    //           blurRadius: 6)
                    //         ],
                    //           color: Colors.green
                    //       ),))
                  ],
                ),
                // painter: PageFlipPainter(),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  /// the statrt position => dy giam => rotate cung chieu kim dong ho.
  ///
  void onPanStart(Offset localPosition) {
    isBottomCornerOverflow = false;
    // startPoint = localPosition;
    /// only accept touch near the edge of the right and the left
    if (localPosition.dx < (paper_size.width - 40)) {
      return;
    }
    // chopstick ??= createChopstick(initialChopstickRange: 20);
    // calculateFontLayerWidth();
  }

  void onPanEnd(Offset localPosition) {
    chopstick = null;
  }

  Chopstick createChopstick(Offset localPosition,
      {required double chopstickRadius}) {
    var distanceFromRight = screen_size.width - localPosition.dx;
    var chopstickRange = (distanceFromRight / 2) - chopstickRadius;

    var topLeft = Offset(localPosition.dx, 0);
    var topRight = Offset(localPosition.dx + chopstickRange, 0);
    var bottomLeft = Offset(localPosition.dx, topLeft.dy + paper_size.height);
    var bottomRight = Offset(
        localPosition.dx + chopstickRange, topRight.dy + paper_size.height);

    Offset center =
        Offset(localPosition.dx + chopstickRange / 2, paper_size.height / 2);

    Offset centerTop = Offset(topLeft.dx + chopstickRange / 2, 0);
    Offset centerBottom =
        Offset(topLeft.dx + chopstickRange / 2, paper_size.height);

    /// just for show ui
    this.center = center;

    return Chopstick(paper_size, topLeft, topRight, bottomLeft, bottomRight,
        center, centerTop, centerBottom, chopstickRange, 0, null);
  }

  void calculateFontLayerWidth() {
    fontLayerWidth = screen_size.width - chopstick!.range;
  }

  void onPanUpdate(Offset localPosition, {bool? test}) {
    /// just for display UI
    touchPoint = localPosition;

    if (paper_size.width - localPosition.dx < 22) {
      return;
    }


    if (chopstick == null) {
      startPoint = localPosition;
      chopstick = createChopstick(localPosition, chopstickRadius: 10);
    }

    /// calculate rotate angle, compare last update point with current point
    var dy = startPoint.dy - touchPoint.dy;
    var degree = 0.0;
    degree = dy;

    /// imagine that the touch position will be on the half of the circle
    var chopstickRange = 2 * (paper_size.width - localPosition.dx) / pi;

    if (isBottomCornerOverflow == false) {
      chopstick!.updateRange(localPosition, chopstickRange);
    }

    /// save chopstick that haven't rotated yet
    var noRotateChopstick = chopstick!.copyWith();

    ///
    fontLayerWidth = localPosition.dx + chopstickRange / 2;

    if (degree == 0 ) {
      return;
    }
    print("degree $degree");

    // if (degree.abs() > 70) {
    //   return;
    // degree > 0
    //     ? getClockwiseChopstick(chopstick!.angle)
    //     : getUClockwiseChopstick(chopstick!.angle);
    // } else {
    //   degree > 0
    //       ? getClockwiseChopstick(degree)
    //       : getUClockwiseChopstick(degree);
    // }

    if (isBottomCornerOverflow == false) {
      degree > 0
          ? getClockwiseChopstick(degree, localPosition)
          : getUClockwiseChopstick(degree);
    } else {
      print("last degreee $overFlowDegree");
      if(degree <overFlowDegree!) {
        isBottomCornerOverflow = false;
      } else {
        var revertChopstick = chopstick!.revertRotation();
        var rotatedRevertChopstick =  revertChopstick..rotateBy(overFlowDegree!, pivot: touchPoint);
        if(rotatedRevertChopstick.bottomRight.dx < bottomLeftLimitation.dx) {
          print("chopstick");
          return;
        } else {
          chopstick = rotatedRevertChopstick;
        }

        // print("revert chopstick $revertChopstick");

        /// find bottom corner point
        var amountToMiddle = ((paper_size.width -
            (localPosition.dx - chopstick!.range / 2)) /
            2) -
            chopstick!.range;
        testBottomCornerPoint = TwoDFormula.findSymmetricPoint(
            Offset(paper_size.width, -paper_size.height),
            Offset(chopstick!.bottomRight.dx + amountToMiddle,
                -chopstick!.bottomRight.dy),
            Offset(chopstick!.topRight.dx + amountToMiddle,
                -chopstick!.topRight.dy));

        /// Revert to dart coordinate
        testBottomCornerPoint =
            Offset(testBottomCornerPoint.dx, -testBottomCornerPoint.dy);
      }
    }




    var maximumDegree = TwoDFormula.angleBetweenLines(
        chopstick!.center.dx + chopstick!.range / 2,
        -chopstick!.center.dy,
        chopstick!.center.dx + chopstick!.range / 2,
        -paper_size.height,
        chopstick!.center.dx + chopstick!.range / 2,
        -chopstick!.center.dy,
        bottomLeftLimitation.dx,
        -bottomLeftLimitation.dy);

    // bottomFoldPoint =
    //     getSupportFoldPoint(chopstick!, degree.abs(), maximumDegree.abs());
    // topFoldPoint = getSupportFoldPoint(
    //     chopstick!, degree.abs(), maximumDegree.abs(),
    //     isTop: true);

    // /// dy chay tu 0 - 70
    // findBottomCornerPoints(
    //     localPosition, chopstickRange, noRotateChopstick, degree);
    // findTopCornerPoints(
    //     localPosition, chopstickRange, noRotateChopstick, degree);

    // findBezierPoint(degree);
    setState(() {});
  }

  void getClockwiseChopstick(double degree, Offset localPosition) {
    /// Rotate along clockwise
    /// /revert back to update range, then rotate
    // var revertChopstick = chopstick.revertRotation();

    var newChopstick = chopstick!.copyWith()..rotateBy(degree);
    if (newChopstick.topRight.dx >= topRightLimitation.dx) {
      var newPivotChopstick = chopstick!.copyWith()
        ..rotateBy(degree, pivot: touchPoint);

      /// find bottom corner point
      var amountToMiddle = ((paper_size.width -
                  (localPosition.dx - newPivotChopstick.range / 2)) /
              2) -
          newPivotChopstick.range;

      testBottomCornerPoint = TwoDFormula.findSymmetricPoint(
          Offset(paper_size.width, -paper_size.height),
          Offset(newPivotChopstick!.bottomRight.dx + amountToMiddle,
              -newPivotChopstick!.bottomRight.dy),
          Offset(newPivotChopstick!.topRight.dx + amountToMiddle,
              -newPivotChopstick!.topRight.dy));

      /// Revert to dart coordinate
      testBottomCornerPoint =
          Offset(testBottomCornerPoint.dx, -testBottomCornerPoint.dy);

      if (newPivotChopstick.bottomRight.dx > bottomLeftLimitation.dx) {
        if (newPivotChopstick.topRight.dy > testBottomCornerPoint.dy &&
            (newPivotChopstick.topRight.dy - testBottomCornerPoint.dy) > 50) {
          chopstick = newPivotChopstick;
          print("chopstick after rotate ${newPivotChopstick}");
          overFlowDegree = degree;
          isBottomCornerOverflow = true;
          print("zo if ne");
          return;
        } else {
          print("else ne");
        }
      } else {}

      chopstick = newPivotChopstick;
    }

    return;

    /// old code
    /// Reach top right limitation, move center to touch point
    if (newChopstick.topRight.dx >= topRightLimitation.dx) {
      var newPivotChopstick = chopstick!.copyWith()
        ..rotateBy(degree, pivot: touchPoint);

      /// Reach to bottom left limitation, translate to that point, then rotate around that point,
      /// beside should increase chopstick range here
      print("pivot chopstick $newPivotChopstick");

      if (newPivotChopstick.bottomRight.dx <= bottomLeftLimitation.dx) {
        print("zo day");

        var offset =
            (bottomLeftLimitation.dx - chopstick!.bottomRight.dx).abs();
        chopstick = chopstick!.translateXby(offset);
        var offsetChopstick = chopstick!.copyWith()
          ..rotateBy(degree, pivot: bottomLeftLimitation);

        /// Corner point below the bottom right point
        if (offsetChopstick.topRight.dy > bottomCornerPoint.dy &&
            (offsetChopstick.topRight.dy - bottomCornerPoint.dy) > 50) {
          // chopstick!.rotateBy(degree, pivot: bottomLeftLimitation);
          // chopstick!.rotateBy(degree, pivot: bottomLeftLimitation);
          chopstick!.rotateBy(chopstick!.angle, pivot: touchPoint);
          print("chopstick angle ${chopstick!.angle}");

          /// rotate to limitation here
          ///
        } else {
          chopstick!.rotateBy(degree, pivot: bottomLeftLimitation);
        }
      } else {
        // var amountToMiddle =
        //     ((paper_size.width - (localPosition.dx - newPivotChopstick.range / 2)) / 2) - newPivotChopstick.range;
        //
        // var bottomCornerPoint = TwoDFormula.findSymmetricPoint(
        //     Offset(paper_size.width, -paper_size.height),
        //     Offset(newPivotChopstick!.bottomRight.dx + amountToMiddle,
        //         -newPivotChopstick!.bottomRight.dy),
        //     Offset(
        //         newPivotChopstick!.topRight.dx + amountToMiddle, -newPivotChopstick!.topRight.dy));

        if (newPivotChopstick.topRight.dy > bottomCornerPoint.dy &&
            (newPivotChopstick.topRight.dy - bottomCornerPoint.dy) > 50) {
          chopstick!.rotateBy(chopstick!.angle, pivot: touchPoint);

          /// bug here
          print("bug here ${chopstick!.angle}");
        } else {
          chopstick = newPivotChopstick;
          print("vao day");
        }
      }
    } else {
      print("vao day123");
      chopstick = newChopstick;
    }
    print("chopstick $chopstick");
  }

  void findBezierPoint(double angle) {
    /// bezier start = 1/3 [bottomCornerPoint] point to [chopstick.topRight] point
    if (angle < 0) {
      return;
    }
    var bottomCornerOxy = Offset(bottomCornerPoint.dx, -bottomCornerPoint.dy);
    var topRightChopstickOxy =
        Offset(chopstick!.topRight.dx, chopstick!.topRight.dy);

    bezierStart = touchPoint;

    bezierEnd = chopstick!.topRight.dx < topRightLimitation.dx
        ? topCornerPoint
        : chopstick!.centerTop;

    /// use conic beizer curve
    // bezierControlPoint =
    //endpoint.dx - 5, startPoint.y + 3
  }

  void findBottomCornerPoints(Offset localPosition, double chopstickRange,
      Chopstick noRotateChopstick, double degree) {
    if (degree < 0) {
      return;
    }
    var amountToMiddle =
        ((paper_size.width - (localPosition.dx - chopstickRange / 2)) / 2) -
            chopstickRange;

    /// Find bottom corner point
    bottomCornerPoint = TwoDFormula.findSymmetricPoint(
        Offset(paper_size.width, -paper_size.height),
        Offset(chopstick!.bottomRight.dx + amountToMiddle,
            -chopstick!.bottomRight.dy),
        Offset(
            chopstick!.topRight.dx + amountToMiddle, -chopstick!.topRight.dy));
    //
    // if (degree > 0 && chopstick!.topRight.dx <= topRightLimitation.dx) {
    //   /// Find top corner point
    //   var noRotateBottomCornerPoint = Offset(
    //       noRotateChopstick.bottomLeft.dx, -noRotateChopstick.bottomLeft.dy);
    //   var dxBottomCornerDiff =
    //       (bottomCornerPoint.dx - noRotateBottomCornerPoint.dx).abs();
    //   var dyBottomCornerDiff =
    //       (bottomCornerPoint.dy - noRotateBottomCornerPoint.dy).abs();
    //
    //   var noRotateTopCornerPoint = noRotateChopstick.topLeft;
    //   topCornerPoint = Offset(noRotateTopCornerPoint.dx + dxBottomCornerDiff,
    //       noRotateTopCornerPoint.dy + dyBottomCornerDiff);
    //   topCornerPoint = TwoDFormula.findIntersectionWithHorizontalLine(
    //       bottomCornerPoint, topCornerPoint, 0)!;
    //   // var explodeAmount = const Offset(3, 3);
    //   var explodeAmount = const Offset(0, 0);
    //   topCornerPoint =
    //       Offset(topCornerPoint.dx + explodeAmount.dx, topCornerPoint.dy);
    //
    //   /// Revert to dart coordinate
    //   topCornerPoint = Offset(topCornerPoint.dx, -topCornerPoint.dy);
    // }
    // else if (chopstick!.topRight.dx > topRightLimitation.dx) {
    //   topCornerPoint = Offset(paper_size.width, 0);
    // }

    bottomCornerPoint = Offset(bottomCornerPoint.dx, -bottomCornerPoint.dy);
  }

  void findTopCornerPoints(Offset localPosition, double chopstickRange,
      Chopstick noRotateChopstick, double degree) {
    if (degree > 0) {
      return;
    }
    var amountToMiddle =
        ((paper_size.width - (localPosition.dx - chopstickRange / 2)) / 2) -
            chopstickRange;

    /// Find top corner point
    topCornerPoint = TwoDFormula.findSymmetricPoint(
        Offset(paper_size.width, 0),
        Offset(chopstick!.bottomRight.dx + amountToMiddle,
            -chopstick!.bottomRight.dy),
        Offset(
            chopstick!.topRight.dx + amountToMiddle, -chopstick!.topRight.dy));

    if (degree < 0 && chopstick!.bottomRight.dx <= bottomRightLimitation.dx) {
      /// Find bot corner point
      var noRotateTopCornerPoint =
          Offset(noRotateChopstick.topLeft.dx, -noRotateChopstick.topLeft.dy);
      var dxTopCornerDiff =
          (topCornerPoint.dx - noRotateTopCornerPoint.dx).abs();
      var dyTopCornerDiff =
          (topCornerPoint.dy - noRotateTopCornerPoint.dy).abs();

      var noRotateBottomCornerPoint = noRotateChopstick.bottomLeft;
      bottomCornerPoint = Offset(noRotateBottomCornerPoint.dx + dxTopCornerDiff,
          -noRotateBottomCornerPoint.dy - dyTopCornerDiff);
      bottomCornerPoint = TwoDFormula.findIntersectionWithHorizontalLine(
          topCornerPoint, bottomCornerPoint, -paper_size.height)!;
      var explodeAmount = const Offset(3, 3);
      bottomCornerPoint =
          Offset(bottomCornerPoint.dx + explodeAmount.dx, bottomCornerPoint.dy);

      /// Revert to dart coordinate
      bottomCornerPoint = Offset(bottomCornerPoint.dx, -bottomCornerPoint.dy);
    }

    topCornerPoint = Offset(topCornerPoint.dx, -topCornerPoint.dy);
  }

  void curlThePage() {
    /// haven't reach the maximum top right point
    ///
    if (chopstick!.topRight.dx < topRightLimitation.dx) {}

    /// haven't reach limit point

    /// reach limit  point
  }

  /// TODO: rename this function
  /// draw the curl from dóng thẳng từ coner point xuống, điểm uốn là fold point, điểm kết thúc là corner point
  Offset getSupportFoldPoint(Chopstick chopstick, double degree, maximumDegree,
      {bool? isTop}) {
    /// Run from 0 - 20
    var cornerRunValue = 0.0;
    if (degree < maximumDegree) {
      cornerRunValue = degree * 20 / maximumDegree;
    } else {
      cornerRunValue = 20;
    }

    /// offset of horizontal line
    var m = 0.0;
    if (isTop == true) {
      m = -cornerRunValue;
    } else {
      m = -paper_size.height + cornerRunValue;
    }

    var bottomFoldPoint = TwoDFormula.findIntersectionWithHorizontalLine(
        Offset(chopstick.bottomRight.dx, -chopstick.bottomRight.dy),
        Offset(chopstick.topRight.dx, -chopstick.topRight.dy),
        m);

    /// Revert to dart coordinate
    return Offset(bottomFoldPoint!.dx, -bottomFoldPoint.dy);
  }

  void getUClockwiseChopstick(double degree) {
    /// Mark: under park, rotate along anticlockwise
    var newChopstick = chopstick!.copyWith()..rotateBy(degree);
    if (newChopstick.bottomRight.dx >= bottomRightLimitation.dx) {
      var newPivotChopstick = chopstick!.copyWith()
        ..rotateBy(degree, pivot: touchPoint);

      /// Reach to bottom right limitation, translate to that point, then rotate around that point
      if (newPivotChopstick.topRight.dx <= topLeftLimitation.dx) {
        var offset = (topLeftLimitation.dx - chopstick!.topRight.dx).abs();
        chopstick!.translateXby(offset);
        var offsetChopstick = chopstick!.copyWith()
          ..rotateBy(degree, pivot: topLeftLimitation);

        /// Corner point below the bottom right point
        if (offsetChopstick.bottomRight.dy < topCornerPoint.dy &&
            (topCornerPoint.dy - offsetChopstick.topRight.dy) > 50) {
          chopstick!.rotateBy(-54.666656494140625, pivot: topLeftLimitation);
        } else {
          chopstick!.rotateBy(degree, pivot: topLeftLimitation);
        }
      } else {
        chopstick = newPivotChopstick;
      }
    } else {
      chopstick = newChopstick;
    }
  }

  double findRotateLimitation(Chopstick chopstick) {
    try {
      var rawChopstick = chopstick.copyWith()..rotateBy(-chopstick.angle);
      var maxBottomRightPoint = Offset(200, -paper_size.height);

      var maximumAngle = TwoDFormula.angleBetweenLines(
          chopstick.center.dx,
          -chopstick.center.dy,
          maxBottomRightPoint.dx,
          maxBottomRightPoint.dy,
          rawChopstick.bottomRight.dx,
          -rawChopstick.bottomRight.dy,
          rawChopstick.topRight.dx,
          -rawChopstick.topRight.dy);
      print("maximum angle $maximumAngle");
      return maximumAngle * pi / 180;
    } catch (e) {
      print("findRotate limitation point error $e");
    }
    return 0;
  }

  void testRotate() {
    setState(() {
      // chopstick!.rotateBy(5);

      var revertChopstick = chopstick!.revertRotation();
      chopstick = revertChopstick;
    });
  }

  Offset3D turnPageTransform(Offset3D vi) {
    // Get the current input vertex.
    var A = -1;
    var theta = 45;
    var rho = 0;

    // Radius of the circle circumscribed by vertex (vi.x, vi.y) around A on the x-y plane
    var R = sqrt(vi.x * vi.x + pow(vi.y - A, 2));
    // Now get the radius of the cone cross section intersected by our vertex in 3D space.
    var r = R * sin(theta);
    // Angle subtended by arc |ST| on the cone cross section.
    var beta = asin(vi.x / R) / sin(theta);

    // *** MAGIC!!! ***
    Offset3D v1 = Offset3D(0, 0, 0);
    Offset3D v0 = Offset3D(0, 0, 0);
    v1.x = r * sin(beta);
    v1.y = R + A - r * (1 - cos(beta)) * sin(theta);
    v1.z = r * (1 - cos(beta)) * cos(theta);
    // Apply a basic rotation transform around the y axis to rotate the curled page.
    // These two steps could be combined through simple substitution, but are left
    // separate to keep the math simple for debugging and illustrative purposes.

    v0.x = (v1.x * cos(rho) - v1.z * sin(rho));
    v0.y = v1.y;
    v0.z = (v1.x * sin(rho) + v1.z * cos(rho));
    return v0;
  }

  Offset3D? findFoldPoint(Size size) {
    for (var i = size.width; i > 0; i--) {
      var bottomPoint = Offset3D(i.toDouble(), 0, 0);
      var transformedPoint = turnPageTransform(bottomPoint);
      var roundTransformedPoint = Offset3D(
          transformedPoint.x.floor().toDouble(),
          transformedPoint.y.floor().toDouble(),
          transformedPoint.z);
      if (roundTransformedPoint.z == 0.0 && roundTransformedPoint.y == 0.0) {
        print("point fold found ${transformedPoint}");
        return transformedPoint;
      }
    }
    print("not found");
    return null;
  }

  List<Widget> getPageAnchor(Chopstick? chopstick) {
    if (chopstick == null) {
      return [];
    }
    return [
      Positioned(
          left: chopstick.topLeft.dx - 5,
          top: chopstick.topLeft.dy - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.brown),
          )),
      Positioned(
          left: chopstick.topRight.dx - 5,
          top: chopstick.topRight.dy - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.brown),
          )),
      Positioned(
          left: chopstick.bottomRight.dx - 5,
          top: chopstick.bottomRight.dy - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.brown),
          )),
      Positioned(
          left: chopstick.bottomLeft.dx - 5,
          top: chopstick.bottomLeft.dy - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.brown),
          )),
      Positioned(
          left: chopstick.center.dx - 5,
          top: chopstick.center.dy - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.brown),
          )),
      Positioned(
          left: bottomCornerPoint.dx - 5,
          top: bottomCornerPoint.dy - 5,
          child: Container(
            height: 10,
            width: 10,
            child: Text("b"),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.purple),
          )),
      Positioned(
          left: testBottomCornerPoint.dx - 5,
          top: testBottomCornerPoint.dy - 5,
          child: Container(
            height: 10,
            width: 10,
            child: Text("b"),
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.teal),
          )),
      if (bottomFoldPoint != null)
        Positioned(
            left: bottomFoldPoint!.dx - 5,
            top: bottomFoldPoint!.dy - 5,
            child: Container(
              height: 10,
              width: 10,
              child: Text("b"),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.yellow),
            )),
      if (topFoldPoint != null)
        Positioned(
            left: topFoldPoint!.dx - 5,
            top: topFoldPoint!.dy - 5,
            child: Container(
              height: 10,
              width: 10,
              child: Text("b"),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.yellow),
            )),
      Positioned(
          left: topCornerPoint.dx - 5,
          top: topCornerPoint.dy - 5,
          child: Container(
            height: 10,
            width: 10,
            child: Text("t"),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.purple),
          )),
      // Positioned(
      //     left: chopstick.centerTop.dx - 5 ?? 0,
      //     top: chopstick.centerTop.dy - 5 ?? 0,
      //     child: Container(
      //       height: 10,
      //       width: 10,
      //       decoration:
      //           const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
      //     )),
      // Positioned(
      //     left: chopstick.centerBottom.dx - 5 ?? 0,
      //     top: chopstick.centerBottom.dy - 5 ?? 0,
      //     child: Container(
      //       height: 10,
      //       width: 10,
      //       decoration:
      //           const BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
      //     )),
      // Positioned(
      //     left: chopstick.centerBottom.dx  - 5?? 0,
      //     top: chopstick.centerBottom.dy - 5 ?? 0,
      //     child: Container(
      //       height: 10,
      //       width: 10,
      //       decoration: const BoxDecoration(
      //           shape: BoxShape.circle, color: Colors.brown),
      //     )),
    ];
  }
}

class VerticesDraw extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.red;

    final vertices = Vertices(VertexMode.triangles, [
      Offset(0, 0),
      Offset(20, 0),
      Offset(40, 20),
    ]);

    canvas.drawVertices(vertices, BlendMode.src, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PageCurlPainter extends CustomPainter {
  final Offset? startPoint;
  final Offset? endPoint;

  PageCurlPainter({this.startPoint, this.endPoint});
  @override
  void paint(Canvas canvas, Size size) {
    return;
    print("repaint");
    if (startPoint == null || endPoint == null) {
      return;
    }
    print("oh here");
    var paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    print("start point $startPoint");
    print("end point $endPoint");
    var path = Path();
    path.moveTo(startPoint!.dx, startPoint!.dy);
    var controlPointDx = startPoint!.dx + (endPoint!.dx - startPoint!.dx) / 2;
    var controlPointDy = startPoint!.dy + (endPoint!.dy - startPoint!.dy) / 2;
    path.conicTo(controlPointDx + 10, controlPointDy + 10, endPoint!.dx,
        endPoint!.dy, 0.5);
    // path.lineTo(size.width, size.height);

    // path.lineTo(endPoint!.dx, endPoint!.dy);

    // canvas.dr
    // canvas.drawLine(startPoint!, endPoint!, paint);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Offset? findIntersection(Offset p0, Offset p1, Offset p2) {
    // Tính trung điểm M
    final m = Offset((p0.dx + p2.dx) / 2, (p0.dy + p2.dy) / 2);

    // Phương trình tham số của đường Bézier
    Offset bezierPoint(double t) {
      final x =
          pow(1 - t, 2) * p0.dx + 2 * (1 - t) * t * p1.dx + pow(t, 2) * p2.dx;
      final y =
          pow(1 - t, 2) * p0.dy + 2 * (1 - t) * t * p1.dy + pow(t, 2) * p2.dy;
      return Offset(x, y);
    }

    // Phương trình tham số của đường thẳng
    Offset linePoint(double s) {
      final direction = Offset(m.dx - p1.dx, m.dy - p1.dy);
      return Offset(p1.dx + s * direction.dx, p1.dy + s * direction.dy);
    }

    // Tìm nghiệm (giải gần đúng)
    const int steps = 1000;
    const double stepSize = 1.0 / steps;
    for (int i = 0; i <= steps; i++) {
      final t = i * stepSize;
      final bezier = bezierPoint(t);

      // Tính giá trị s trên đường thẳng
      final s = (m.dx - p1.dx).abs() > 0.0001
          ? (bezier.dx - p1.dx) / (m.dx - p1.dx)
          : (m.dy - p1.dy).abs() > 0.0001
              ? (bezier.dy - p1.dy) / (m.dy - p1.dy)
              : null;

      if (s == null) continue; // Nếu đường thẳng không hợp lệ.

      final line = linePoint(s);

      // Kiểm tra giao điểm (dựa trên khoảng cách gần nhau)
      if ((bezier.dx - line.dx).abs() < 0.01 &&
          (bezier.dy - line.dy).abs() < 0.01) {
        return bezier; // Điểm giao nhau
      }
    }

    return null; // Không tìm thấy
  }
}

class PageFlipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color(0xffF5DEB3)
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4)
      ..strokeWidth = 10;

    var path = Path();
    final curvePerpDistance = 50.0;
    final pointerPoint = Offset(size.width - 200, size.height - 200);
    final rightFoldPointStart =
        Offset(size.width, pointerPoint.dy - curvePerpDistance);
    final rightFoldPointEnd = Offset(rightFoldPointStart.dx - curvePerpDistance,
        rightFoldPointStart.dy + curvePerpDistance);
    final bottomFoldPointStart =
        Offset(pointerPoint.dx, size.height - curvePerpDistance);
    final bottomFoldPointEnd =
        Offset(pointerPoint.dx - curvePerpDistance, size.height);

    path.moveTo(0, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);

    /// move to right fold point
    /// draw the right fold curve
    path.lineTo(rightFoldPointStart.dx, rightFoldPointStart.dy);
    var controlPoint =
        Offset(rightFoldPointStart.dx - 5, rightFoldPointStart.dy + 35);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy,
        rightFoldPointEnd.dx, rightFoldPointEnd.dy);
    // draw the upper right fold box shadow
    final upperShadow = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 4)
      ..strokeWidth = 10;
    canvas.drawLine(
      rightFoldPointEnd, // Start point
      pointerPoint, // End pointpoint
      upperShadow,
    );
    path.lineTo(rightFoldPointEnd.dx, rightFoldPointEnd.dy);
    path.lineTo(pointerPoint.dx, pointerPoint.dy);

    // // draw the under right fold box shadow
    // canvas.drawLine(
    //   pointerPoint, // Start point
    //   bottomFoldPointStart, // End pointpoint
    //   shadowPaint,
    // );

    path.lineTo(bottomFoldPointStart.dx, bottomFoldPointStart.dy);
    var controlPoint2 =
        Offset(bottomFoldPointStart.dx - 5, bottomFoldPointStart.dy + 35);
    path.quadraticBezierTo(controlPoint2.dx, controlPoint2.dy,
        bottomFoldPointEnd.dx, bottomFoldPointEnd.dy);
    path.lineTo(0, size.height);

    final rightIntersection =
        findIntersection(rightFoldPointStart, controlPoint, rightFoldPointEnd);
    final bottomIntersection = findIntersection(
        bottomFoldPointStart, controlPoint2, bottomFoldPointEnd);
    if (rightIntersection != null && bottomIntersection != null) {
      // path.moveTo(rightIntersection.dx, rightIntersection.dy);
      // path.lineTo(bottomIntersection.dx, bottomIntersection.dy);

      final linePaint = Paint()
        ..color = Color(0xffF5DEB3) // Line color
        ..strokeWidth = 3.0 // Line thickness
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        rightIntersection, // Start point
        bottomIntersection, // End pointpoint
        shadowPaint,
      );

      canvas.drawLine(
        rightIntersection, // Start point
        rightFoldPointStart, // End pointpoint
        shadowPaint,
      );

      canvas.drawLine(
        bottomFoldPointEnd, // Start point
        bottomIntersection, // End pointpoint
        shadowPaint,
      );

      // // Draw the line on top
      // canvas.drawLine(
      //   rightIntersection, // Start point
      //   bottomIntersection, // End point
      //   linePaint,
      // );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Offset? findIntersection(Offset p0, Offset p1, Offset p2) {
    // Tính trung điểm M
    final m = Offset((p0.dx + p2.dx) / 2, (p0.dy + p2.dy) / 2);

    // Phương trình tham số của đường Bézier
    Offset bezierPoint(double t) {
      final x =
          pow(1 - t, 2) * p0.dx + 2 * (1 - t) * t * p1.dx + pow(t, 2) * p2.dx;
      final y =
          pow(1 - t, 2) * p0.dy + 2 * (1 - t) * t * p1.dy + pow(t, 2) * p2.dy;
      return Offset(x, y);
    }

    // Phương trình tham số của đường thẳng
    Offset linePoint(double s) {
      final direction = Offset(m.dx - p1.dx, m.dy - p1.dy);
      return Offset(p1.dx + s * direction.dx, p1.dy + s * direction.dy);
    }

    // Tìm nghiệm (giải gần đúng)
    const int steps = 1000;
    const double stepSize = 1.0 / steps;
    for (int i = 0; i <= steps; i++) {
      final t = i * stepSize;
      final bezier = bezierPoint(t);

      // Tính giá trị s trên đường thẳng
      final s = (m.dx - p1.dx).abs() > 0.0001
          ? (bezier.dx - p1.dx) / (m.dx - p1.dx)
          : (m.dy - p1.dy).abs() > 0.0001
              ? (bezier.dy - p1.dy) / (m.dy - p1.dy)
              : null;

      if (s == null) continue; // Nếu đường thẳng không hợp lệ.

      final line = linePoint(s);

      // Kiểm tra giao điểm (dựa trên khoảng cách gần nhau)
      if ((bezier.dx - line.dx).abs() < 0.01 &&
          (bezier.dy - line.dy).abs() < 0.01) {
        return bezier; // Điểm giao nhau
      }
    }

    return null; // Không tìm thấy
  }
}

class Circle extends StatelessWidget {
  const Circle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      width: 10,
      height: 10,
    );
  }
}

class Offset3D {
  double x;
  double y;
  double z;
  Offset3D(this.x, this.y, this.z);

  @override
  String toString() {
    return "\n"
        "x: ${x}\n"
        "y: ${y}\n"
        "z: ${z}"
        "==========";
  }
}

class Chopstick {
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
      this.pivot
      );

  rotateBy(double degree,

      /// if != null, rotate around this point
      {Offset? pivot}) {
    late Offset centerOxy;
    if(pivot != null) {
      this.pivot = Offset(pivot.dx, -pivot.dy);
      centerOxy = Offset(pivot.dx, -pivot.dy);
    }  else {
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
    // var distanceFromRight = this.paperSize.width - localPosition.dx;
    // var range = (distanceFromRight / 2) - radius;
    var chopstickLeading = localPosition.dx - range / 2;

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
        pivot ?? this.pivot
    );
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

    var topLeft = Offset(topLeadingIntersection!.dx, -topLeadingIntersection!.dy);
    var topRight = Offset(topTrailingIntersection!.dx, -topTrailingIntersection.dy);
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
      centerBottom: centerBottom

    )..rotateBy(-angle, pivot: center);
  }

  @override
  String toString() {
    return "topRight : ${topRight.toString()} - bottomRight: ${bottomRight.toString()}";
    return super.toString();
  }
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
