import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/color.dart';
import 'package:sizing/sizing.dart';

ThemeData themeData() {
  return ThemeData(
      appBarTheme: AppBarTheme(color: ColorTheme.PRIMARY),
      useMaterial3: true,
      textTheme: TextTheme(
          headlineLarge: TextStyle(
              color: ColorTheme.BLACK,
              fontSize: 24.fss,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
              color: ColorTheme.BLACK,
              fontSize: 20.fss,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(
              color: ColorTheme.BLACK, fontSize: 18.fss, fontFamily: 'Inter'),
          bodyMedium: TextStyle(
              color: ColorTheme.BLACK, fontSize: 16.fss, fontFamily: 'Inter'),
          bodySmall: TextStyle(
              color: ColorTheme.BLACK, fontSize: 14.fss, fontFamily: 'Inter'),
          titleSmall: TextStyle(
              color: ColorTheme.BLACK,
              fontSize: 12.fss,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold)),
      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(
          color: ColorTheme.BLACK,
          fontSize: 16.fss,
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
        ),
        subtitleTextStyle: TextStyle(
            color: ColorTheme.BLACK, fontSize: 14.fss, fontFamily: 'Inter',overflow: TextOverflow.ellipsis),
      ));
}
