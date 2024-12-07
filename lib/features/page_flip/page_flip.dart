import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_example_project/features/page1_screen/page1_screen.dart';

class PageFlipWidget extends StatefulWidget {
  const PageFlipWidget({super.key});

  @override
  State<PageFlipWidget> createState() => _PageFlipWidgetState();
}

class _PageFlipWidgetState extends State<PageFlipWidget>
    with SingleTickerProviderStateMixin {

  /// constants
  late final Size screen_size ;
  late final Size paper_size;

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



  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    screen_size = MediaQuery.of(context).size;
    paper_size = Size(screen_size.width, 600);
    // onPanUpdate(Offset(321.0, 292.7));
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
              child: ElevatedButton(onPressed: () {
                testRotate();
              }, child: Text("test rotate")),
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
                          ElevatedButton(onPressed: () {
                            var p = turnPageTransform(Offset3D(200, 150, 0));
                            print("Point P ${p}");
                            findFoldPoint(Size(200, 200));
                          }, child: Text("test calculate func")),
                          Spacer(),
                          Text("Hello")

                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey
                      ),
                      child: SizedBox(
                        height: 600,
                      width: fontLayerWidth?? paper_size.width,
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
                            width: chopstick?.range?? 0,
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
                        decoration:const BoxDecoration(
                      shape: BoxShape.circle
                          ,color: Colors.red
                    ),)),
                    Positioned(
                        left: touchPoint.dx,
                        top: touchPoint.dy,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration:const BoxDecoration(
                              shape: BoxShape.circle
                              ,color: Colors.green
                          ),)),
                    Positioned(
                        left: center.dx,
                        top: center.dy,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration:const BoxDecoration(
                              shape: BoxShape.circle
                              ,color: Colors.brown
                          ),)),
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
    if(localPosition.dx < (paper_size.width - 40)) {
      return;
    }
    // chopstick ??= createChopstick(initialChopstickRange: 20);
    // calculateFontLayerWidth();
  }

  void  onPanEnd(Offset localPosition) {
    chopstick = null;
  }

  Chopstick createChopstick(Offset localPosition) {

    var distanceFromRight = screen_size.width - localPosition.dx;
    var chopstickRange = (distanceFromRight / 2)  - 10;

    var topLeft = Offset(localPosition.dx, 0);
    var topRight = Offset(localPosition.dx  + chopstickRange, 0);
    var bottomLeft = Offset(localPosition.dx, topLeft.dy + paper_size.height);
    var bottomRight = Offset(localPosition.dx + chopstickRange, topRight.dy + paper_size.height);


    Offset center = Offset(localPosition.dx + chopstickRange / 2 , paper_size.height / 2);
    /// just for show ui
    this.center = center;

    return  Chopstick(paper_size,
        topLeft,
        topRight, bottomLeft, bottomRight, center, chopstickRange);
  }


  void calculateFontLayerWidth() {
    fontLayerWidth = screen_size.width - chopstick!.range;
  }

  void onPanUpdate(Offset localPosition) {


    touchPoint = localPosition;
    if(paper_size.width - localPosition.dx < 22) {
      return;
    }
    if(chopstick == null) {
      /// just for display UI
      startPoint = localPosition;

      ///initial chopstick
     chopstick = createChopstick(localPosition);
    }

    if(paper_size.width - touchPoint.dx < 10) {
      return;
    }

    // return;
    var chopstickRadius = 0;
    /// offset from right

    var distanceFromRight = screen_size.width - localPosition.dx;

    chopstick!.updateRange(localPosition, radius: 10);

    /// calculate rotate angle, compare last update point with current point
    // var degree = 0.0;
    // if(localPosition.dy != lastUpdatePoint.dy) {
    //   var distance = lastUpdatePoint.dy - localPosition.dy;
    //   degree = distance * 1.5;
    // }

    // pageCurlWidth = screenSize.width - chopstickRadius - chopstickRange;
    // fontLayerWidth = screen_size.width - chopstick!.range;
    fontLayerWidth =  localPosition.dx + (paper_size.width - localPosition.dx) / 2 - 10;



    /// handle this chopstick do not create chopstick
    /// handle chopstick range => update chopstcik range.
    /// find the symetrical point of the corner.

    // if(degree != 0 ) {
      // chopstick!.rotateBy(degree);
    // }


    setState(() {});
  }

  void testRotate() {
    setState(() {
      chopstick!.rotateBy(5);
    });
  }

  void findBottomLeftCornerPoint(Chopstick chopstick) {
    // var bottomRightCornerPoint = symmetricPointWithLine()
  }

  Offset symmetricPointWithLine(
      double px, double py, double x1, double y1, double x2, double y2) {
    // Calculate the coefficients of the line equation Ax + By + C = 0
    double A = y2 - y1;
    double B = x1 - x2;
    double C = x2 * y1 - x1 * y2;

    // Denominator for projection calculations
    final double denominator = A * A + B * B;

    // Calculate the projection point Q(x_q, y_q)
    final double xQ = (B * (B * px - A * py) - A * C) / denominator;
    final double yQ = (A * (-B * px + A * py) - B * C) / denominator;

    // Calculate the symmetric point
    final double xSym = 2 * xQ - px;
    final double ySym = 2 * yQ - py;

    return Offset(xSym, ySym);
  }

  Offset3D turnPageTransform(Offset3D vi) {

    // Get the current input vertex.
    var A = -1;
    var theta = 45;
    var rho = 0;

    // Radius of the circle circumscribed by vertex (vi.x, vi.y) around A on the x-y plane
    var R     = sqrt(vi.x * vi.x + pow(vi.y - A, 2));
    // Now get the radius of the cone cross section intersected by our vertex in 3D space.
    var r     = R * sin(theta);
    // Angle subtended by arc |ST| on the cone cross section.
    var beta  = asin(vi.x / R) / sin(theta);

    // *** MAGIC!!! ***
    Offset3D v1 = Offset3D(0, 0, 0);
    Offset3D v0 = Offset3D(0, 0, 0);
    v1.x  = r * sin(beta);
    v1.y  = R + A - r * (1 - cos(beta)) * sin(theta);
    v1.z  = r * (1 - cos(beta)) * cos(theta);
    // Apply a basic rotation transform around the y axis to rotate the curled page.
    // These two steps could be combined through simple substitution, but are left
    // separate to keep the math simple for debugging and illustrative purposes.

    v0.x = (v1.x * cos(rho) - v1.z * sin(rho));
    v0.y =  v1.y;
    v0.z = (v1.x * sin(rho) + v1.z * cos(rho));
    return v0;


  }

  Offset3D? findFoldPoint(Size size) {
    for (var i = size.width; i > 0; i--) {
      var bottomPoint = Offset3D(i.toDouble(), 0,0);
      var transformedPoint = turnPageTransform(bottomPoint);
      var roundTransformedPoint = Offset3D(transformedPoint.x.floor().toDouble(),
          transformedPoint.y.floor().toDouble(), transformedPoint.z);
      if(roundTransformedPoint.z == 0.0 && roundTransformedPoint.y == 0.0) {
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
            decoration:const BoxDecoration(
                shape: BoxShape.circle
                ,color: Colors.brown
            ),)),
      Positioned(
          left: chopstick.topRight.dx - 5,
          top: chopstick.topRight.dy - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration:const BoxDecoration(
                shape: BoxShape.circle
                ,color: Colors.brown
            ),)),
      Positioned(
          left: chopstick.bottomRight.dx - 5,
          top: chopstick.bottomRight.dy - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration:const BoxDecoration(
                shape: BoxShape.circle
                ,color: Colors.brown
            ),)),
      Positioned(
          left: chopstick.bottomLeft.dx - 5,
          top: chopstick.bottomLeft.dy - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration:const BoxDecoration(
                shape: BoxShape.circle
                ,color: Colors.brown
            ),)),
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
            left: chopstick?.topLeft.dx??0,
            top: chopstick?.topLeft.dy??0,
            child: Container(
              height: 10,
              width: 10,
              decoration:const BoxDecoration(
                  shape: BoxShape.circle
                  ,color: Colors.brown
              ),)),
        Positioned(
            left: chopstick?.topRight.dx??0,
            top: chopstick?.topRight.dy??0,
            child: Container(
              height: 10,
              width: 10,
              decoration:const BoxDecoration(
                  shape: BoxShape.circle
                  ,color: Colors.brown
              ),)),
        Positioned(
            left: chopstick?.bottomRight.dx??0,
            top: chopstick?.bottomRight.dy??0,
            child: Container(
              height: 10,
              width: 10,
              decoration:const BoxDecoration(
                  shape: BoxShape.circle
                  ,color: Colors.brown
              ),)),
        Positioned(
            left: chopstick?.bottomLeft.dx??0,
            top: chopstick?.bottomLeft.dy??0,
            child: Container(
              height: 10,
              width: 10,
              decoration:const BoxDecoration(
                  shape: BoxShape.circle
                  ,color: Colors.brown
              ),)),
      ],
    );
  }
}


