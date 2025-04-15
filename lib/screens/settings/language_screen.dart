import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = 'English';

  final List<String> languages = [
    'English',
    'हिन्दी',
    'Español',
    'Français',
    'Deutsch',
    'বাংলা',
    'தமிழ்',
    'తెలుగు',
    '中文',
    '日本語',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language',),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: languages.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final language = languages[index];
          final isSelected = language == selectedLanguage;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedLanguage = language;
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
                  Text(language,
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