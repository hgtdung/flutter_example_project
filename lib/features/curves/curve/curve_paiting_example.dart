import 'package:flutter/material.dart';

class CurvePaintingExample extends StatelessWidget {
  const CurvePaintingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Find Control Point')),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: CustomPaint(
          painter: ClippingImageCurvePainter(),
          child: Container(),
        ),
      ),
    );
  }
}

class ClippingImageCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Size size = Size(300, 400);

    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.addRect(Rect.fromLTRB(0, 0, 300, size.height));


    /// Quadratic Bezier curve
    Offset startPoint = Offset(0, 400 - 40);
    Offset endPoint = Offset( 300 / 2, 400);

    Offset controlPoint = Offset(
        50, size.height - 5 );

    path.moveTo(startPoint.dx, startPoint.dy);
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    canvas.drawPath(path, paint);
    //
    // // Visualize points
    Paint pointPaint = Paint()..color = Colors.green;
    canvas.drawCircle(controlPoint, 5, pointPaint); // Control point
    canvas.drawCircle(startPoint, 5, pointPaint); // Start point
    canvas.drawCircle(endPoint, 5, pointPaint); // End point


    /// Cubic Bezier Curve
    final cStartPoint = Offset(0, 150);
    final cEndPoint = Offset(size.width, 0);
    final controlPoint1 = Offset(95, -15);
    final controlPoint2 = Offset(110, size.height - 110);
    path.moveTo(cStartPoint.dx, cStartPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy, cEndPoint.dx, cEndPoint.dy);

    pointPaint.color = Colors.red;
    canvas.drawPath(path, paint);
    canvas.drawCircle(cStartPoint, 5, pointPaint); // Control point
    canvas.drawCircle(cEndPoint, 5, pointPaint); // Control
    canvas.drawCircle(controlPoint1, 5, pointPaint); // Start point
    canvas.drawCircle(controlPoint2, 5, pointPaint); // End point
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
