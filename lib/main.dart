// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_reader/screens/splash_screen.dart';
import 'package:pdf_reader/external_storage/database_helper.dart';
import 'package:pdf_reader/utilities/theme_data.dart';
import 'package:sizing/sizing.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent));
    return SizingBuilder(
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PDF Reader',
        theme: themeData(),
        home: const SplashScreen(),
      ),
    );
  }
}
