import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/color_theme.dart';

class TAppbarTheme{
  TAppbarTheme._();

  static final AppBarTheme lightAppbarTheme = AppBarTheme(
      backgroundColor: ColorTheme.PRIMARY,
      iconTheme: IconThemeData(
          color: ColorTheme.BLACK
      )
  );

  static final AppBarTheme darkAppbarTheme = AppBarTheme(
      backgroundColor: Colors.black,
    iconTheme: IconThemeData(
      color: ColorTheme.WHITE
    )
  );
}