class VerticesDraw extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
        ..color = Colors.red;
    
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
        ..color = Color(0xffF5DEB3)// Line color
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
  Chopstick(this.paperSize, this.topLeft, this.topRight, this.bottomLeft, this.bottomRight, this.center,
      this.range);

  rotateBy(double degree) {

    var centerOxy =  Offset(center.dx, -center.dy);
    var topLeftOxy =  Offset(topLeft.dx, -topLeft.dy);
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
    var topLeadingIntersection =  findIntersectionWithOX(bottomLeftOxy, topLeftOxy);
    var topTrailingIntersection = findIntersectionWithOX(bottomRightOxy, topRightOxy);
    print("before top leading intersection${topTrailingIntersection}");

    /// if overflow find intersection with vertical line zx = paperSize.width
    if(topLeadingIntersection!.dx > paperSize.width) {
      topLeadingIntersection =  findIntersectionWithVerticalLine(bottomLeftOxy, topLeftOxy, paperSize.width);
      print("top leeading intersection ${topLeadingIntersection}");
    }

    if(topTrailingIntersection!.dx > paperSize.width) {
      topTrailingIntersection = findIntersectionWithVerticalLine(bottomRightOxy, topRightOxy, paperSize.width);
      print("top trailidng intersection ${topTrailingIntersection}");
    }

    /// revert to dart coordinate
    topLeft = Offset(topLeadingIntersection!.dx, -topLeadingIntersection!.dy);
    topRight = Offset(topTrailingIntersection!.dx, -topTrailingIntersection.dy);

    ///MARK: bottom
    var bottomLeadingIntersection =  findIntersectionWithHorizontalLine(bottomLeftOxy, topLeftOxy, -paperSize.height);
    var bottomTrailingIntersection = findIntersectionWithHorizontalLine(bottomRightOxy, topRightOxy, -paperSize.height);

    /// if overflow find intersection with vertical line x = paperSize.width
    if(bottomLeadingIntersection!.dx > paperSize.width) {
      bottomLeadingIntersection =  findIntersectionWithVerticalLine(bottomLeftOxy, topLeftOxy, paperSize.width);
    }

    if(bottomTrailingIntersection!.dx > paperSize.width) {
      bottomTrailingIntersection = findIntersectionWithVerticalLine(bottomRightOxy, topRightOxy, paperSize.width);
    }

    /// revert to dart coordinate
    bottomLeft = Offset(bottomLeadingIntersection!.dx, -bottomLeadingIntersection.dy);
    bottomRight =  Offset(bottomTrailingIntersection!.dx, -bottomTrailingIntersection.dy);


    print("top left ${topLeft}");
    print("top right ${topRight}");


    // var bottomIntersection =  findIntersectionWithHorizontalLine(Offset(bottomRight.dx, -bottomRight.dy), topRight, -paperSize.height);
    // bottomRight = bottomIntersection!;
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
    var range =  (distanceFromRight/ 2) - radius;

    topLeft = Offset(localPosition.dx, 0);
    topRight = Offset(localPosition.dx  + range, 0);
    bottomLeft = Offset(localPosition.dx, topLeft.dy + paperSize.height);
    bottomRight = Offset(localPosition.dx + range, topRight.dy + paperSize.height);

    this.range = range;
  }

  /// normally user will do two behavior at the same time
}

Offset rotateAround(Offset pointA, Offset pivotB, double angle) {
  double angleRadian = -angle * (pi / 180);
  // Translate A relative to B
  final double translatedX = pointA.dx - pivotB.dx;
  final double translatedY = pointA.dy - pivotB.dy;

  // Perform rotation
  final double rotatedX = translatedX * cos(angleRadian) - translatedY * sin(angleRadian);


  final double rotatedY = translatedX * sin(angleRadian) + translatedY * cos(angleRadian);

  // Translate back to the original position relative to B
  final double finalX = rotatedX + pivotB.dx;
  final double finalY = rotatedY + pivotB.dy;

  var finalResult =  Offset(finalX, finalY);
  return finalResult;
}
