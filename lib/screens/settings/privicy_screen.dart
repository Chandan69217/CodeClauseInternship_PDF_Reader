import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool is2FAEnabled = true;
  bool appLockEnabled = false;
  bool locationAccess = true;
  bool personalizedAds = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy & Security", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Privacy Settings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _settingTile(
            title: "Location Access",
            subtitle: "Allow app to access your location",
            value: locationAccess,
            onChanged: (val) => setState(() => locationAccess = val),
          ),
          _settingTile(
            title: "Personalized Ads",
            subtitle: "Receive tailored ads based on your usage",
            value: personalizedAds,
            onChanged: (val) => setState(() => personalizedAds = val),
          ),
          const SizedBox(height: 24),
          const Text(
            "Security Settings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _settingTile(
            title: "Two-Factor Authentication",
            subtitle: "Add an extra layer of security to your account",
            value: is2FAEnabled,
            onChanged: (val) => setState(() => is2FAEnabled = val),
          ),
          _settingTile(
            title: "App Lock",
            subtitle: "Require a PIN or biometrics to open app",
            value: appLockEnabled,
            onChanged: (val) => setState(() => appLockEnabled = val),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: width,
            child: OutlinedButton.icon(
              onPressed: () {
                // Navigate to permissions screen or manage permissions
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.purple,
                side: const BorderSide(color: Colors.purple),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.security_outlined),
              label: const Text("Manage App Permissions"),
            ),
          )
        ],
      ),
    );
  }

  Widget _settingTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.purple,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}