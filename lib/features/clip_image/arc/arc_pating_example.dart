import 'package:flutter/material.dart';

class ArcPaintingExample extends StatefulWidget {
  const ArcPaintingExample({super.key});

  @override
  State<ArcPaintingExample> createState() => _ArcPaintingExampleState();
}

class _ArcPaintingExampleState extends State<ArcPaintingExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Find Control Point')),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: CustomPaint(
          painter: ClippingImageArcPainter(),
          child: Container(),
        ),
      ),
    );
  }
}

class ClippingImageArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Size size = Size(300, 400);

    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Path path = Path();
    // path.addRect(Rect.fromLTRB(0, 0, 300, size.height));
    //
    final path = Path();

    // Define the rectangle bounds for the arc
    final rect = Rect.fromCircle(center: Offset(100, 100), radius: 50);

    // Draw an arc from 0 to 90 degrees (pi/2 radians)
    path.arcTo(
      rect,
      0,              // Start angle (radians)
      3.14 / 2 ,       // Sweep angle (90 degrees in radians)
      false,          // forceMoveTo
    );

    canvas.drawPath(path, paint);
    canvas.drawPath(path, paint);
    //

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
