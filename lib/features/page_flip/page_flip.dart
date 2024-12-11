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

  /// manage increase and rotate front layer
  late final Offset topRightLimitation;
  late final Offset topLeftLimitation;
  late final Offset bottomLeftLimitation;
  late final Offset bottomRightLimitation;

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

    topRightLimitation = Offset(paper_size.width - 50, 0);
    bottomLeftLimitation = Offset(50, paper_size.height);

    bottomRightLimitation = Offset(paper_size.width - 50, paper_size.height);
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

              print("local position ${panStart.localPosition}");
            },
            child: Container(
              color: Color(0xffF5DEB3),
              child: CustomPaint(
                child: Stack(
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
                    Container(
                      decoration: BoxDecoration(color: Colors.blueGrey),
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
                        left: touchPoint.dx,
                        top: touchPoint.dy,
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

  Chopstick createChopstick(Offset localPosition) {
    var distanceFromRight = screen_size.width - localPosition.dx;
    var chopstickRange = (distanceFromRight / 2) - 10;

    var topLeft = Offset(localPosition.dx, 0);
    var topRight = Offset(localPosition.dx + chopstickRange, 0);
    var bottomLeft = Offset(localPosition.dx, topLeft.dy + paper_size.height);
    var bottomRight = Offset(
        localPosition.dx + chopstickRange, topRight.dy + paper_size.height);

    Offset center =
        Offset(localPosition.dx + chopstickRange / 2, paper_size.height / 2);

    /// just for show ui
    this.center = center;

    return Chopstick(paper_size, topLeft, topRight, bottomLeft, bottomRight,
        center, chopstickRange, 0);
  }

  void calculateFontLayerWidth() {
    fontLayerWidth = screen_size.width - chopstick!.range;
  }

  /// chuyển xoay tới mép, chỉ xoay
  ///  1 tay cố định, tay còn lại kéo => vừa tăng kích thước vừa xoay
  ///  điểm cổ dịnh là vị trí tay
  ///
  /// làm sao để mô phỏng điểm gấp
  ///
  /// // mô phỏng đoạn gấp chính xác hơn, xoay đó là xoay

  void onPanUpdate(Offset localPosition, {bool? test}) {
    /// just for display UI
    touchPoint = localPosition;

    if (paper_size.width - localPosition.dx < 22) {
      return;
    }

    if (chopstick == null) {
      startPoint = localPosition;
      chopstick = createChopstick(localPosition);
    }

    chopstick!.updateRange(localPosition, radius: 10);

    fontLayerWidth =
        localPosition.dx + (paper_size.width - localPosition.dx) / 2 - 10;

    /// calculate rotate angle, compare last update point with current point
    var dy = startPoint.dy - touchPoint.dy;
    var degree = 0.0;
    degree = dy;

    // var maximumAngle = findRotateLimitation(chopstick!);
    //
    if (degree == 0) {
      return;
    }

    // ///rotate along clockwise
    // var rotatedChopstick = chopstick!.copyWith()..rotateBy(degree);
    //
    // if(rotatedChopstick.topRight.dx >= topRightLimitation.dx) {
    //   rotatedChopstick = chopstick!.copyWith()..rotateBy(degree, pivot: touchPoint);
    //   if(rotatedChopstick.bottomRight.dx <= bottomLeftLimitation.dx) {
    //     /// translate chopstick bottom left, then rotate
    //     var offset =  (bottomLeftLimitation.dx - chopstick!.bottomRight.dx).abs();
    //     chopstick!.translateXby(offset);
    //     rotatedChopstick = chopstick!.copyWith()..rotateBy(degree, pivot: bottomLeftLimitation);
    //
    //     /// if reach maximum bottom left corner, rotate to limit point
    //     if(rotatedChopstick.topRight.dy > bottomCornerPoint.dy &&
    //         (rotatedChopstick.topRight.dy - bottomCornerPoint.dy) > 50) {
    //       chopstick!.rotateBy(54.666656494140625, pivot: bottomLeftLimitation);
    //     } else {
    //       chopstick!.rotateBy(degree, pivot: bottomLeftLimitation);
    //     }
    //   } else {
    //     chopstick = rotatedChopstick;
    //   }
    // }
    //
    // else {
    //   chopstick = rotatedChopstick;
    // }
    if(degree > 0) {
      getClockwiseChopstick(degree);
    }  else {
      getUClockwiseChopstick(degree);
    }


    /// center is the center, tới điểm giới hạn trên, thì tâm xoay chuyển thành touch point
    /// increase the range

    /// find corner point
    /// top corner point
    var chopstickRadius = 25;
    bottomCornerPoint = findSymmetricPoint(
        Offset(paper_size.width, -paper_size.height),
        Offset(chopstick!.bottomRight.dx + chopstickRadius,
            -chopstick!.bottomRight.dy),
        Offset(
            chopstick!.topRight.dx + chopstickRadius, -chopstick!.topRight.dy));

    /// revert to dart coordinate
    bottomCornerPoint = Offset(bottomCornerPoint.dx, -bottomCornerPoint.dy);

    /// bottom corner point
    topCornerPoint = findSymmetricPoint(
        Offset(paper_size.width, 0),
        Offset(chopstick!.bottomRight.dx + chopstickRadius,
            -chopstick!.bottomRight.dy),
        Offset(
            chopstick!.topRight.dx + chopstickRadius, -chopstick!.topRight.dy));

    /// revert to dart coordinate
    topCornerPoint = Offset(topCornerPoint.dx, -topCornerPoint.dy);

    setState(() {});
  }

  void getClockwiseChopstick(double degree) {
    /// Rotate along clockwise
    var newChopstick = chopstick!.copyWith()..rotateBy(degree);
    /// Reach top right limitation, move center to touch point
    if (newChopstick.topRight.dx >= topRightLimitation.dx) {
      var newPivotChopstick = chopstick!.copyWith()
        ..rotateBy(degree, pivot: touchPoint);

      /// Reach to bottom left limitation, translate to that point, then rotate around that point
      if (newPivotChopstick.bottomRight.dx <= bottomLeftLimitation.dx) {
        var offset =
            (bottomLeftLimitation.dx - chopstick!.bottomRight.dx).abs();
        chopstick!.translateXby(offset);
        var offsetChopstick = chopstick!.copyWith()
          ..rotateBy(degree, pivot: bottomLeftLimitation);

        /// Corner point below the bottom right point
        if (offsetChopstick.topRight.dy > bottomCornerPoint.dy &&
            (offsetChopstick.topRight.dy - bottomCornerPoint.dy) > 50) {
          chopstick!.rotateBy(54.666656494140625, pivot: bottomLeftLimitation);
        } else {
          chopstick!.rotateBy(degree, pivot: bottomLeftLimitation);
        }
      } else {
        chopstick = newPivotChopstick;
      }
    } else {
      chopstick = newChopstick;
    }
  }

  void getUClockwiseChopstick(double degree) {
    /// Mark: under park, rotate along anticlockwise
    var newChopstick = chopstick!.copyWith()..rotateBy(degree);
    if(newChopstick.bottomRight.dx >= bottomRightLimitation.dx) {
      var newPivotChopstick = chopstick!.copyWith()..rotateBy(degree, pivot: touchPoint);
      /// Reach to bottom right limitation, translate to that point, then rotate around that point
      if(newPivotChopstick.topRight.dx <= topLeftLimitation.dx) {

        var offset =  (topLeftLimitation.dx - chopstick!.topRight.dx).abs();
        chopstick!.translateXby(offset);
        var offsetChopstick = chopstick!.copyWith()..rotateBy(degree, pivot: topLeftLimitation);

        /// Corner point below the bottom right point
        if(offsetChopstick.bottomRight.dy < topCornerPoint.dy &&
            (topCornerPoint.dy - offsetChopstick.topRight.dy ) > 50) {
          chopstick!.rotateBy(-54.666656494140625, pivot: topLeftLimitation);
        } else {
          chopstick!.rotateBy(degree, pivot: topLeftLimitation);
        }
      } else {
        chopstick = newPivotChopstick;
      }
    }
    else {
      chopstick = newChopstick;
    }
  }

  double findRotateLimitation(Chopstick chopstick) {
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
  }

  void testRotate() {
    setState(() {
      // chopstick!.rotateBy(5);
      var offset = (bottomLeftLimitation.dx - chopstick!.bottomRight.dx).abs();
      print("offset $offset");
      chopstick = chopstick!.copyWith()..translateXby(offset);
      chopstick!.rotateBy(35, pivot: bottomLeftLimitation);
    });
  }

  /// Hàm tìm điểm đối xứng của [point] qua đường thẳng xác định bởi [linePoint1] và [linePoint2].
  Offset findSymmetricPoint(
      Offset point, Offset linePoint1, Offset linePoint2) {
    // Tọa độ của đường thẳng
    double x1 = linePoint1.dx, y1 = linePoint1.dy;
    double x2 = linePoint2.dx, y2 = linePoint2.dy;
    double px = point.dx, py = point.dy;

    // Tính hệ số A, B, C của đường thẳng Ax + By + C = 0
    double A = y2 - y1;
    double B = x1 - x2;
    double C = x2 * y1 - x1 * y2;

    // Tính điểm đối xứng
    double denominator = A * A + B * B;
    double xSymmetric = px - 2 * A * (A * px + B * py + C) / denominator;
    double ySymmetric = py - 2 * B * (A * px + B * py + C) / denominator;

    return Offset(xSymmetric, ySymmetric);
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
                shape: BoxShape.circle, color: Colors.brown),
          )),
      Positioned(
          left: topCornerPoint.dx - 5,
          top: topCornerPoint.dy - 5,
          child: Container(
            height: 10,
            width: 10,
            child: Text("b"),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.brown),
          )),
    ];
  }
}

