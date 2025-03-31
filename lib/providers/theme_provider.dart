import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = false;

  ThemeMode get currentTheme => isDark ? ThemeMode.dark : ThemeMode.light;

  void updateTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
