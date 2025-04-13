import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/color_theme.dart';

class TTextButtonTheme{

  TTextButtonTheme._();

  static final TextButtonThemeData ligth = TextButtonThemeData(
      style: TextButton.styleFrom(
        overlayColor: ColorTheme.PRIMARY,
        iconColor: ColorTheme.BLACK,
        shape: const RoundedRectangleBorder(),
        foregroundColor: ColorTheme.BLACK,
      )
  );

  static final TextButtonThemeData dark = TextButtonThemeData(
      style: TextButton.styleFrom(
        overlayColor: Colors.grey,
        iconColor: ColorTheme.WHITE,
        shape: const RoundedRectangleBorder(),
        foregroundColor: ColorTheme.WHITE,
      )
  );
}