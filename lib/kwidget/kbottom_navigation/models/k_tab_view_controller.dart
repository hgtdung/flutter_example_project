part of k_bottom_nav_bar;

///Navigation bar controller for `PersistentTabView`.
class KTabController extends ChangeNotifier {
  KTabController({final int initialIndex = 0})
      : _index = initialIndex,
        assert(initialIndex >= 0, "Value cannot be less than zero");

  bool _isDisposed = false;
  int get index => _index;
  int _index;

  set index(final int value) {
    assert(value >= 0, "Value cannot be less than zero");
    if (_index == value) {
      return;
    }
    _index = value;
    notifyListeners();
  }

  void jumpToTab(final int value) {
    assert(value >= 0, "Value cannot be less than zero");
    if (_index == value) {
      return;
    }
    _index = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}