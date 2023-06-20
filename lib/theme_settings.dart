import 'package:flutter/material.dart';
import 'package:mtrack/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSettings extends ChangeNotifier {
  ThemeData _currTheme = lightTheme;
  ThemeData get currTheme => _currTheme;

  void toggleTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (_currTheme == lightTheme) {
      _currTheme = darkTheme;
      sharedPreferences.setBool('is_dark', true);
    } else {
      _currTheme = lightTheme;
      sharedPreferences.setBool('is_dark', false);
    }
    notifyListeners();
  }
}
