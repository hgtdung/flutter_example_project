import 'package:flutter/material.dart';

class ClippingImageCurveExample extends StatefulWidget {
  const ClippingImageCurveExample({super.key});

  @override
  State<ClippingImageCurveExample> createState() => _ClippingImageCurveExampleState();
}

class _ClippingImageCurveExampleState extends State<ClippingImageCurveExample> {
  final Size imageSize = const Size(300, 400);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      const SizedBox(
        height: 100,
      ),
      Center(
        child: Stack(
          children: [
            ClipPath(
              clipper: CurveClippingClass(),
              child: Container(
                height: imageSize.height,
                width: imageSize.width,
                child: Image.asset("assets/images/corn_field.jpg", fit: BoxFit.fill,),
                // child: Text("123"),
              ),
            ),
          ],
        ),
      )
    ]));
  }
}

class CurveClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    /// Using quadratic Bezier curve
    /// The intersection of two tangents is the control point.
    final startPoint = Offset(0, size.height - 40);
    final controlPoint1 =  Offset(50, size.height - 5 );
    final endPoint1 = Offset(size.width / 2, size.height);
    final controlPoint2 = Offset(size.width - 50, size.height - 5);
    final endPoint2 = Offset(size.width, size.height - 50);

    var path = Path();
    path.lineTo(startPoint.dx, startPoint.dy);
    // Create first Quadratic curve to the middle of the image
    path.quadraticBezierTo(controlPoint1.dx, controlPoint1.dy , endPoint1.dx, endPoint1.dy );
    // Add second Quadratic curve from the middle to the offset(width, height - 50) of the image
    path.quadraticBezierTo(controlPoint2.dx, controlPoint2.dy, endPoint2.dx, endPoint2.dy);
    
    /// Create Cubic Bezier curve
    /// The tangent at the inflection point will pass through the midpoint of the tangents at p(start) and p(end)
    final cStartPoint = Offset(size.width, 0);
    final cEndPoint = Offset(0, 100);
    final cControlPoint1 = Offset(150, size.height - 150);
    final cControlPoint2 = Offset(95, -15);
    path.lineTo(cStartPoint.dx, cStartPoint.dy);
    path.cubicTo(cControlPoint1.dx, cControlPoint1.dy,
        cControlPoint2.dx, cControlPoint2.dy, cEndPoint.dx, cEndPoint.dy);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
