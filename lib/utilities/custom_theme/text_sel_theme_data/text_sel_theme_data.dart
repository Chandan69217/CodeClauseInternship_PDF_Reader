import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/color_theme.dart';

class TTextSelectionThemeData{
  TTextSelectionThemeData._();

  static final TextSelectionThemeData light = TextSelectionThemeData(
      selectionHandleColor: ColorTheme.RED,
      selectionColor: ColorTheme.PRIMARY
  );

  static final TextSelectionThemeData dark = TextSelectionThemeData(
      selectionHandleColor: ColorTheme.RED,
      selectionColor: Colors.grey,
  );
}