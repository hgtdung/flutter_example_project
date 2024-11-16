import 'package:flutter/material.dart';

class ClipingImageExample extends StatefulWidget {
  const ClipingImageExample({super.key});

  @override
  State<ClipingImageExample> createState() => _ClipingImageExampleState();
}

class _ClipingImageExampleState extends State<ClipingImageExample> {
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
              clipper: ClippingClass(),
              child: Container(
                height: imageSize.height,
                width: imageSize.width,
                child: Image.asset("assets/images/TAEYEON.jpg", fit: BoxFit.fill,),
              ),
            ),
          ],
        ),
      )
    ]));
  }
}

class ClippingClass extends CustomClipper<Path> {
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
    /// Create first Quadratic curve to the middle of the image
    path.quadraticBezierTo(controlPoint1.dx, controlPoint1.dy , endPoint1.dx, endPoint1.dy );
    /// Add second Quadratic curve from the middle to the offset(width, height - 50) of the image
    path.quadraticBezierTo(controlPoint2.dx, controlPoint2.dy, endPoint2.dx, endPoint2.dy);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
