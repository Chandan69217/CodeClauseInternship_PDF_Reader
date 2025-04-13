import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/color_theme.dart';

class TPopupMenuTheme{
  TPopupMenuTheme._();

  static final lightTheme = PopupMenuThemeData(
    iconColor: ColorTheme.BLACK,
      color: ColorTheme.WHITE,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18)),
  );

  static final darkTheme = PopupMenuThemeData(
      iconColor: ColorTheme.WHITE,
    color: ColorTheme.BLACK,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18)),
  );

}