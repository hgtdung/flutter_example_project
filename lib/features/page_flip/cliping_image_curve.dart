import 'package:flutter/material.dart';

class ClippingImageCurve extends StatelessWidget {
  const ClippingImageCurve({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tìm Control Point')),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: CustomPaint(
          painter: ControlPointPainter(),
          child: Container(),
        ),
      ),
    );
  }
}

class ControlPointPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Size size = Size(300, 400);
    Offset startPoint = Offset(0, 400 - 40);
    Offset endPoint = Offset( 300 / 2, 400);

    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    Path path = Path();
    path.addRect(Rect.fromLTRB(0, 0, 300, size.height));


    Offset controlPoint = Offset(
        50, size.height - 5 );
    
    // // Start and end points
    // Offset startPoint = Offset(50, 300);
    // Offset endPoint = Offset(350, 300);
    //
    // // Known point on the curve (t = 0.5)
    // Offset midPoint = Offset(200, 150);
    //
    // Calculate control point
    // Offset controlPoint = Offset(
    //   2 * midPoint.dx - 0.5 * startPoint.dx - 0.5 * endPoint.dx,
    //   2 * midPoint.dy - 0.5 * startPoint.dy - 0.5 * endPoint.dy,
    // );
    //
    // // Draw the quadratic Bézier curve
    // Paint paint = Paint()
    //   ..color = Colors.blue
    //   ..strokeWidth = 3
    //   ..style = PaintingStyle.stroke;
    //
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
    Paint pointPaint = Paint()..color = Colors.red;
    canvas.drawCircle(controlPoint, 5, pointPaint); // Control point
    canvas.drawCircle(startPoint, 5, pointPaint); // Start point
    canvas.drawCircle(endPoint, 5, pointPaint); // End point
    // canvas.drawCircle(midPoint, 5, pointPaint); // Known point on curve
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void main() {
  runApp(MaterialApp(home: ClippingImageCurve()));
}