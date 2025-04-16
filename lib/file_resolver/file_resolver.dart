import 'package:flutter/services.dart';

class FileResolver{

  static const platform = MethodChannel('com.file.resolver');

  static Future<String?> resolveContentUri(String uri) async {
    try {
      final String? path = await platform.invokeMethod('copyFileFromUri', {
        'uri': uri,
      });
      return path;
    } catch (e) {
      print("Error resolving content URI: $e");
      return null;
    }
  }

}

