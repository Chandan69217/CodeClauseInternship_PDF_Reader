import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/data.dart';
import '../utilities/color_theme.dart';



Future<bool> showConfirmWidget (
{ required BuildContext home_context, Data? data, required String label,String? message}) async {
  Completer<bool> completer = Completer<bool>();
  showModalBottomSheet(
      context: home_context,
      constraints: BoxConstraints(minWidth: MediaQuery.of(home_context).size.width),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: data != null ? RichText(
                text: TextSpan(
                    text: 'Total size ',
                    style: Theme.of(home_context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 11),
                    children: [TextSpan(text: data.fileSize)]),
                textAlign: TextAlign.center,
              ) : RichText(
                text: TextSpan(
                    text: message,
                    style: Theme.of(home_context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 11),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                completer.complete(true);
              },
              style: ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(
                      ColorTheme.PRIMARY.withOpacity(0.5)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
                  fixedSize: WidgetStatePropertyAll(
                      Size(MediaQuery.of(home_context).size.width, 65))),
              child: Text(
                label,
                style: Theme.of(home_context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: ColorTheme.RED),
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Divider(
                  height: 1,
                  color: ColorTheme.BLACK.withOpacity(0.1),
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  completer.complete(false);
                },
                style: ButtonStyle(
                    overlayColor: WidgetStatePropertyAll(
                        ColorTheme.PRIMARY.withOpacity(0.5)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
                    fixedSize: WidgetStatePropertyAll(
                        Size(MediaQuery.of(home_context).size.width, 65))),
                child: Text(
                  'Cancel',
                  style: Theme.of(home_context).textTheme.bodyMedium,
                )),
          ],
        );
      });
  return completer.future;
}

