import 'package:flutter/foundation.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkTheme = false;

  bool get getDarkTheme => _isDarkTheme;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    print(_isDarkTheme);
    notifyListeners();
  }
}
