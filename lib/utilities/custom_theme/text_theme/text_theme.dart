import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/color_theme.dart';

class TTextTheme {
  TTextTheme._();

  static const TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle(
      color: ColorTheme.BLACK,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: ColorTheme.BLACK,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: ColorTheme.BLACK,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      color: ColorTheme.BLACK,
      fontSize: 18,
    ),
    bodyMedium: TextStyle(
      color: ColorTheme.BLACK,
      fontSize: 16,
    ),
    bodySmall: TextStyle(
      color: ColorTheme.BLACK,
      fontSize: 14,
    ),
    titleLarge: TextStyle(
      color: ColorTheme.BLACK,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: ColorTheme.BLACK,
      fontSize: 11,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      color: ColorTheme.BLACK,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    ),
  );

  static const TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
      color: ColorTheme.WHITE,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: ColorTheme.WHITE,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: ColorTheme.WHITE,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      color: ColorTheme.WHITE,
      fontSize: 18,
    ),
    bodyMedium: TextStyle(
      color: ColorTheme.WHITE,
      fontSize: 16,
    ),
    bodySmall: TextStyle(
      color: ColorTheme.WHITE,
      fontSize: 14,
    ),
    titleLarge: TextStyle(
      color: ColorTheme.WHITE,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: ColorTheme.WHITE,
      fontSize: 11,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      color: ColorTheme.WHITE,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    ),
  );
}
