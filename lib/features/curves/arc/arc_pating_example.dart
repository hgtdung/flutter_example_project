import 'dart:math';

import 'package:flutter/material.dart';

class ArcPaintingExample extends StatefulWidget {
  const ArcPaintingExample({super.key});

  @override
  State<ArcPaintingExample> createState() => _ArcPaintingExampleState();
}

class _ArcPaintingExampleState extends State<ArcPaintingExample> {
  static const largeBorderRadius = 22.0;
  static const  smallBorderRadius = 12.0;
  static const  messageFontSize = 15.0;
  static const  timeFontSize = 14.0;
  static const timeFontWeight = FontWeight.w500;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Custom Painting')),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Container(
          padding: const EdgeInsets.only(right: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomPaint(
                painter: ChatBoxPainter(),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Keyword: Arc, Beizer curve",
                        style: TextStyle(
                            fontSize: messageFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        child: Text(
                          "12: 32 PM",
                          style: TextStyle(
                              fontSize: timeFontSize,
                              fontWeight: timeFontWeight,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const gradient =  LinearGradient(
      colors: [Color(0xff66A3C1), Color(0xff6492C0)], begin: Alignment.bottomCenter, end: Alignment.topCenter,);
    var paint = Paint()
      ..color = Colors.blue
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;
    final path = Path();
    const leftBorderRadius = 22.0;
    const topRightBorderRadius = 10.0;

    // Draw top left border radius
    path.arcTo(Rect.fromCircle(center: const Offset(leftBorderRadius, leftBorderRadius), radius: leftBorderRadius), pi, pi / 2, false,);
    path.lineTo(size.width - leftBorderRadius, 0);
    // Top right border radius
    path.arcTo(Rect.fromCircle(center: Offset(size.width - topRightBorderRadius, topRightBorderRadius), radius: topRightBorderRadius), 3 * pi / 2, pi / 2, false,);
    path.lineTo(size.width, (2 * size.height / 3) - 5);
    // The curve on the bottom right
    path.quadraticBezierTo(size.width + 2, size.height - 3, size.width + 10, size.height - 3);
    path.arcTo(Rect.fromCircle(center: Offset(size.width + 10, size.height - 1.5), radius: 1.5), 3 * pi / 2, pi, false);
    //
    path.lineTo(leftBorderRadius, size.height);
    // Bottom left border radius
    path.arcTo(Rect.fromCircle(center: Offset(leftBorderRadius, size.height - leftBorderRadius), radius: leftBorderRadius), pi / 2, pi / 2, false);
    path.lineTo(0, leftBorderRadius);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

