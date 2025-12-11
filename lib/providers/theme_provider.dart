import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // default false = light mode
  bool _isDark = false;

  bool get isDark => _isDark;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  // void toggleTheme() {
  //   _isDark = !_isDark;
  //   notifyListeners();
  // }

  void setDark(bool value) {
    if (_isDark != value) {
      _isDark = value;
      notifyListeners();
    }
  }
}
