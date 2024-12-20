import 'package:flutter/material.dart';

class TestConicCurve extends StatefulWidget {
  const TestConicCurve({super.key});

  @override
  State<TestConicCurve> createState() => _TestConicCurveState();
}

class _TestConicCurveState extends State<TestConicCurve> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
      SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
            border: Border.all(color: Colors.red, width: 2)
          ),
        ),
      )
    );
  }
}

class ConicCurveWidget extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
