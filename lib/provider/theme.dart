import 'package:flutter/material.dart';

class Themechanger with ChangeNotifier {
  bool isDarkMode = false;
  // ignore: unnecessary_this
  getDarkMode() => this.isDarkMode;
  void changeDarkMode(isDarkMode) {
    this.isDarkMode = isDarkMode;
    notifyListeners();
  }
}
