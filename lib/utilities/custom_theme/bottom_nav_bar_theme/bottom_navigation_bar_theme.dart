import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/color_theme.dart';

class TBottomNavigationBarTheme{
  TBottomNavigationBarTheme._();

  static final BottomNavigationBarThemeData light = BottomNavigationBarThemeData(
      selectedItemColor: ColorTheme.RED,
      unselectedItemColor: ColorTheme.BLACK,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: ColorTheme.WHITE,
      selectedLabelStyle:
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
  );

  static final BottomNavigationBarThemeData dark = BottomNavigationBarThemeData(
      selectedItemColor: ColorTheme.RED,
      unselectedItemColor: ColorTheme.BLACK,
      showUnselectedLabels: true,
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle:
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
  );
}

class TNavigationBarTheme{
  TNavigationBarTheme._();

  static final NavigationBarThemeData light = NavigationBarThemeData(
    backgroundColor: ColorTheme.WHITE,
  );

  static final NavigationBarThemeData dart = NavigationBarThemeData(
    backgroundColor: Colors.black
  );
}