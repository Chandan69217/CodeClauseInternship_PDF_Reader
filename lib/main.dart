// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart';
import 'package:pdf_reader/screens/splash_screen.dart';
import 'package:pdf_reader/utilities/theme_data.dart';
import 'package:sizing/sizing.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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

