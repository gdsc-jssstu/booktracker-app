import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Themechanger with ChangeNotifier {
  ThemeData _themeData;

  Themechanger(this._themeData);

  gettheme() => _themeData;

  settheme(ThemeData theme) {
    _themeData = theme;

    notifyListeners();
  }
}
