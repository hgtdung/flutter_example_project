import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example_project/features/page1_screen/page1_screen.dart';
import 'package:flutter_example_project/features/page2_screen/page2_screen.dart';
import 'package:flutter_example_project/features/page3_screen/page3_screen.dart';
import 'package:flutter_example_project/kwidget/kbottom_navigation/k_tab_view.lib.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final KTabController _controller;

  @override
  void initState() {
    _controller = KTabController(initialIndex: 0);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return KTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: Colors.grey.shade900,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.simple, // Choose the nav bar style with this propertyr style with this property
    );
  }


  List<Widget> _buildScreens() {
    return [
      const Page1Screen(),
      const Page2Screen(),
      const Page3Screen()
    ];
  }
List<KBottomNavBarItem> _navBarsItems() {
  return [
    KBottomNavBarItem(
      icon: Icon(CupertinoIcons.home),
      title: ("Page1"),
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/",
        // routes: {
        //   "/first": (final context) => const Page1-1(),
        //   "/second": (final context) => const Page1-2(),
        // },
      ),
    ),
    KBottomNavBarItem(
      icon: Icon(CupertinoIcons.settings),
      title: ("Page2"),
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/",
        // routes: {
        //   "/first": (final context) => const Page2-1(),
        //   "/second": (final context) => const Page2-2(),
        // },
      ),
    ),
    KBottomNavBarItem(
      icon: Icon(CupertinoIcons.settings),
      title: ("Page3"),
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/",
        // routes: {
        //   "/first": (final context) => const Page2-1(),
        //   "/second": (final context) => const Page2-2(),
        // },
      ),
    ),
  ];
}

}
