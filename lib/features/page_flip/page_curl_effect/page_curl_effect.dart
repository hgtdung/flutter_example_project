import 'package:flutter/material.dart';
import 'package:flutter_example_project/features/page_flip/clip_shadow_path.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/model/cylinder.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/state_management/page_curl_controller.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/widget/page_curl_clipper.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/widget/page_curl_painter.dart';
import 'package:provider/provider.dart';

class PageCurlEffect extends StatefulWidget {
  const PageCurlEffect(
      {super.key,
        required this.pageCurlController,
      required this.currentPage,
      required this.width,
      required this.height,
        required this.previousPage,
        required this.nextPage,
      this.background,
      required this.onForwardComplete,
      required this.onBackwardComplete});
  final PageCurlController pageCurlController;
  final Widget currentPage;
  final Widget? previousPage;
  final Widget? nextPage;
  final Color? background;
  final double width;
  final double height;

  final VoidCallback onForwardComplete;
  final VoidCallback onBackwardComplete;

  @override
  State<PageCurlEffect> createState() => _PageCurlEffectState();
}

class _PageCurlEffectState extends State<PageCurlEffect> with SingleTickerProviderStateMixin{
  PageCurlController get pageCurlVM  => widget.pageCurlController;

  late final AnimationController _animationController;



