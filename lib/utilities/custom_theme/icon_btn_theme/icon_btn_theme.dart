import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/color_theme.dart';

class TIconBtnTheme{

  TIconBtnTheme._();

  static final IconButtonThemeData light = IconButtonThemeData(
      style: IconButton.styleFrom(
        iconSize: 20.0,
        overlayColor: ColorTheme.PRIMARY,
        foregroundColor: ColorTheme.BLACK.withValues(alpha: 0.5),
      )
  );

  static final IconButtonThemeData dark = IconButtonThemeData(
    style: IconButton.styleFrom(
        iconSize: 20.0,
      overlayColor: ColorTheme.PRIMARY,
      foregroundColor: Colors.white.withValues(alpha: 0.5),
    )
  );
}