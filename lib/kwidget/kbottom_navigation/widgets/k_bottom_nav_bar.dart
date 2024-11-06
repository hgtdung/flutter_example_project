part of k_bottom_nav_bar;



class _KBottomNavBarWidget extends StatelessWidget {
  const _KBottomNavBarWidget({
    required this.confineToSafeArea,
    required this.navBarEssentials,
    required this.navBarDecoration,
    required this.navBarStyle,
    required this.hideNavigationBar,
    required this.navBarHideAnimationController,
    this.customNavBarWidget,
    this.onAnimationComplete,
    this.isCustomWidget = false,
    final Key? key,
  }) : super(key: key);

  final AnimationController navBarHideAnimationController;
  final _NavBarEssentials navBarEssentials;
  final NavBarDecoration navBarDecoration;
  final NavBarStyle navBarStyle;
  final Widget? customNavBarWidget;
  final bool confineToSafeArea;
  final bool hideNavigationBar;
  final Function(bool, bool)? onAnimationComplete;
  final bool isCustomWidget;

  Padding _navBarWidget(final BuildContext context) => Padding(
    padding: navBarEssentials.margin,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isCustomWidget)
          navBarEssentials.margin.bottom > 0
              ? DecoratedBox(
            decoration: BoxDecoration(
              color: navBarEssentials.backgroundColor,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: confineToSafeArea
                      ? MediaQuery.paddingOf(context).bottom
                      : 0),
              child: SizedBox(
                height: navBarEssentials.navBarHeight,
                child: customNavBarWidget,
              ),
            ),
          )
              : DecoratedBox(
            decoration: BoxDecoration(
              color: navBarEssentials.backgroundColor,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: confineToSafeArea
                      ? MediaQuery.paddingOf(context).bottom
                      : 0),
              child: SizedBox(
                height: navBarEssentials.navBarHeight,
                child: customNavBarWidget,
              ),
            ),
          )
        else
          navBarStyle == NavBarStyle.style19
              ? navBarEssentials.margin.bottom > 0
              ? Padding(
            padding: EdgeInsets.only(
                bottom: confineToSafeArea
                    ? MediaQuery.paddingOf(context).bottom
                    : 0),
            child: getNavBarStyle(),
          )
              : DecoratedBox(
            decoration:
            _KBottomNavigationBarUtilFunctions
                .getNavBarDecoration(
              decoration: navBarDecoration,
              color: navBarEssentials.backgroundColor,
              opacity: navBarEssentials
                  .items[navBarEssentials.selectedIndex].opacity,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: confineToSafeArea
                      ? MediaQuery.paddingOf(context).bottom
                      : 0),
              child: getNavBarStyle(),
            ),
          )
              : navBarStyle == NavBarStyle.style15 ||
              navBarStyle == NavBarStyle.style16
              ? navBarEssentials.margin.bottom > 0
              ? DecoratedBox(
            decoration:
            _KBottomNavigationBarUtilFunctions
                .getNavBarDecoration(
              decoration: navBarDecoration,
              color: navBarEssentials.backgroundColor,
              opacity: navBarEssentials
                  .items[navBarEssentials.selectedIndex]
                  .opacity,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: confineToSafeArea
                      ? MediaQuery.paddingOf(context).bottom
                      : 0),
              child: getNavBarStyle(),
            ),
          )
              : DecoratedBox(
            decoration:
            _KBottomNavigationBarUtilFunctions
                .getNavBarDecoration(
              decoration: navBarDecoration,
              color: navBarEssentials.backgroundColor,
              opacity: navBarEssentials
                  .items[navBarEssentials.selectedIndex]
                  .opacity,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: confineToSafeArea
                      ? MediaQuery.paddingOf(context).bottom
                      : 0),
              child: getNavBarStyle(),
            ),
          )
              : navBarDecoration.useBackdropFilter
              ? DecoratedBox(
            decoration:
            _KBottomNavigationBarUtilFunctions
                .getNavBarDecoration(
              decoration: navBarDecoration,
              showBorder: false,
              color: navBarEssentials.backgroundColor,
              opacity: navBarEssentials
                  .items[navBarEssentials.selectedIndex]
                  .opacity,
            ),
            child: ClipRRect(
              borderRadius: navBarDecoration.borderRadius ??
                  BorderRadius.zero,
              child: BackdropFilter(
                filter: navBarEssentials
                    .items[navBarEssentials.selectedIndex]
                    .filter ??
                    ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: DecoratedBox(
                  decoration:
                  _KBottomNavigationBarUtilFunctions
                      .getNavBarDecoration(
                    showOpacity: false,
                    decoration: navBarDecoration,
                    color: navBarEssentials.backgroundColor,
                    opacity: navBarEssentials
                        .items[navBarEssentials.selectedIndex]
                        .opacity,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: confineToSafeArea
                            ? MediaQuery.paddingOf(context)
                            .bottom
                            : 0),
                    child: getNavBarStyle(),
                  ),
                ),
              ),
            ),
          )
              : DecoratedBox(
            decoration:
            _KBottomNavigationBarUtilFunctions
                .getNavBarDecoration(
              showOpacity: false,
              decoration: navBarDecoration,
              color: navBarEssentials.backgroundColor,
              opacity: navBarEssentials
                  .items[navBarEssentials.selectedIndex]
                  .opacity,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: confineToSafeArea
                      ? MediaQuery.paddingOf(context).bottom
                      : 0),
              child: getNavBarStyle(),
            ),
          ),
      ],
    ),
  );

  @override
  Widget build(final BuildContext context) => _OffsetAnimation(
    hideNavigationBar: hideNavigationBar,
    navBarHeight: navBarEssentials.navBarHeight +
        MediaQuery.paddingOf(context).bottom,
    navBarHideAnimationController: navBarHideAnimationController,
    onAnimationComplete: (final isAnimating, final isComplete) {
      onAnimationComplete!(isAnimating, isComplete);
    },
    child: _navBarWidget(context),
  );

  _KBottomNavBarWidget copyWith(
      {final int? selectedIndex,
        final double? iconSize,
        final int? previousIndex,
        final Color? backgroundColor,
        final Duration? animationDuration,
        final List<KBottomNavBarItem>? items,
        final ValueChanged<int>? onItemSelected,
        final double? navBarHeight,
        final NavBarStyle? navBarStyle,
        final double? horizontalPadding,
        final Widget? customNavBarWidget,
        final Function(int)? popAllScreensForTheSelectedTab,
        final bool? popScreensOnTapOfSelectedTab,
        final NavBarDecoration? navBarDecoration,
        final _NavBarEssentials? navBarEssentials,
        final bool? confineToSafeArea,
        final ItemAnimationSettings? itemAnimationProperties,
        final Function? onAnimationComplete,
        final AnimationController? navBarHideAnimationController,
        final bool? hideNavigationBar,
        final bool? isCustomWidget,
        final EdgeInsets? padding}) =>
      _KBottomNavBarWidget(
          confineToSafeArea: confineToSafeArea ?? this.confineToSafeArea,
          navBarHideAnimationController: navBarHideAnimationController ??
              this.navBarHideAnimationController,
          navBarStyle: navBarStyle ?? this.navBarStyle,
          hideNavigationBar: hideNavigationBar ?? this.hideNavigationBar,
          customNavBarWidget: customNavBarWidget ?? this.customNavBarWidget,
          onAnimationComplete: onAnimationComplete as dynamic Function(
              bool isAnimating, bool isComplete)? ??
              this.onAnimationComplete,
          navBarEssentials: navBarEssentials ?? this.navBarEssentials,
          isCustomWidget: isCustomWidget ?? this.isCustomWidget,
          navBarDecoration: navBarDecoration ?? this.navBarDecoration);

  bool opaque(final int? index) => navBarEssentials.items.isEmpty
      ? true
      : !(navBarEssentials.items[index!].opacity < 1.0);

  Widget getNavBarStyle() {
    if (isCustomWidget) {
      return customNavBarWidget ?? const SizedBox.shrink();
    } else {
      switch (navBarStyle) {
        case NavBarStyle.style1:
          return _BottomNavStyle1(
            navBarEssentials: navBarEssentials,
          );
        default:
          return _BottomNavSimple(
            navBarEssentials: navBarEssentials,
          );
      }
    }
  }
}

