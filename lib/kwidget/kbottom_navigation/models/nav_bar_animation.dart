part of k_bottom_nav_bar;

class ScreenTransitionAnimationSetting {
  const ScreenTransitionAnimationSetting({
    this.animateTabTransition = false,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
  });
  final bool animateTabTransition;
  final Duration duration;
  final Curve curve;
}

class ItemAnimationProperties {
  const ItemAnimationProperties({this.duration, this.curve});
  final Duration? duration;
  final Curve? curve;
}
