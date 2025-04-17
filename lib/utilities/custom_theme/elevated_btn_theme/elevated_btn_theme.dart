import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/utilities/custom_theme/text_theme/text_theme.dart';

class ElevatedBtnTheme {
  ElevatedBtnTheme._();

  static final ElevatedButtonThemeData light =
      ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: TTextTheme.lightTextTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        iconColor: ColorTheme.WHITE,
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: ColorTheme.WHITE,
      ));

  static final ElevatedButtonThemeData dark = ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    textStyle: TTextTheme.lightTextTheme.bodyMedium,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 2,
    iconColor: ColorTheme.WHITE,
    backgroundColor: Colors.deepPurpleAccent,
    foregroundColor: ColorTheme.WHITE,
  ));
}
