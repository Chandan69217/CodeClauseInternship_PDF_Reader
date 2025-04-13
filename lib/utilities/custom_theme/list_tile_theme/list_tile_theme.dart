import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/utilities/custom_theme/text_theme/text_theme.dart';

class TListTileTheme {
  TListTileTheme._();

  static final ListTileThemeData light  = ListTileThemeData(
      titleTextStyle: TTextTheme.lightTextTheme.bodyMedium,
      subtitleTextStyle: TTextTheme.lightTextTheme.bodySmall,
      selectedColor: ColorTheme.BLACK,
      selectedTileColor: ColorTheme.PRIMARY
  );

  static final ListTileThemeData dark = ListTileThemeData(
    titleTextStyle: TTextTheme.darkTextTheme.bodyMedium,
    subtitleTextStyle: TTextTheme.darkTextTheme.bodySmall,
    selectedTileColor: Colors.grey,
    selectedColor: ColorTheme.WHITE,
  );
}