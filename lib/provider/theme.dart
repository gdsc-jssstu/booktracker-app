import 'package:flutter/material.dart';

class Themechanger with ChangeNotifier {
  ThemeData _themeData;

  Themechanger(this._themeData);

  gettheme() => _themeData;

  settheme(ThemeData theme) {
    _themeData = theme;

    notifyListeners();
  }
}
