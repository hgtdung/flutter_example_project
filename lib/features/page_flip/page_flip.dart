import 'dart:math';

import 'package:flutter/material.dart';

class PageFlipWidget extends StatefulWidget {
  const PageFlipWidget({super.key});

  @override
  State<PageFlipWidget> createState() => _PageFlipWidgetState();
}

class _PageFlipWidgetState extends State<PageFlipWidget> with SingleTickerProviderStateMixin{

  Offset startPoint = Offset(0, 0);
  Offset pointerPoint = Offset(0, 0);

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
    duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final boxSize = const Size(100, 100);

    return CustomPaint(
      painter: CustomCornerCurve(),
      child: Text("Hello world!"),
    );
    return Scaffold(
      body: Center(
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.01)  // Adds perspective
            ..rotateX(0.5),          // Rotate around X-axis
          alignment: FractionalOffset.center,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
          ),
        ),
      ),
      // body: Center(
      //   child: Transform(
      //     transform:
      //     Matrix4.identity()
      //     ..setEntry(3, 2, 0.001)
      //     // ..rotateZ(pi / 2)
      //     ,
      //     child: Padding(
      //       padding: const EdgeInsets.only(left: 30, top: 30),
      //       child: GestureDetector(
      //         onPanStart: (panDetailStart) {
      //           setState(() {
      //             startPoint = panDetailStart.localPosition;
      //           });
      //         },
      //         onPanUpdate: (panUpdate) {
      //           setState(() {
      //             pointerPoint = panUpdate.localPosition;
      //           });
      //         },
      //         onPanEnd: (panEnd) {},
      //         child: Stack(
      //           children: [
      //             Container(
      //               decoration: BoxDecoration(
      //                   border: Border.all(width: 2, color: Colors.blue)),
      //               height: boxSize.height,
      //               width: boxSize.width,
      //             ),
      //             Positioned(
      //                 left: startPoint.dx,
      //                 top: startPoint.dy,
      //                 child: Stack(
      //                   clipBehavior: Clip.none,
      //                   children: [
      //                     Container(
      //                       color: Colors.blue,
      //                       alignment: Alignment.center,
      //                       width: 2,
      //                       height: 50,
      //                     ),
      //                     Positioned(
      //                         top: 20,
      //                         left: -4,
      //                         child:
      //                     Circle()
      //                     ),
      //                   ],
      //                 )),
      //             Positioned(
      //                 left: pointerPoint.dx,
      //                 top: pointerPoint.dy,
      //                 child: Stack(
      //                   clipBehavior: Clip.none,
      //                   children: [
      //                     Container(
      //                       color: Colors.green,
      //                       alignment: Alignment.center,
      //                       width: 2,
      //                       height: 50,
      //                     ),
      //                     Positioned(
      //                         top: 20,
      //                         left: -4,
      //                         child:
      //                         Circle()
      //                     ),
      //                   ],
      //                 ))
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

class Circle extends StatelessWidget {
  const Circle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(20))),
      width: 10,
      height: 10,
    );
  }
}


