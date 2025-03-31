import 'package:flutter/material.dart';

class ScreenProvider extends ChangeNotifier {
  bool isDesktop = false;

  void updateScreenSize(double width) {
    final newIsDesktop = width > 600;
    if (newIsDesktop != isDesktop) {
      isDesktop = newIsDesktop;
      notifyListeners();
    }
  }
}
