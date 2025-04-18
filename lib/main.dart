import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_reader/external_storage/read_storage.dart';
import 'package:pdf_reader/screens/settings/theme_screen.dart';
import 'package:pdf_reader/screens/splash_screen.dart';
import 'package:pdf_reader/utilities/custom_theme/app_theme/app_theme.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  TThemeMode.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Read>(create: (context) => Read(context),)
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: TThemeMode.instance.themeMode,
        builder: (context,themeMode,child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'PDF Reader',
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