class PageAnchor extends StatelessWidget {
  final Chopstick? chopstick;
  const PageAnchor({super.key, this.chopstick});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            left: chopstick?.topLeft.dx ?? 0,
            top: chopstick?.topLeft.dy ?? 0,
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.brown),
            )),
        Positioned(
            left: chopstick?.topRight.dx ?? 0,
            top: chopstick?.topRight.dy ?? 0,
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.brown),
            )),
        Positioned(
            left: chopstick?.bottomRight.dx ?? 0,
            top: chopstick?.bottomRight.dy ?? 0,
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.brown),
            )),
        Positioned(
            left: chopstick?.bottomLeft.dx ?? 0,
            top: chopstick?.bottomLeft.dy ?? 0,
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.brown),
            )),
      ],
    );
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
  Chopstick(this.paperSize, this.topLeft, this.topRight, this.bottomLeft,
      this.bottomRight, this.center, this.range, this.angle);

  rotateBy(double degree,

      /// if != null, rotate around this point
      {Offset? pivot}) {
    var centerOxy = pivot != null
        ? Offset(pivot.dx, -pivot.dy)
        : Offset(center.dx, -center.dy);
    var topLeftOxy = Offset(topLeft.dx, -topLeft.dy);
    var topRightOxy = Offset(topRight.dx, -topRight.dy);
    var bottomLeftOxy = Offset(bottomLeft.dx, -bottomLeft.dy);
    var bottomRightOxy = Offset(bottomRight.dx, -bottomRight.dy);

    /// rotate
    topLeftOxy = rotateAround(topLeftOxy, centerOxy, degree);
    topRightOxy = rotateAround(topRightOxy, centerOxy, degree);
    bottomLeftOxy = rotateAround(bottomLeftOxy, centerOxy, degree);
    bottomRightOxy = rotateAround(bottomRightOxy, centerOxy, degree);

    /// MARK: top
    // /// Find intersection between the right chopstick line (topRight and bottomRight) and top (Ox)
    var topLeadingIntersection =
        findIntersectionWithOX(bottomLeftOxy, topLeftOxy);
    var topTrailingIntersection =
        findIntersectionWithOX(bottomRightOxy, topRightOxy);

    /// if overflow find intersection with vertical line zx = paperSize.width
    if (topLeadingIntersection!.dx > paperSize.width) {
      topLeadingIntersection = findIntersectionWithVerticalLine(
          bottomLeftOxy, topLeftOxy, paperSize.width);
    }

    if (topTrailingIntersection!.dx > paperSize.width) {
      topTrailingIntersection = findIntersectionWithVerticalLine(
          bottomRightOxy, topRightOxy, paperSize.width);
    }

    /// revert to dart coordinate
    topLeft = Offset(topLeadingIntersection!.dx, -topLeadingIntersection!.dy);
    topRight = Offset(topTrailingIntersection!.dx, -topTrailingIntersection.dy);

    ///MARK: bottom
    var bottomLeadingIntersection = findIntersectionWithHorizontalLine(
        bottomLeftOxy, topLeftOxy, -paperSize.height);
    var bottomTrailingIntersection = findIntersectionWithHorizontalLine(
        bottomRightOxy, topRightOxy, -paperSize.height);

    /// if overflow find intersection with vertical line x = paperSize.width
    if (bottomLeadingIntersection!.dx > paperSize.width) {
      bottomLeadingIntersection = findIntersectionWithVerticalLine(
          bottomLeftOxy, topLeftOxy, paperSize.width);
    }

    if (bottomTrailingIntersection!.dx > paperSize.width) {
      bottomTrailingIntersection = findIntersectionWithVerticalLine(
          bottomRightOxy, topRightOxy, paperSize.width);
    }

    /// revert to dart coordinate
    bottomLeft =
        Offset(bottomLeadingIntersection!.dx, -bottomLeadingIntersection.dy);
    bottomRight =
        Offset(bottomTrailingIntersection!.dx, -bottomTrailingIntersection.dy);

    angle = degree;
  }

  Offset? findIntersectionWithOX(Offset p1, Offset p2) {
    if (p1.dx == p2.dx) {
      return null;
    }

    final double m = (p2.dy - p1.dy) / (p2.dx - p1.dx);
    final double c = p1.dy - m * p1.dx;

    final double x = -c / m;

    return Offset(x, 0);
  }

  Offset? findIntersectionWithHorizontalLine(Offset p1, Offset p2, double M) {
    // Check if the line is vertical (parallel to the y-axis)
    if (p1.dx == p2.dx) {
      return null; // No intersection with horizontal line, because the line is vertical
    }

    // Calculate the slope (m) of the line
    final double m = (p2.dy - p1.dy) / (p2.dx - p1.dx);

    // Calculate the y-intercept (c) using one of the points
    final double c = p1.dy - m * p1.dx;

    // Find the x-coordinate where the line intersects the horizontal line y = M
    final double x = (M - c) / m;

    // Return the intersection point as an Offset (x, M)
    return Offset(x, M);
  }

  Offset? findIntersectionWithVerticalLine(Offset p1, Offset p2, double V) {
    // Check if the line is vertical (parallel to the y-axis)
    if (p1.dx == p2.dx) {
      return null; // No intersection with vertical line, because the line is vertical
    }

    // Calculate the slope (m) of the line
    final double m = (p2.dy - p1.dy) / (p2.dx - p1.dx);

    // Calculate the y-intercept (c) using one of the points
    final double c = p1.dy - m * p1.dx;

    // Find the y-coordinate where the line intersects the vertical line x = V
    final double y = m * V + c;

    // Return the intersection point as an Offset (V, y)
    return Offset(V, y);
  }

  Offset? findIntersectionWithOY(Offset p1, Offset p2) {
    // Check if the line is vertical
    if (p1.dx == p2.dx) {
      return null; // No intersection with OY (vertical line)
    }

    // Calculate slope (m) and intercept (c)
    final double m = (p2.dy - p1.dy) / (p2.dx - p1.dx);
    final double c = p1.dy - m * p1.dx;

    // Intersection with OY occurs at x = 0
    return Offset(0, c);
  }

  updateRange(Offset localPosition, {required double radius}) {
    var distanceFromRight = this.paperSize.width - localPosition.dx;
    var range = (distanceFromRight / 2) - radius;

    topLeft = Offset(localPosition.dx, 0);
    topRight = Offset(localPosition.dx + range, 0);
    bottomLeft = Offset(localPosition.dx, topLeft.dy + paperSize.height);
    bottomRight =
        Offset(localPosition.dx + range, topRight.dy + paperSize.height);
    center = Offset(localPosition.dx + range / 2, paperSize.height / 2);

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
      double? range,
      double? angle}) {
    return Chopstick(
        paperSize ?? this.paperSize,
        topLeft ?? this.topLeft,
        topRight ?? this.topRight,
        bottomLeft ?? this.bottomLeft,
        bottomRight ?? this.bottomRight,
        center ?? this.center,
        range ?? this.range,
        angle ?? this.angle);
  }

  void translateXby(double offset) {
    topRight = Offset(topRight.dx - offset, topRight.dy);
    topLeft = Offset(topLeft.dx - offset, topLeft.dy);
    bottomRight = Offset(bottomRight.dx - offset, bottomRight.dy);
    bottomLeft = Offset(bottomLeft.dx - offset, bottomLeft.dy);
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
