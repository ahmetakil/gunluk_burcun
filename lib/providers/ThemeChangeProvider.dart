import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ThemeChangeProvider with ChangeNotifier {
  var isDayTheme;

  ThemeChangeProvider(this.isDayTheme);

  void toggleDayNightView() {
    isDayTheme = !isDayTheme;
    notifyListeners();
  }
}
