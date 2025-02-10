import 'package:flutter/material.dart';
import 'package:flutter_example_project/features/page_flip/clip_shadow_path.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/src/constants.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/src/model/cylinder.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/src/state_management/page_curl_controller.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/src/widget/page_curl_clipper.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/src/widget/page_curl_painter.dart';
import 'package:provider/provider.dart';

class PageCurlEffect extends StatefulWidget {
  const PageCurlEffect(
      {super.key,
      required this.pageCurlController,
      this.pages,
      this.pageBuilder,
      this.onForwardComplete,
      this.onBackwardComplete});

  final PageCurlController pageCurlController;

  final List<Widget>? pages;
  final Widget Function(BuildContext, int)? pageBuilder;

  final VoidCallback? onForwardComplete;
  final VoidCallback? onBackwardComplete;

  @override
  State<PageCurlEffect> createState() => _PageCurlEffectState();
}

class _PageCurlEffectState extends State<PageCurlEffect>
    with SingleTickerProviderStateMixin {
  PageCurlController get pageCurlCtrl => widget.pageCurlController;
  late final AnimationController _animationController;

  @override
  void initState() {
    assert(
        (widget.pages != null && widget.pageBuilder == null ||
            widget.pages == null && widget.pageBuilder != null),
        "[Only set one of [pages] or [pageBuilder]");

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: pageCurlCtrl,
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: GestureDetector(
          onPanUpdate: (dragUpdateDetails) {
            pageCurlCtrl.onPanUpdate(dragUpdateDetails);
          },
          onPanStart: (dragStartDetails) {
            pageCurlCtrl.onPanStart(dragStartDetails);
          },
          onPanEnd: (dragEndDetails) {
            if (pageCurlCtrl.startPoint != null &&
                pageCurlCtrl.startPoint!.x > PCConstants.TURN_PAGE_BARRIER &&
                !pageCurlCtrl.isLastPage()) {
              var forwardAnimation = Tween(
                      begin: pageCurlCtrl.touchPoint!.x,
                      end: -(MediaQuery.of(context).size.width))
                  .animate(_animationController);

              /// Keep turning the page from the touch point to the end
              var lastTouchPoint = pageCurlCtrl.touchPoint;
              forwardAnimationListener() {
                pageCurlCtrl.onAutoPanUpdate(
                    Offset(forwardAnimation.value, lastTouchPoint!.y));
              }

              forwardAnimation.addListener(forwardAnimationListener);

              /// Reset pageCurlCtrl after completing animation
              statusListener1(status) {
                if (status == AnimationStatus.completed) {
                  pageCurlCtrl.reset();
                  pageCurlCtrl.onForwardComplete();
                  widget.onForwardComplete?.call();
                  forwardAnimation.removeListener(forwardAnimationListener);
                  _animationController.removeStatusListener(statusListener1);
                }
              }

              _animationController.value = 0;
              _animationController.addStatusListener(statusListener1);
              _animationController.forward();
            } else if (pageCurlCtrl.startPoint != null &&
                pageCurlCtrl.startPoint!.x <= PCConstants.TURN_PAGE_BARRIER &&
                !pageCurlCtrl.isFirstPage()) {
              var backwardAnimation = Tween(
                      begin: pageCurlCtrl.touchPoint!.x,
                      end: (MediaQuery.of(context).size.width))
                  .animate(_animationController);

              /// /// Keep turning the page from the touch point to the end
              var lastTouchPoint = pageCurlCtrl.touchPoint;
              backwardAnimationListener() {
                pageCurlCtrl.onAutoPanUpdate(
                    Offset(backwardAnimation.value, lastTouchPoint!.y));
              }

              statusListener2(status) {
                if (status == AnimationStatus.completed) {
                  pageCurlCtrl.reset();
                  pageCurlCtrl.onBackwardComplete();
                  widget.onBackwardComplete?.call();
                  backwardAnimation.removeListener(backwardAnimationListener);
                  _animationController.removeStatusListener(statusListener2);
                }
              }

              backwardAnimation.addListener(backwardAnimationListener);
              _animationController.value = 0;
              _animationController.addStatusListener(statusListener2);
              _animationController.forward();
            } else {
              /// startPoint is not touched from the edge
              pageCurlCtrl.onPanEnd(dragEndDetails);
            }
            pageCurlCtrl.isEdgeDragging = false;
          },
          child: Consumer<PageCurlController>(
            builder: (context, pageCurlCtlr, child) {
              final nextPageIndex = pageCurlCtlr.getNextPageIndex();
              final previousPageIndex = pageCurlCtlr.getPreviousPageIndex();
              final currentPageIndex = pageCurlCtlr.pageCurlIndex;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  /// Using page list
                  if (widget.pages != null && nextPageIndex != null)
                    widget.pages![nextPageIndex],
                  if (widget.pages != null &&
                      pageCurlCtlr.startPoint != null &&
                      pageCurlCtlr.startPoint!.x <
                          PCConstants.TURN_PAGE_BARRIER)
                    widget.pages![currentPageIndex],

                  /// Using page builder
                  if (widget.pageBuilder != null && nextPageIndex != null)
                    widget.pageBuilder!(context, nextPageIndex),
                  if (widget.pageBuilder != null &&
                      pageCurlCtlr.startPoint != null &&
                      pageCurlCtlr.startPoint!.x <
                          PCConstants.TURN_PAGE_BARRIER)
                    widget.pageBuilder!(context, currentPageIndex),
                  AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return ClipShadowPath(
                          shadow: const BoxShadow(
                              color: Colors.black45,
                              offset: Offset(8, 8),
                              blurRadius: 7,
                              spreadRadius: 8),
                          clipper: PageCurlClipper(
                              nullableCylinder: pageCurlCtlr.cylinder,
                              nullableHorizontalPageCurl:
                                  pageCurlCtlr.horizontalPageCurl,
                              nullableMiddlePageCurl:
                                  pageCurlCtlr.middlePageCurl),
                          child: Container(
                            height: pageCurlCtlr.paperSize.height,
                            width: pageCurlCtlr.paperSize.width,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                /// Using pages
                                if (widget.pages != null)
                                  widget.pages![currentPageIndex],
                                if (widget.pages != null &&
                                    pageCurlCtlr.startPoint != null &&
                                    pageCurlCtlr.startPoint!.x <
                                        PCConstants.TURN_PAGE_BARRIER &&
                                    previousPageIndex != null)
                                  if (widget.pages != null)
                                    widget.pages![previousPageIndex],

                                /// Using page builder
                                if (widget.pageBuilder != null)
                                  widget.pageBuilder!(
                                      context, currentPageIndex),
                                if (widget.pageBuilder != null &&
                                    pageCurlCtlr.startPoint != null &&
                                    pageCurlCtlr.startPoint!.x <
                                        PCConstants.TURN_PAGE_BARRIER &&
                                    previousPageIndex != null)
                                  if (widget.pageBuilder != null)
                                    widget.pageBuilder!(
                                        context, previousPageIndex),
                                if (pageCurlCtrl.startPoint != null)
                                  CustomPaint(
                                    painter: PageCurlPainter(
                                        nullableCylinder: pageCurlCtlr.cylinder,
                                        nullableHorizontalPageCurl:
                                            pageCurlCtlr.horizontalPageCurl,
                                        nullableMiddlePageCurl:
                                            pageCurlCtlr.middlePageCurl),
                                    child: SizedBox.expand(),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),

                  // Positioned(
                  //     left: -widget.width,
                  //     child: widget.previousPage),
                  // ...getPageAnchor(pageCurlCtlr.cylinder)
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
      if (pageCurlCtrl.startPoint != null)
        Positioned(
            left: pageCurlCtrl.startPoint!.x - 5,
            top: pageCurlCtrl.startPoint!.y - 5,
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.red),
            )),
      if (pageCurlCtrl.startPoint != null)
        Positioned(
            left: pageCurlCtrl.touchPoint!.x - 5,
            top: pageCurlCtrl.touchPoint!.y - 5,
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
      if (pageCurlCtrl.horizontalPageCurl != null)
        Positioned(
            left: pageCurlCtrl.horizontalPageCurl!.endPoint.x - 5,
            top: pageCurlCtrl.horizontalPageCurl!.endPoint.y - 5,
            child: Container(
              height: 10,
              width: 10,
              child: Text("b"),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.purple),
            )),
      if (pageCurlCtrl.middlePageCurl != null)
        Positioned(
            left: pageCurlCtrl.middlePageCurl!.startPoint.x - 5,
            top: pageCurlCtrl.middlePageCurl!.startPoint.y - 5,
            child: Container(
              height: 10,
              width: 10,
              child: Text("b"),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blue),
            )),
      if (pageCurlCtrl.middlePageCurl != null)
        Positioned(
            left: pageCurlCtrl.middlePageCurl!.endPoint.x - 5,
            top: pageCurlCtrl.middlePageCurl!.endPoint.y - 5,
            child: Container(
              height: 10,
              width: 10,
              child: Text("b"),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.purple),
            )),
      if (pageCurlCtrl.middlePageCurl != null)
        Positioned(
            left: pageCurlCtrl.middlePageCurl!.controlPoint!.x - 5,
            top: pageCurlCtrl.middlePageCurl!.controlPoint.y - 5,
            child: Container(
              height: 10,
              width: 10,
              child: Text("b"),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.purple),
            )),
      if (pageCurlCtrl.horizontalPageCurl != null)
        Positioned(
            left: pageCurlCtrl.horizontalPageCurl!.foldPoint.x - 2.5,
            top: pageCurlCtrl.horizontalPageCurl!.foldPoint.y - 2.5,
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
