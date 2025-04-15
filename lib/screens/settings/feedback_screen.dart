import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _sendFeedback() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final message = _messageController.text.trim();
      await _sendFeedbackEmail(context,
          name: name, email: email, message: message);
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      labelStyle: Theme.of(context).textTheme.bodySmall,
      fillColor: ColorTheme.WHITE,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Text("We’d love to hear your thoughts!",
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              Card(
                child: TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration("Your Name (optional)"),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("Your Email (optional)"),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: TextFormField(
                  controller: _messageController,
                  maxLines: 5,
                  decoration: _inputDecoration("Your Feedback"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Feedback message cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _sendFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: ColorTheme.WHITE,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Send Feedback"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<bool> _sendFeedbackEmail(
    BuildContext context, {
    String? name = '',
    String? email = '',
    required String message,
  }) async {
    const String recipient = 'chandansharma69217@gmail.com';

    final String formattedBody = '''
$name
$email

$message
''';

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipient,
      query: encodeQueryParameters(<String, String>{
        'subject': 'App Feedback',
        'body': formattedBody,
      }),
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch email app')),
        );
        return false;
      }
    } catch (e) {
      print('Could not launch email app: $e');
      return false;
    }
  }
}
