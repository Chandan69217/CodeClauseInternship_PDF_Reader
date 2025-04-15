import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/utilities/my_url.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("About App"),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "About PDF Reader",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          const Text(
            "Our PDF Reader app allows you to open, view, and manage PDF files seamlessly. Whether it's for study, work, or personal use, our intuitive interface and fast performance provide a smooth reading experience.",
          ),
          const SizedBox(height: 24),
          Text(
            "Features",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          _featureItem("✔ Open and view PDF files easily"),
          _featureItem("✔ Bookmark important pages"),
          _featureItem("✔ Dark mode for night reading"),
          _featureItem("✔ Easy file search and sharing"),
          const SizedBox(height: 30),
          Text(
            "Legal & Policies",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 18.0),
          ),
          const SizedBox(height: 12),
          _policyTile(
            context,
            title: "Privacy Policy",
            url: MyUrl.privacyPolicyUrl,
          ),
          _policyTile(
            context,
            title: "Terms & Conditions",
            url: MyUrl.termsUrl,
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              "Version 1.0.0",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
        ],
      ),
    );
  }

  Widget _featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _policyTile(BuildContext context, {required String title, required String url}) {
    return Card(
      elevation: 0,
      color: ColorTheme.WHITE,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16,),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open link')),
            );
          }
        },
      ),
    );
  }
}
