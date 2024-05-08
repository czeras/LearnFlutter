import 'package:flutter/cupertino.dart';

class JRChangeNotifier extends ChangeNotifier {
  bool _mounted = true;

  bool get mounted => _mounted;
  set mounted(value) => _mounted = value;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_mounted) {
      super.notifyListeners();
    }
  }
}
