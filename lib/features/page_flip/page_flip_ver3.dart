import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_example_project/features/page1_screen/page1_screen.dart';
import 'package:flutter_example_project/features/page_flip/2d_formular.dart';
import 'package:flutter_example_project/features/page_flip/clip_shadow_path.dart';
import 'package:flutter_example_project/features/page_flip/page_flip.model.dart';

import 'page_flip_ver3_model/page_flip_ver3.model.dart';

const conic_weight = 4.0;

class PageFlipWidgetVer3 extends StatefulWidget {
  const PageFlipWidgetVer3({super.key});

  @override
  State<PageFlipWidgetVer3> createState() => _PageFlipWidgetVer3State();
}

class _PageFlipWidgetVer3State extends State<PageFlipWidgetVer3>
    with SingleTickerProviderStateMixin {
  /// constants
  late final Size screen_size;
  late final Size paper_size;
  final maximumDegree = 60.0;

  /// point for display
  Offset startPoint = Offset(0, 0);

  Offset touchPoint = Offset(0, 0);
  Offset pointerPoint = Offset(0, 0);

  /// manage front layer
  Chopstick? lastChopstick;
  Chopstick? chopstick;
  double? fontLayerWidth;
  Offset center = Offset(0, 0);

  late Offset bottomCornerPoint;
  late Offset topCornerPoint;
  Offset? cornerPoint;

  Offset? supportFoldPoint;

  /// manage increase and rotate front layer
  late final Offset topRightLimitation;
  late final Offset topLeftLimitation;
  late final Offset bottomLeftLimitation;
  late final Offset bottomRightLimitation;

  Offset? bezierStart;
  Offset? bezierEnd;
  Offset? bezierControlPoint;
  Offset? conicInflectionPoint;

  Offset? horizontalControlPoint;
  Offset? horizontalStartPoint;

  double? overflowDegree;
  Offset? newRotationPoint;
  double? perpendicularDegree;

  double conicWeight = 0;
  double conicT = 1;
  double? conicTStartDownPosition;
  double? conicTStartUpDegree;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    screen_size = MediaQuery.of(context).size;
    paper_size = Size(screen_size.width, 600);

    initFirstPoint(Offset(217.0, 177.7));

    bottomCornerPoint = Offset(paper_size.width, paper_size.height);
    topCornerPoint = Offset(paper_size.width, 0);

    topRightLimitation = Offset(paper_size.width - 20, 0);
    bottomLeftLimitation = Offset(50, paper_size.height);
    bottomRightLimitation = Offset(paper_size.width - 20, paper_size.height);
    topLeftLimitation = Offset(50, 0);

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
              child: ElevatedButton(onPressed: () {}, child: Text("test rotatee")),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onPanUpdate: (panUpdate) {
                  onPanUpdateVer2(panUpdate.localPosition, panUpdate);
                  setState(() {});
                },
                onPanStart: (panStart) {
                  onPanStart(panStart.localPosition);
                },
                onPanEnd: (dragEndDetails) {
                  onPanEnd(dragEndDetails);
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipShadowPath(
                        shadow: const BoxShadow(
                            color: Colors.black45,
                            offset: Offset(8, 8),
                            blurRadius: 7,
                            spreadRadius: 8),
                        clipper:
                        PageCurlClipper(
                            conicT: conicT,
                            conicWeight: conicWeight,
                            nullableChopstick: null,
                            supportFoldPoint: supportFoldPoint,
                            cornerPoint: cornerPoint,
                            bezierStartPoint: bezierStart,
                            bezierEndPoint: bezierEnd,
                            bezierControlPoint: bezierControlPoint,
                            conicInflectionPoint: conicInflectionPoint,
                            maximumAngle: maximumDegree,
                            horizontalStartPoint: horizontalStartPoint
                            ),
                        child:
                        Container(
                          height: 600,
                          width: MediaQuery.of(context).size.width,
                          color: const Color(0xffF5DEB3),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Text(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris ornare iaculis turpis non varius. Aenean non tortor dui. Nunc imperdiet ante vitae bibendum volutpat. Maecenas mollis bibendum dolor non blandit. Nulla pretium arcu eget urna volutpat, sit amet posuere ipsum congue. Cras facilisis augue vitae est hendrerit, at mollis diam tempor. Cras ligula magna, ultricies nec massa in, sollicitudin vulputate massa. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Cras tincidunt elit in dapibus lacinia. Suspendisse sed enim orci. Donec blandit pharetra efficitur. Donec nec suscipit est, at interdum augue."),
                              CustomPaint(
                                painter: PageCurlPainter(
                                  horizontalStartPoint: horizontalStartPoint,
                                    conicT: conicT,
                                    conicWeight: conicWeight,
                                    nullableChopstick: chopstick,
                                    supportFoldPoint: supportFoldPoint,
                                    cornerPoint: cornerPoint,
                                    bezierStartPoint: bezierStart,
                                    bezierEndPoint: bezierEnd,
                                    bezierControlPoint: bezierControlPoint,
                                    // conicInflectionPoint: conicInflectionPoint,
                                    maximumAngle: maximumDegree
                                ),
                                child: SizedBox.expand(),
                              ),
                            ],
                          ),
                        ),
                    ),
                    ...getPageAnchor(chopstick),
                  ],
                ),

              ),
            ),
          ],
        ));
  }

  /// the statrt position => dy giam => rotate cung chieu kim dong ho.
  ///
  void onPanStart(Offset localPosition) {
    startPoint = Offset(393, localPosition.dy);
    newRotationPoint = null;
    overflowDegree = null;

    /// only accept touch near the edge of the right and the left
    // if (localPosition.dx < (paper_size.width - 40)) {
    //   return;
    // }
    // chopstick ??= createChopstick(initialChopstickRange: 20);
    // calculateFontLayerWidth();
  }

  void onPanEnd(DragEndDetails details) {
    // setState(() {
    //   newRotationPoint = null;
    //   overflowDegree = null;
    //   chopstick = null;
    // });
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

  void getClockWiseVer2(double degree) {
    var newPivotChopstick = chopstick!.copyWith()
      ..rotateBy(degree, pivot: touchPoint);
    chopstick = newPivotChopstick;
  }

  double mapRange2Range({
    required double value,
    required double oldMin,
    required double oldMax,
    required double newMin,
    required double newMax,
  }) {
    return newMin + (value - oldMin) / (oldMax - oldMin) * (newMax - newMin);
  }

  double returnAngleByDegree() {
    return 0;
  }

  void initFirstPoint(Offset localPosition) {
    touchPoint = localPosition;
    if (paper_size.width - localPosition.dx < 22) {
      return;
    }
    if (chopstick == null) {
      startPoint = localPosition;
      chopstick = createChopstick(localPosition, chopstickRadius: 10);
    }
    var chopstickRange = (paper_size.width - localPosition.dx) / pi;
    chopstick!.updateRange(localPosition, chopstickRange);
    fontLayerWidth = localPosition.dx + chopstickRange;
  }

  void onPanUpdateVer2(Offset localPosition, DragUpdateDetails details) {
    /// There is a relationship between dx and dy that affect the rotation angle.
    touchPoint = localPosition;

    if (chopstick == null) {
      startPoint = localPosition;
      chopstick = createChopstick(localPosition, chopstickRadius: 10);
    }

    /// calculate rotation angle
    var dy = startPoint.dy - touchPoint.dy;
    var dx = startPoint.dx - touchPoint.dx;
    var degree = 0.0;
    // The greater dx, the less kRotation
    var kxRotation = mapRange2Range(
        value: dx, oldMin: 0, oldMax: paper_size.width, newMin: 1, newMax: 0.1);
    degree = dy * kxRotation;
    //[0, 54] kyRotation = 1, > 54 kyRotation increase.
    /// dy chi chuyen dong 1/5

    var kyRotation = mapRange2Range(
        value: dy,
        oldMin: 0,
        oldMax: paper_size.height,
        newMin: 1,
        newMax: 0.005);
    degree = degree * kyRotation;
    var kDegree = degree > 0 ? 1.0 : -1.0;

    /// how to find this on different screen
    if (degree.abs() > 60) {
      degree = 60 * kDegree;
    }

    if ((chopstick!.bottomRight.dx < bottomLeftLimitation.dx &&
        degree >= maximumDegree) ||
        (chopstick!.topRight.dx < topLeftLimitation.dx &&
            degree <= -maximumDegree)) {
      return;
    } else if ((chopstick!.bottomRight.dx < bottomLeftLimitation.dx &&
        degree < maximumDegree &&
        degree > 0) ||
        (chopstick!.topRight.dx < topLeftLimitation.dx &&
            degree > -maximumDegree &&
            degree < 0)) {
      overflowDegree ??= degree;

      /// right, up, down
      if (details.delta.dx > 0 ||
          details.delta.dy < 0 ||
          details.delta.dy > 0) {
        if (degree.abs() > overflowDegree!.abs()) {
          newRotationPoint =
          degree > 0 ? bottomLeftLimitation : topLeftLimitation;
        } else {
          newRotationPoint = null;
        }

        /// left
      } else if (details.delta.dx < 0) {
        newRotationPoint =
        degree > 0 ? bottomLeftLimitation : topLeftLimitation;
      }

      /// reset overflow
    } else if (((chopstick!.bottomRight.dx).round() > bottomLeftLimitation.dx &&
        degree < maximumDegree &&
        degree > 0) ||
        ((chopstick!.topRight.dx).round() > topLeftLimitation.dx &&
            degree > -maximumDegree &&
            degree < 0)) {
      overflowDegree = null;
    }

    /// update range first
    var chopstickRange = (paper_size.width - localPosition.dx) / pi;
    chopstick!.updateRange(localPosition, chopstickRange);
    var noRotateChopstick = chopstick!.copyWith();

    fontLayerWidth = localPosition.dx + chopstickRange;

    /// Reach [bottomLeftLimitation], move to that offset and rotate around that point
    if (newRotationPoint != null) {
      double offset;
      if (degree > 0) {
        offset = (bottomLeftLimitation.dx - chopstick!.bottomRight.dx).abs();
      } else {
        offset = (topLeftLimitation.dx - chopstick!.topRight.dx).abs();
      }
      chopstick = chopstick!.translateXby(offset);
    }

    var newPivotChopstick = chopstick!.copyWith()
      ..rotateBy(degree, pivot: newRotationPoint ?? touchPoint);
    chopstick = newPivotChopstick;

    findBottomCornerPoints(
        localPosition, chopstickRange, noRotateChopstick, degree);
    findTopCornerPoints(
        localPosition, chopstickRange, noRotateChopstick, degree);

    cornerPoint = degree > 0 ? bottomCornerPoint : topCornerPoint;

    if (bottomCornerPoint.dy < chopstick!.topRight.dy ||
        topCornerPoint.dy > chopstick!.bottomRight.dy) {
      perpendicularDegree ??= degree.abs();
    } else {
      perpendicularDegree = null;
    }
    supportFoldPoint = getSupportFoldPoint(
        chopstick!, degree, maximumDegree, perpendicularDegree);

    findBezierPoint(degree);
    calculateConicWeight(degree);
    findHorizontalStartPoint(degree);

    lastChopstick = chopstick;

    print("degree $degree");
  }

  void findHorizontalStartPoint(double degree) {
    if (degree == 0) {
      horizontalStartPoint = null;
    } else {
      horizontalStartPoint =
      chopstick!.angle > 0 ? chopstick!.centerBottom : chopstick!.centerTop;

    }

    if(horizontalStartPoint != null && horizontalStartPoint!.dx < topLeftLimitation.dx) {
      horizontalStartPoint = Offset(topLeftLimitation.dx, horizontalStartPoint!.dy);
    }
  }

  void calculateConicWeight(double degree) {
    conicWeight = TwoDFormula.mapValue(degree.abs(), 0, maximumDegree, 1, 4);

    /// conic T start down
    if(chopstick!.topRight.dx == bezierEnd!.dx || chopstick!.bottomRight.dx == bezierEnd!.dx) {
      conicTStartDownPosition ??= degree > 0 ? chopstick!.centerTop.dx : chopstick!.center.dx;

    } else if(bezierEnd!.dx < chopstick!.topRight.dx && chopstick!.topRight.dx < paper_size.width
        || bezierEnd!.dx < chopstick!.bottomRight.dx && chopstick!.bottomRight.dx < paper_size.width
    ){
      conicTStartDownPosition = null;
    }

    /// conicT start up, rename this function
    if(chopstick!.centerTop.dx == paper_size.width || chopstick!.centerTop.dx == paper_size.width) {
      conicTStartUpDegree ??= degree.abs();
    } else if(chopstick!.topRight.dx <= paper_size.width && degree > 0 ||
        chopstick!.bottomRight.dx <= paper_size.width && degree < 0
    ){
      conicTStartUpDegree = null;
    }
    if(conicTStartDownPosition != null && conicTStartUpDegree == null) {
      conicT = TwoDFormula.mapValue(degree > 0 ? chopstick!.centerTop.dx : chopstick!.centerBottom.dx,
          conicTStartDownPosition!, paper_size.width, 1, 0.6);
    } else if(conicTStartDownPosition != null && conicTStartUpDegree != null){
      conicT = TwoDFormula.mapValue(degree.abs(),
          conicTStartUpDegree!.abs(), maximumDegree, 0.6, 0.9);
      conicWeight = 2 * TwoDFormula.mapValue(degree.abs(), conicTStartUpDegree!.abs(), maximumDegree, 1, 4);
      conicWeight = conicWeight >= 4 ? 4: conicWeight;
    } else {
      conicT = 0.99;
    }
  }

  /// duong thang tu corner to bottom, now to have to the fold point
  /// diem start corner point, diem end center.
  /// keo dai tu corner point toi diem duoi
  /// diem start bezier bang giao diem giua left 2 diem ngoai voi duong thang corner va bottom
  void findBezierPoint(double angle) {
    /// bezier start = 1/3 [bottomCornerPoint] point to [chopstick.topRight] point

    bezierStart = TwoDFormula.twoLineIntersection(
        TwoDFormula.convert2OxyCoordinates(Offset(touchPoint.dx, 0)),
        TwoDFormula.convert2OxyCoordinates(
            Offset(touchPoint.dx, paper_size.height)),
        TwoDFormula.convert2OxyCoordinates(
            angle > 0 ? bottomCornerPoint : topCornerPoint),
        TwoDFormula.convert2OxyCoordinates(
            angle > 0 ? chopstick!.topRight : chopstick!.bottomRight));
    /// Corner point go to smaller range of touch point
    bezierStart ??= Offset(cornerPoint!.dx, -cornerPoint!.dy);

    if(angle > 0) {
      if(chopstick!.topRight.dx < paper_size.width) {
        if(topCornerPoint.dx < chopstick!.topRight.dx) {
          bezierEnd = topCornerPoint;
        } else {
          bezierEnd = chopstick!.topRight;
        }
      } else {
        if(chopstick!.centerTop.dx < paper_size.width) {
          bezierEnd = Offset(paper_size.width, 0);
        } else {
          bezierEnd = chopstick!.centerTop;
        }
      }
    } else {
      if(chopstick!.bottomRight.dx < paper_size.width) {
        if(bottomCornerPoint.dx < chopstick!.bottomRight.dx) {
          bezierEnd = bottomCornerPoint;
        } else {
          bezierEnd = chopstick!.bottomRight;
        }
      } else {
        if(chopstick!.centerBottom.dx < paper_size.width) {
          bezierEnd = Offset(paper_size.width, paper_size.height);
        } else {
          bezierEnd = chopstick!.centerBottom;
        }
      }
    }
    bezierEnd = TwoDFormula.convert2OxyCoordinates(bezierEnd!);

    ///TODO fix this problem inside this function
    bezierControlPoint = TwoDFormula.findPointOnPerpendicularBisector(
        bezierStart!, bezierEnd!, 30, angle > 0 ? false : true);


    conicInflectionPoint = TwoDFormula.findConicInflectionPoint(
        bezierStart!, bezierControlPoint!, bezierEnd!, conic_weight);

    bezierStart = TwoDFormula.revert2DartCoordinates(bezierStart!);
    bezierEnd = TwoDFormula.revert2DartCoordinates(bezierEnd!);
    bezierControlPoint =
        TwoDFormula.revert2DartCoordinates(bezierControlPoint!);
    conicInflectionPoint =
        TwoDFormula.revert2DartCoordinates(conicInflectionPoint!);
  }

  void findBottomCornerPoints(Offset localPosition, double chopstickRange,
      Chopstick noRotateChopstick, double degree) {
    if (degree < 0) {
      return;
    }

    var amountToMiddleBottom =
        ((paper_size.width - localPosition.dx) / 2) - chopstickRange;

    /// Find bottom corner point
    bottomCornerPoint = TwoDFormula.findSymmetricPoint(
        Offset(paper_size.width, -paper_size.height),
        Offset(chopstick!.bottomRight.dx + amountToMiddleBottom,
            -chopstick!.bottomRight.dy),
        Offset(
            chopstick!.topRight.dx + amountToMiddleBottom, -chopstick!.topRight.dy));
    bottomCornerPoint = Offset(bottomCornerPoint.dx, -bottomCornerPoint.dy);

    var amountToMiddleTop = TwoDFormula.mapValue(chopstick!.centerTop.dx, noRotateChopstick.centerTop.dx,
        paper_size.width, amountToMiddleBottom, 0);

    if(amountToMiddleTop > 0) {
      topCornerPoint = TwoDFormula.findSymmetricPoint(
          Offset(paper_size.width, 0),
          Offset(chopstick!.bottomRight.dx + amountToMiddleTop,
              -chopstick!.bottomRight.dy),
          Offset(chopstick!.topRight.dx + amountToMiddleTop, -chopstick!.topRight.dy));
      topCornerPoint = TwoDFormula.findIntersectionWithHorizontalLine(topCornerPoint, chopstick!.bottomRight, 0)!;
    } else {
      topCornerPoint = Offset(paper_size.width, 0);
    }
  }

  void findTopCornerPoints(Offset localPosition, double chopstickRange,
      Chopstick noRotateChopstick, double degree) {
    if (degree > 0) {
      return;
    }

    var amountToMiddleTop =
        ((paper_size.width - localPosition.dx) / 2) - chopstickRange;

    /// Find top corner point
    topCornerPoint = TwoDFormula.findSymmetricPoint(
        Offset(paper_size.width, 0),
        Offset(chopstick!.bottomRight.dx + amountToMiddleTop,
            -chopstick!.bottomRight.dy),
        Offset(
            chopstick!.topRight.dx + amountToMiddleTop, -chopstick!.topRight.dy));
    topCornerPoint = Offset(topCornerPoint.dx, -topCornerPoint.dy);

    var amountToMiddleBottom = TwoDFormula.mapValue(chopstick!.centerBottom.dx, noRotateChopstick.centerBottom.dx,
        paper_size.width, amountToMiddleTop, 0);

    if(amountToMiddleBottom > 0) {
      bottomCornerPoint = TwoDFormula.findSymmetricPoint(
          Offset(paper_size.width, -paper_size.height),
          Offset(chopstick!.bottomRight.dx + amountToMiddleBottom,
              -chopstick!.bottomRight.dy),
          Offset(chopstick!.topRight.dx + amountToMiddleBottom, -chopstick!.topRight.dy));
      bottomCornerPoint = TwoDFormula.findIntersectionWithHorizontalLine(bottomCornerPoint, chopstick!.topRight, -paper_size.height)!;
      bottomCornerPoint = TwoDFormula.revert2DartCoordinates(bottomCornerPoint);
    } else {
      bottomCornerPoint = Offset(paper_size.width, paper_size.height);
    }

  }

  /// TODO: rename this function
  /// draw the curl from dóng thẳng từ coner point xuống, điểm uốn là fold point, điểm kết thúc là corner point
  Offset getSupportFoldPoint(Chopstick chopstick, double degree, maximumDegree,
      double? perpendicularDegree) {


    double runValue;
    if (perpendicularDegree == null) {
      /// map value from [0, perpendicularDegree] to [0,40]
      runValue = ((chopstick.angle.abs()) * 30) / maximumDegree;
    } else {
      /// map value from [perpendicularDegree, maximumDegree] to [lastRunValue, 20]
      var lastRunValue = ((lastChopstick!.angle.abs()) * 30) / maximumDegree;
      runValue = ((chopstick.angle.abs() - perpendicularDegree) /
          (60 - perpendicularDegree)) *
          (20 - lastRunValue) +
          lastRunValue;
    }

    /// offset of horizontal line
    var m = 0.0;
    if (degree < 0) {
      m = -runValue;
    } else {
      m = -paper_size.height + runValue;
    }

    var supportFoldPoint = TwoDFormula.findIntersectionWithHorizontalLine(
        Offset(chopstick.bottomRight.dx, -chopstick.bottomRight.dy),
        Offset(chopstick.topRight.dx, -chopstick.topRight.dy),
        m);

    /// Revert to dart coordinate
    return Offset(supportFoldPoint!.dx, -supportFoldPoint.dy);
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

  void curlThePage() {}

  List<Widget> getPageAnchor(Chopstick? chopstick) {
    if (chopstick == null) {
      return [];
    }
    return [
      Positioned(
          left: startPoint.dx - 5,
          top: startPoint.dy - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
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
      if (bezierStart != null)
        Positioned(
            left: bezierStart!.dx - 5,
            top: bezierStart!.dy - 5,
            child: Container(
              height: 10,
              width: 10,
              child: Text("b"),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.purple),
            )),
      if (bezierEnd != null)
        Positioned(
            left: bezierEnd!.dx - 5,
            top: bezierEnd!.dy - 5,
            child: Container(
              height: 10,
              width: 10,
              child: Text("b"),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.purple),
            )),
      if (bezierControlPoint != null)
        Positioned(
            left: bezierControlPoint!.dx - 5,
            top: bezierControlPoint!.dy - 5,
            child: Container(
              height: 10,
              width: 10,
              child: Text("b"),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.purple),
            )),
      if (supportFoldPoint != null)
        Positioned(
            left: supportFoldPoint!.dx - 2.5,
            top: supportFoldPoint!.dy - 2.5,
            child: Container(
              height: 5,
              width: 5,
              child: Text("b"),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blue),
            )),
      // Positioned(
      //     left: topCornerPoint.dx - 5,
      //     top: topCornerPoint.dy - 5,
      //     child: Container(
      //       height: 10,
      //       width: 10,
      //       child: Text("t"),
      //       decoration: const BoxDecoration(
      //           shape: BoxShape.circle, color: Colors.purple),
      //     )),

      // if(conicInflectionPoint != null)
      //   Positioned(
      //       left: conicInflectionPoint!.dx - 5,
      //       top: conicInflectionPoint!.dy - 5,
      //       child: Container(
      //         height: 10,
      //         width: 10,
      //         child: Text("t"),
      //         decoration: const BoxDecoration(
      //             shape: BoxShape.circle, color: Colors.purple),
      //       )),

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

class PageCurlClipper extends CustomClipper<Path> {
  final double maximumAngle;
  final double conicWeight;
  final double conicT;
  final Offset? supportFoldPoint;
  final Offset? cornerPoint;
  final Offset? bezierStartPoint;
  final Offset? bezierEndPoint;
  final Offset? bezierControlPoint;
  final Offset? conicInflectionPoint;
  final Chopstick? nullableChopstick;
  final Offset? horizontalStartPoint;


  PageCurlClipper(
      {
        required this.maximumAngle,
        required this.conicWeight,
        required this.conicT,
        this.nullableChopstick,
        this.supportFoldPoint,
        this.cornerPoint,
        this.bezierStartPoint,
        this.bezierEndPoint,
        this.bezierControlPoint,
        this.conicInflectionPoint,
        this.horizontalStartPoint
      });
  @override
  Path getClip(Size size) {
    final path = Path();

    if (nullableChopstick == null) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(0, 0);
      return path;
    }

    var chopstick = nullableChopstick!;


    if (chopstick.angle == 0) {
      path.moveTo(0, size.height);
      path.lineTo(chopstick.bottomRight.dx, chopstick.bottomRight.dy);
      path.lineTo(chopstick.topRight.dx, chopstick.topRight.dy);
      path.lineTo(0, 0);
    } else {
      if (chopstick.angle > 0) {
        path.moveTo(0, size.height);
      } else {
        path.moveTo(0, 0);
      }

      /// draw the Bezier curve to the fold point
      // var horizontalStartPoint =
      // chopstick.angle > 0 ? chopstick.centerBottom : chopstick.centerTop;
      var horizontalEndPoint = cornerPoint;

      /// Calculate t of the bezier curve by angle [angle, maximumAgle] => [0.5, 0.25]
      double t_c = 0.5 - ((chopstick.angle.abs() / maximumAngle) * 0.25);
      // if (chopstick.angle.abs() > maximumAngle / 2) {
      //   t_c = 0.5;
      // }

      t_c = 0.3;
      Offset horizontalControlPoint = TwoDFormula.calculateControlPoint(
          horizontalStartPoint!, horizontalEndPoint!, supportFoldPoint!, t_c);
      for (double t = 0; t <= t_c; t += 0.01) {
        final point = TwoDFormula.getPointOnQuadraticCurve(t,
            horizontalStartPoint!, horizontalControlPoint, horizontalEndPoint);
        path.lineTo(point.dx, point.dy);
      }
      path.lineTo(supportFoldPoint!.dx, supportFoldPoint!.dy);

      if(bezierEndPoint!.dx <= chopstick.topRight.dx && chopstick.topRight.dx < size.width && chopstick.angle > 0) {
        // path.lineTo(chopstick.topRight.dx, chopstick.topRight.dy);
        var crossPoint = TwoDFormula.conicToCross(cornerPoint!, bezierControlPoint!, bezierEndPoint!,
            conicWeight, chopstick.topRight, chopstick.bottomRight, null);
        
      }  else if(bezierEndPoint!.dx <= chopstick.bottomRight.dx && chopstick.bottomRight.dx < size.width && chopstick.angle < 0) {
        // path.lineTo(chopstick.bottomRight.dx, chopstick.bottomRight.dy);
      } else {
        /// draw from fold point to conic inflection point
        var conicInflectionPoint = TwoDFormula.getPointOnConicCurve(conicT,
            cornerPoint!, bezierControlPoint!, bezierEndPoint!, conicWeight);
        path.lineTo(conicInflectionPoint.dx, conicInflectionPoint.dy);

        /// draw conic curve to end point
        for (double t = conicT; t <= 1; t += 0.01) {
          final point = TwoDFormula.getPointOnConicCurve(t, cornerPoint!,
              bezierControlPoint!, bezierEndPoint!, conicWeight);
          path.lineTo(point.dx, point.dy);
        }
        path.lineTo(bezierEndPoint!.dx, bezierEndPoint!.dy);
      }


      /// draw to finish the boundary
      if (chopstick.angle > 0) {
        chopstick.topRight.dx == size.width ? path.lineTo(size.width, 0) : ();
        path.lineTo(0, 0);
        path.lineTo(0, size.height);
      } else if (chopstick.angle < 0) {
        chopstick.bottomRight.dx == size.width
            ? path.lineTo(size.width, size.height)
            : ();
        path.lineTo(0, size.height);
        path.lineTo(0, 0);
      }
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class PageCurlPainter extends CustomPainter {
  final Offset? supportFoldPoint;
  final Offset? cornerPoint;
  final Offset? bezierStartPoint;
  final Offset? bezierEndPoint;
  final Offset? bezierControlPoint;
  // final Offset? conicInflectionPoint;
  final Chopstick? nullableChopstick;
  final double maximumAngle;
  final double conicWeight;
  final double conicT;
  final Offset? horizontalStartPoint;


  PageCurlPainter(
      {
        this.horizontalStartPoint,
        this.nullableChopstick,
        required this.maximumAngle,
        required this.conicWeight,
        required this.conicT,
        this.supportFoldPoint,
        this.cornerPoint,
        this.bezierStartPoint,
        this.bezierEndPoint,
        this.bezierControlPoint,
        // this.conicInflectionPoint,
      });
  @override
  void paint(Canvas canvas, Size size) {

    if(nullableChopstick == null) {
      return;
    }

    var chopstick = nullableChopstick!;



    drawShadow(chopstick, canvas, conicWeight,  conicT, size);

    // drawShadow(chopstick, canvas, conicWeight, conicT);

    drawShadowSkeleton(chopstick, canvas, conicWeight, conicT, size);

    // drawTurnPagePart(chopstick, canvas, conicWeight, conicT, size);

  }

  void drawShadow(Chopstick chopstick, Canvas canvas, double conicWeight, double conicT, Size size) {


    /// all test
    var shadowPath = Path();

    if (chopstick.angle == 0) {
      shadowPath.moveTo(chopstick.topLeft.dx, chopstick.topLeft.dy);
      shadowPath.lineTo(chopstick.topRight.dx, chopstick.topRight.dy);
      shadowPath.lineTo(chopstick.bottomRight.dx, chopstick.bottomRight.dy);
      shadowPath.lineTo(chopstick.bottomLeft.dx, chopstick.bottomLeft.dy);
      shadowPath.lineTo(chopstick.topLeft.dx, chopstick.topLeft.dy);
    } else {
      shadowPath.moveTo(cornerPoint!.dx, cornerPoint!.dy);
      if(bezierEndPoint!.dx <= chopstick.topRight.dx && chopstick.topRight.dx < size.width && chopstick.angle > 0) {
        // shadowPath.conicTo(bezierControlPoint!.dx, bezierControlPoint!.dy, bezierEndPoint!.dx, bezierEndPoint!.dy, conicWeight);
        // shadowPath.lineTo(chopstick.topRight.dx, chopstick.topRight.dy);
        var crossPoint = conicToCross(cornerPoint!, bezierControlPoint!, bezierEndPoint!,
            conicWeight, chopstick.topRight, chopstick.bottomRight, shadowPath);
        if(crossPoint == null) {
          shadowPath.lineTo(chopstick.topRight.dx, chopstick.topRight.dy);
        }
      } else if(bezierEndPoint!.dx <= chopstick.bottomRight.dx && chopstick.bottomRight.dx < size.width && chopstick.angle < 0) {
        // shadowPath.conicTo(bezierControlPoint!.dx, bezierControlPoint!.dy, bezierEndPoint!.dx, bezierEndPoint!.dy, conicWeight);
        // shadowPath.lineTo(chopstick.bottomRight.dx, chopstick.bottomRight.dy);
        var crossPoint = conicToCross(cornerPoint!, bezierControlPoint!, bezierEndPoint!,
            conicWeight, chopstick.topRight, chopstick.bottomRight, shadowPath);
        if(crossPoint == null) {
          shadowPath.lineTo(chopstick.bottomRight.dx, chopstick.bottomRight.dy);
        }
      } else {

        for (double t = 0.0; t <= conicT; t += 0.01) {
          final point = TwoDFormula.getPointOnConicCurve(
              t, cornerPoint!, bezierControlPoint!, bezierEndPoint!, conicWeight);
          shadowPath.lineTo(point.dx, point.dy);
        }
      }

      shadowPath.lineTo(supportFoldPoint!.dx, supportFoldPoint!.dy);

      /// draw the Bezier curve
      var horizontalStartPoint =
      chopstick.angle > 0 ? chopstick.centerBottom : chopstick.centerTop;
      var horizontalEndPoint = cornerPoint;

      /// Calculate t of the bezier curve by angle [angle, maximumAgle] => [0.5, 0.25]
      double t_c = 0.5 - ((chopstick.angle.abs() / maximumAngle) * 0.25);
      if (chopstick.angle.abs() > maximumAngle / 2) {
        t_c = 0.5;
      }
      Offset horizontalControlPoint = calculateControlPoint(
          horizontalStartPoint, horizontalEndPoint!, supportFoldPoint!, t_c);
      for (double t = t_c; t <= 1; t += 0.01) {
        final point = TwoDFormula.getPointOnQuadraticCurve(t,
            horizontalStartPoint, horizontalControlPoint, horizontalEndPoint);
        shadowPath.lineTo(point.dx, point.dy);
      }
      shadowPath.lineTo(cornerPoint!.dx, cornerPoint!.dy);
    }

    // Offset matrix for shadow
    Offset shadowOffset = Offset(-10, -10); // Move left (-10) and up (-10)
    shadowPath = shadowPath.shift(shadowOffset);

    canvas.drawShadow(
      shadowPath, // The path to cast the shadow from
      Colors.black45, // Shadow color
      10.0, // Shadow elevation
      true, // If true, the shadow is rendered as if the path is opaque
    );
  }

  void drawShadowSkeleton(Chopstick chopstick, Canvas canvas, double conicWeight, double conicT, Size size) {
    var shadowPaint = Paint()
      // ..color = Colors.grey.withOpacity(0.4
        ..color = Colors.purple.withOpacity(0.4)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final shadowPath = Path();

    if (chopstick.angle == 0) {
      shadowPath.moveTo(chopstick.topLeft.dx, chopstick.topLeft.dy);
      shadowPath.lineTo(chopstick.topRight.dx, chopstick.topRight.dy);
      shadowPath.lineTo(chopstick.bottomRight.dx, chopstick.bottomRight.dy);
      shadowPath.lineTo(chopstick.bottomLeft.dx, chopstick.bottomLeft.dy);
      shadowPath.lineTo(chopstick.topLeft.dx, chopstick.topLeft.dy);
      canvas.drawPath(shadowPath, shadowPaint);
      canvas.drawShadow(
        shadowPath, // The path to cast the shadow from
        Colors.green, // Shadow color
        10.0, // Shadow elevation
        true, // If true, the shadow is rendered as if the path is opaque
      );
    } else {
      /// draw the Bezier curve

      // var horizontalStartPoint =
      // chopstick.angle > 0 ? chopstick.centerBottom : chopstick.centerTop;
      var horizontalEndPoint = cornerPoint;
      shadowPath.moveTo(horizontalStartPoint!.dx, horizontalStartPoint!.dy);

      /// Calculate t of the bezier curve by angle [angle, maximumAgle] => [0.5, 0.25]
      double t_c = 0.5 - ((chopstick.angle.abs() / maximumAngle) * 0.25);
      // if (chopstick.angle.abs() > maximumAngle / 2) {
      //   t_c = 0.5;
      // }
      t_c = 0.3;
      // t_c = 1;
      Offset horizontalControlPoint = calculateControlPoint(
          horizontalStartPoint!, horizontalEndPoint!, supportFoldPoint!, t_c);
      shadowPath.quadraticBezierTo(horizontalControlPoint.dx,
          horizontalControlPoint.dy,cornerPoint!.dx, cornerPoint!.dy);




      /// test
      // Paint paint = Paint()
      //   ..color = Colors.blue
      //   ..style = PaintingStyle.stroke
      //   ..strokeWidth = 3;

      Paint linePaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      // Define the points for the Bézier curve
      Offset start = cornerPoint!;  // Starting point
      Offset control = bezierControlPoint!; // Control point
      Offset end = bezierEndPoint!;    // Ending point
      print("end point ${bezierEndPoint}");
      print("chop stick top right ${chopstick.topRight}");
      print("size $size");


      // Draw the curve by calculating points for different t values
      bool wasCrossing = false;
      Offset? crossOffset;
      /// draw conic curve
      for (double t = 0; t <= 1; t += 0.01) {
        double denominator = (1 - t) * (1 - t) + 2 * conicWeight * (1 - t) * t + t * t;
        // Apply the conic Bézier formula: B(t) = (1 - t)^2 P0 + 2(1 - t)t P1 + t^2 P2
        double x = ((1 - t) * (1 - t) * start.dx + 2 * (1 - t) * t * (conicWeight * control.dx) + t * t * end.dx) / denominator;
        double y = ((1 - t) * (1 - t) * start.dy + 2 * (1 - t) * t * (conicWeight * control.dy) + t * t * end.dy) / denominator;

        // Add the calculated point to the path
        shadowPath.lineTo(x, y);
        if (crossOffset == null && isCrossingLine(x, y, chopstick.topRight, chopstick.bottomRight, wasCrossing)) {
          crossOffset =  Offset(x, y);
          Paint paint = Paint()
            ..color = Colors.blue
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3;
          paint.color = Colors.green; // Change color if crossing detected
          canvas.drawCircle(Offset(x, y), 5, paint); // Mark crossing point
        }
      }
      shadowPath.lineTo(end.dx, end.dy);


      if(bezierEndPoint!.dx < chopstick.topRight.dx && chopstick.topRight.dx < size.width && chopstick.angle > 0) {
        if(crossOffset == null) {
          shadowPath.lineTo(chopstick.topRight.dx, chopstick.topRight.dy);
        } else {
          shadowPath.moveTo(crossOffset.dx, crossOffset.dy);
        }
          shadowPath.lineTo(supportFoldPoint!.dx, supportFoldPoint!.dy);
      } else if(bezierEndPoint!.dx < chopstick.bottomRight.dx && chopstick.bottomRight.dx < size.width && chopstick.angle < 0) {
        if(crossOffset == null) {
          shadowPath.lineTo(chopstick.bottomRight.dx, chopstick.bottomRight.dy);
        } else {
          shadowPath.moveTo(crossOffset.dx, crossOffset.dy);
        }

        shadowPath.lineTo(supportFoldPoint!.dx, supportFoldPoint!.dy);
      } else if(bezierEndPoint!.dx == chopstick.topRight.dx && chopstick.topRight.dx < size.width && chopstick.angle > 0) {
        if(crossOffset == null) {
          shadowPath.lineTo(chopstick.topRight.dx, chopstick.topRight.dy);
        } else {
          shadowPath.moveTo(crossOffset.dx, crossOffset.dy);
        }
        shadowPath.lineTo(supportFoldPoint!.dx, supportFoldPoint!.dy);
      } else if(bezierEndPoint!.dx == chopstick.bottomRight.dx && chopstick.bottomRight.dx < size.width && chopstick.angle < 0) {
        if(crossOffset == null) {
          shadowPath.lineTo(chopstick.bottomRight.dx, chopstick.bottomRight.dy);
        } else {
          shadowPath.moveTo(crossOffset.dx, crossOffset.dy);
        }
        shadowPath.lineTo(supportFoldPoint!.dx, supportFoldPoint!.dy);
      }
      else {
          var conicInflectionPoint = TwoDFormula.getPointOnConicCurve(
              conicT, TwoDFormula.convert2OxyCoordinates(cornerPoint!),
              TwoDFormula.convert2OxyCoordinates(bezierControlPoint!),
              TwoDFormula.convert2OxyCoordinates(bezierEndPoint!), conicWeight);





        print("conic tt $conicT");
        conicInflectionPoint = TwoDFormula.revert2DartCoordinates(conicInflectionPoint);
          print("conic inflectionpoint $conicInflectionPoint");
          print("chop stick top right ${chopstick.topRight}");
          print("size ${size.width}");
          canvas.drawCircle(conicInflectionPoint, 5, shadowPaint); // Mark
        if(crossOffset != null) {
          shadowPath.moveTo(crossOffset.dx, crossOffset.dy);
        } else {
          shadowPath.moveTo(conicInflectionPoint.dx, conicInflectionPoint.dy);
        }

          shadowPath.lineTo(supportFoldPoint!.dx, supportFoldPoint!.dy);
      }

      // else if(chopstick!.centerTop.dx  == size.width && chopstick.centerTop.dy > 0
      // ||  chopstick!.centerBottom.dx  == size.width && chopstick.centerBottom.dy < size.height
      // ){
      //   var conicInflectionPoint = TwoDFormula.getPointOnConicCurve(
      //       conicT, TwoDFormula.convert2OxyCoordinates(cornerPoint!),
      //       TwoDFormula.convert2OxyCoordinates(bezierControlPoint!),
      //       TwoDFormula.convert2OxyCoordinates(bezierEndPoint!), conicWeight);
      //
      //
      //
      //
      //
      // print("conic t $conicT");
      // conicInflectionPoint = TwoDFormula.revert2DartCoordinates(conicInflectionPoint);
      //   print("conic inflectionpoint $conicInflectionPoint");
      //   print("chop stick top right ${chopstick.topRight}");
      //   print("size ${size.width}");
      //   canvas.drawCircle(conicInflectionPoint, 5, shadowPaint); // Mark
      //
      //   shadowPath.moveTo(conicInflectionPoint.dx, conicInflectionPoint.dy);
      //   shadowPath.lineTo(supportFoldPoint!.dx, supportFoldPoint!.dy);
      // } else {
      //   shadowPath.lineTo(supportFoldPoint!.dx, supportFoldPoint!.dy);
      // }




      canvas.drawPath(
          shadowPath, // The path to cast the shadow from
          shadowPaint
      );

    }
  }

  bool isNearLine(double x, double y, Offset lineStart, Offset lineEnd) {
    double threshold = 5.0; // Distance threshold for intersection
    double lineLength = (lineEnd - lineStart).distance;
    double distanceToLine = ((lineEnd.dy - lineStart.dy) * x - (lineEnd.dx - lineStart.dx) * y + lineEnd.dx * lineStart.dy - lineEnd.dy * lineStart.dx).abs() /
        lineLength;
    return distanceToLine <= threshold;
  }

  bool isCrossingLine(double x, double y, Offset lineStart, Offset lineEnd, bool wasCrossing) {
    // Cross product to determine the side of the line the point lies on
    double crossProduct = (lineEnd.dx - lineStart.dx) * (y - lineStart.dy) -
        (lineEnd.dy - lineStart.dy) * (x - lineStart.dx);

    bool isCrossing = crossProduct < 0;

    // Detect change in side (crossing)
    return wasCrossing != isCrossing;
  }

  /// refactor this function
  Offset? conicToCross(Offset start, Offset control, Offset end, double conicWeight, Offset lineStart, Offset lineEnd, Path? path) {
    bool wasCrossing = false;
    Offset? crossOffset;
    /// draw conic curve
    for (double t = 0; t <= 1; t += 0.01) {
      double denominator = (1 - t) * (1 - t) + 2 * conicWeight * (1 - t) * t + t * t;
      // Apply the conic Bézier formula: B(t) = (1 - t)^2 P0 + 2(1 - t)t P1 + t^2 P2
      double x = ((1 - t) * (1 - t) * start.dx + 2 * (1 - t) * t * (conicWeight * control.dx) + t * t * end.dx) / denominator;
      double y = ((1 - t) * (1 - t) * start.dy + 2 * (1 - t) * t * (conicWeight * control.dy) + t * t * end.dy) / denominator;

      // Add the calculated point to the path
      path?.lineTo(x, y);
      if (crossOffset == null && isCrossingLine(x, y, lineStart, lineEnd, wasCrossing)) {
        crossOffset =  Offset(x, y);
        return crossOffset;
      }
    }
    path?.lineTo(end.dx, end.dy);
    return null;
  }


  void drawTurnPagePart(Chopstick chopstick, Canvas canvas, double conicWeight, double conicT, Size size) {
    /// Turn page area
    var paint = Paint()
      ..color = const Color(0xffF6F6F6)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    final path = Path();
    // print("bezier start point $bezierStartPoint");

    if (chopstick.angle == 0) {
      path.moveTo(chopstick.topLeft.dx, chopstick.topLeft.dy);
      path.lineTo(chopstick.topRight.dx, chopstick.topRight.dy);
      path.lineTo(chopstick.bottomRight.dx, chopstick.bottomRight.dy);
      path.lineTo(chopstick.bottomLeft.dx, chopstick.bottomLeft.dy);
      path.lineTo(chopstick.topLeft.dx, chopstick.topLeft.dy);
      canvas.drawPath(path, paint);
    } else {
      path.moveTo(cornerPoint!.dx, cornerPoint!.dy);

      /// draw conic curve
      // Calculate and draw intermediate points for t = 0 to 0.5
      if(bezierEndPoint!.dx <= chopstick.topRight.dx && chopstick.topRight.dx < size.width && chopstick.angle > 0) {
        // path.conicTo(bezierControlPoint!.dx, bezierControlPoint!.dy, bezierEndPoint!.dx, bezierEndPoint!.dy, conicWeight);
        var crossPoint = conicToCross(cornerPoint!, bezierControlPoint!, bezierEndPoint!,
            conicWeight, chopstick.topRight, chopstick.bottomRight, path);
        if(crossPoint == null) {
          path.lineTo(chopstick.topRight.dx, chopstick.topRight.dy);
        }
      }  else if (bezierEndPoint!.dx <= chopstick.bottomRight.dx && chopstick.bottomRight.dx < size.width && chopstick.angle < 0) {
        // path.conicTo(bezierControlPoint!.dx, bezierControlPoint!.dy, bezierEndPoint!.dx, bezierEndPoint!.dy, conicWeight);
        var crossPoint = conicToCross(cornerPoint!, bezierControlPoint!, bezierEndPoint!,
            conicWeight, chopstick.topRight, chopstick.bottomRight, path);
        if(crossPoint == null) {
          path.lineTo(chopstick.bottomRight.dx, chopstick.bottomRight.dy);
        }
        // path.lineTo(chopstick.bottomRight.dx, chopstick.bottomRight.dy);
      }
      else {
        for (double t = 0.0; t <= conicT; t += 0.01) {
          final point = TwoDFormula.getPointOnConicCurve(
              t, cornerPoint!, bezierControlPoint!, bezierEndPoint!, conicWeight);
          path.lineTo(point.dx, point.dy);
        }
      }


      // path.lineTo(bezierEndPoint!.dx, bezierEndPoint!.dy);
      // path.conicTo(bezierControlPoint!.dx, bezierControlPoint!.dy, bezierEndPoint!.dx, bezierEndPoint!.dy, 4);
      /// draw the line
      path.lineTo(supportFoldPoint!.dx, supportFoldPoint!.dy);

      // /// draw the Bezier curve
      // var horizontalStartPoint =
      // chopstick.angle > 0 ? chopstick.centerBottom : chopstick.centerTop;
      var horizontalEndPoint = cornerPoint;

      /// Calculate t of the bezier curve by angle [angle, maximumAgle] => [0.5, 0.25]
      double t_c = 0.5 - ((chopstick.angle.abs() / maximumAngle) * 0.25);
      // if (chopstick.angle.abs() > maximumAngle / 2) {
      //   t_c = 0.5;
      // }
      t_c = 0.3;
      Offset horizontalControlPoint = calculateControlPoint(
          horizontalStartPoint!, horizontalEndPoint!, supportFoldPoint!, t_c);
      for (double t = t_c; t <= 1; t += 0.01) {
        final point = TwoDFormula.getPointOnQuadraticCurve(t,
            horizontalStartPoint!, horizontalControlPoint, horizontalEndPoint);
        path.lineTo(point.dx, point.dy);
      }
      path.lineTo(cornerPoint!.dx, cornerPoint!.dy);
      canvas.drawPath(path, paint);
    }
  }

  void paintBoundary() {}

  Offset calculateControlPoint(Offset a, Offset b, Offset c, double t_c) {
    double x1 = (c.dx - (1 - t_c) * (1 - t_c) * a.dx - t_c * t_c * b.dx) /
        (2 * t_c * (1 - t_c));
    double y1 = (c.dy - (1 - t_c) * (1 - t_c) * a.dy - t_c * t_c * b.dy) /
        (2 * t_c * (1 - t_c));
    return Offset(x1, y1);
  }

  void drawNormalChopstick(Canvas canvas, Size size) {}

  void drawAngleChopstick() {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
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
