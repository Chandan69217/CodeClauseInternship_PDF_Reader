import 'dart:async';

import 'package:flutter/material.dart';

class ShowStickySnackbar {
  ShowStickySnackbar._();

  static Future<void> showStickySnackBarAndWait(BuildContext context, String message) async {
    final completer = Completer<void>();

    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(days: 1), // Sticky until dismissed
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          completer.complete(); // Complete the future
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Wait until user taps "OK"
    await completer.future;
  }
}