  @override
  void initState() {
    // pageCurlVM = PageCurlController(Size(widget.width, widget.height));
    // pageCurlVM = widget.pageCurlVM;
    _animationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);


    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: pageCurlVM,
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: GestureDetector(
          onPanUpdate: (dragUpdateDetails) {
            pageCurlVM.onPanUpdate(dragUpdateDetails);
          },
          onPanStart: (dragStartDetails) {
            pageCurlVM.onPanStart(dragStartDetails);
          },
          onPanEnd: (dragEndDetails) {
            print("pan end");

            if(pageCurlVM.startPoint!.x > 50) {
              ///test
              print("case 1");
              var lastTouchPoint = pageCurlVM.touchPoint;
              var forwardAnimation = Tween(begin: pageCurlVM.touchPoint!.x, end: -(MediaQuery.of(context).size.width)).animate(_animationController);
              listener1() {
                pageCurlVM.onAutoPanUpdate(Offset(forwardAnimation.value, lastTouchPoint!.y));
              }
              forwardAnimation.addListener(listener1);

              _animationController.value = 0;
              _animationController.addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  widget.onForwardComplete();
                  pageCurlVM.onPanEnd(dragEndDetails);
                  forwardAnimation.removeListener(listener1);
                }
              });
              _animationController.forward();
            } else {
              print("case 2");
              ///test
              var lastTouchPoint = pageCurlVM.touchPoint;
              var backwardAnimation = Tween(begin: pageCurlVM.touchPoint!.x, end: (MediaQuery.of(context).size.width)).animate(_animationController);
              listener2() {
                pageCurlVM.onAutoPanUpdate(Offset(backwardAnimation.value, lastTouchPoint!.y));
              }
              backwardAnimation.addListener(listener2);
              _animationController.value = 0;
              _animationController.addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  print("status listen");
                  pageCurlVM.onPanEnd(dragEndDetails);
                  widget.onBackwardComplete();

                  backwardAnimation.removeListener(listener2);
                }
              });
              _animationController.forward();
            }

          },
          child: Consumer<PageCurlController>(
            builder: (context, pageCurlVM, child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  if(widget.nextPage != null) widget.nextPage!,
                  if (pageCurlVM.startPoint != null && pageCurlVM.startPoint!.x < 50)   widget.currentPage,
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child){
                      return ClipShadowPath(
                        shadow: (pageCurlVM.cylinder != null && pageCurlVM.cylinder!.range != 0) ?  BoxShadow(
                            color: Colors.black45,
                            offset: Offset(8, 8),
                            blurRadius: 7,
                            spreadRadius: 8) :  BoxShadow(
                            color: Colors.orange,
                            offset: Offset(0, 0),
                            blurRadius: 0,
                            spreadRadius: 0),
                        clipper: PageCurlClipper(
                            nullableCylinder: pageCurlVM.cylinder,
                            nullableHorizontalPageCurl:
                            pageCurlVM.horizontalPageCurl,
                            nullableMiddlePageCurl: pageCurlVM.middlePageCurl),
                        child: Container(
                          height: widget.height,
                          width: widget.width,
                          color: widget.background ?? const Color(0xffF5DEB3),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              widget.currentPage,
                              if (pageCurlVM.startPoint != null && pageCurlVM.startPoint!.x < 50 && widget.previousPage != null) widget.previousPage!,
                              CustomPaint(
                                painter: PageCurlPainter(
                                    nullableCylinder: pageCurlVM.cylinder,
                                    nullableHorizontalPageCurl:
                                    pageCurlVM.horizontalPageCurl,
                                    nullableMiddlePageCurl:
                                    pageCurlVM.middlePageCurl),
                                child: SizedBox.expand(),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),

                  // Positioned(
                  //     left: -widget.width,
                  //     child: widget.previousPage),
                  ...getPageAnchor(pageCurlVM.cylinder)
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> getPageAnchor(Cylinder? cylinder) {
    if (cylinder == null) {
      return [];
    }
    return [
      if (pageCurlVM.startPoint != null)
        Positioned(
            left: pageCurlVM.startPoint!.x - 5,
            top: pageCurlVM.startPoint!.y - 5,
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.red),
            )),
      if (pageCurlVM.startPoint != null)
        Positioned(
            left: pageCurlVM.touchPoint!.x - 5,
            top: pageCurlVM.touchPoint!.y - 5,
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.green),
            )),
      Positioned(
          left: cylinder.topLeft.x - 5,
          top: cylinder.topLeft.y - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.brown),
          )),
      Positioned(
          left: cylinder.topRight.x - 5,
          top: cylinder.topRight.y - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.brown),
          )),
      Positioned(
          left: cylinder.bottomRight.x - 5,
          top: cylinder.bottomRight.y - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.brown),
          )),
      Positioned(
          left: cylinder.bottomLeft.x - 5,
          top: cylinder.bottomLeft.y - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.brown),
          )),
      Positioned(
          left: cylinder.center.x - 5,
          top: cylinder.center.y - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.brown),
          )),
      if (pageCurlVM.horizontalPageCurl != null)
        Positioned(
            left: pageCurlVM.horizontalPageCurl!.endPoint.x - 5,
            top: pageCurlVM.horizontalPageCurl!.endPoint.y - 5,
            child: Container(
              height: 10,
              width: 10,
              child: Text("b"),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.purple),
            )),
      if (pageCurlVM.middlePageCurl != null)
        Positioned(
            left: pageCurlVM.middlePageCurl!.startPoint.x - 5,
            top: pageCurlVM.middlePageCurl!.startPoint.y - 5,
            child: Container(
              height: 10,
              width: 10,
              child: Text("b"),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blue),
            )),
      if (pageCurlVM.middlePageCurl != null)
        Positioned(
            left: pageCurlVM.middlePageCurl!.endPoint.x - 5,
            top: pageCurlVM.middlePageCurl!.endPoint.y - 5,
            child: Container(
              height: 10,
              width: 10,
              child: Text("b"),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.purple),
            )),
      if (pageCurlVM.middlePageCurl != null)
        Positioned(
            left: pageCurlVM.middlePageCurl!.controlPoint!.x - 5,
            top: pageCurlVM.middlePageCurl!.controlPoint.y - 5,
            child: Container(
              height: 10,
              width: 10,
              child: Text("b"),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.purple),
            )),
      if (pageCurlVM.horizontalPageCurl != null)
        Positioned(
            left: pageCurlVM.horizontalPageCurl!.foldPoint.x - 2.5,
            top: pageCurlVM.horizontalPageCurl!.foldPoint.y - 2.5,
            child: Container(
              height: 5,
              width: 5,
              child: Text("b"),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blue),
            )),
    ];
  }
}
