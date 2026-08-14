import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  changeTheme(ThemeMode mode){
    themeMode = mode;
    notifyListeners();
  }
}