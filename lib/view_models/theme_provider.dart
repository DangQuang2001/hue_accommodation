import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
   bool _light = true;
  ThemeMode _mode ;

  ThemeMode get mode => _mode;
  bool get light => _light;

  ThemeProvider({ThemeMode mode = ThemeMode.light}) : _mode = mode;

  void setLightMode(){
    _mode = ThemeMode.light;
    _light = true;
    notifyListeners();
  }
  void setDarkMode(){
    _mode = ThemeMode.dark;
    _light = false;
    notifyListeners();
  }



}
