import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  String selectedTheme = 'System Default';

  final List<String> themes = ['Light', 'Dark', 'System Default'];

  @override
  void initState() {
    super.initState();
    selectedTheme = TThemeMode.instance.currentThemeName;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme',),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: themes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8.0),
        itemBuilder: (context, index) {
          final theme = themes[index];
          final isSelected = theme == selectedTheme;
          return GestureDetector(
            onTap: () {
              setState(() {
                TThemeMode.instance.setTheme(theme);
                selectedTheme = theme;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? Colors.purple : Colors.transparent,
                  width: 1.2,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(theme,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.purple : null)),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: Colors.purple)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



class TThemeMode {

  static final TThemeMode _instance = TThemeMode._internal();
  TThemeMode._internal();
  static TThemeMode get instance => _instance;

  static const String _themeKey = 'theme_mode';
  static const String _light = 'Light';
  static const String _dark = 'Dark';
  static const String _system = 'System Default';

  final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    final saved = _prefs!.getString(_themeKey) ?? _system;
    themeMode.value = _stringToThemeMode(saved);
  }

  Future<void> setTheme(String themeName) async {
    await _prefs?.setString(_themeKey, themeName);
    themeMode.value = _stringToThemeMode(themeName);
  }

  ThemeMode _stringToThemeMode(String name) {
    switch (name) {
      case _dark:
        return ThemeMode.dark;
      case _light:
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  String get currentThemeName {
    switch (themeMode.value) {
      case ThemeMode.dark:
        return _dark;
      case ThemeMode.light:
        return _light;
      default:
        return _system;
    }
  }

}
