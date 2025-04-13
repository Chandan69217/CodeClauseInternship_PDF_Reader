import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/custom_theme/icon_btn_theme/icon_btn_theme.dart';
import 'package:pdf_reader/utilities/custom_theme/list_tile_theme/list_tile_theme.dart';
import 'package:pdf_reader/utilities/custom_theme/text_sel_theme_data/text_sel_theme_data.dart';
import 'package:pdf_reader/utilities/custom_theme/text_theme/text_theme.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/utilities/custom_theme/appbar_theme/appbar_theme.dart';
import 'package:pdf_reader/utilities/custom_theme/bottom_nav_bar_theme/bottom_navigation_bar_theme.dart';
import 'package:pdf_reader/utilities/custom_theme/popup_menu_theme/popup_menu_theme.dart';
import 'package:pdf_reader/utilities/custom_theme/txt_btn_theme/txt_btn_theme.dart';


class AppTheme{
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
      fontFamily: 'Inter',
      primaryColor: ColorTheme.PRIMARY,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ColorTheme.WHITE,
      appBarTheme: TAppbarTheme.lightAppbarTheme,
      bottomNavigationBarTheme: TBottomNavigationBarTheme.light,
      navigationBarTheme: TNavigationBarTheme.light,
      useMaterial3: true,
      textTheme: TTextTheme.lightTextTheme,
    listTileTheme: TListTileTheme.light,
    popupMenuTheme: TPopupMenuTheme.lightTheme,
    textSelectionTheme: TTextSelectionThemeData.light,
    iconButtonTheme: TIconBtnTheme.light,
      iconTheme: IconThemeData(
          color: ColorTheme.BLACK
      ),
      textButtonTheme: TTextButtonTheme.ligth
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Inter',
    primaryColor: ColorTheme.PRIMARY,
    brightness: Brightness.dark,
    useMaterial3: true,
    navigationBarTheme: TNavigationBarTheme.dart,
    bottomNavigationBarTheme: TBottomNavigationBarTheme.dark    ,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: TAppbarTheme.darkAppbarTheme,
    textTheme: TTextTheme.darkTextTheme,
     listTileTheme: TListTileTheme.dark,
    popupMenuTheme: TPopupMenuTheme.darkTheme,
    textSelectionTheme: TTextSelectionThemeData.dark,
    iconButtonTheme: TIconBtnTheme.dark,
    iconTheme: IconThemeData(
      color: ColorTheme.WHITE
    ),
    textButtonTheme: TTextButtonTheme.dark
  );

}