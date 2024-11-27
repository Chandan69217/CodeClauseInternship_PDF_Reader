import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/external_storage/read_storage.dart';
import 'package:pdf_reader/utilities/callbacks.dart';
import 'package:sizing/sizing.dart';

import '../model/data.dart';
import '../utilities/color_theme.dart';

void showDeleteWidget(
    BuildContext home_context, Data data, OnChanged onDeleted) {
  showModalBottomSheet(
      context: home_context,
      constraints: BoxConstraints(minWidth: MediaQuery.of(home_context).size.width),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(8.ss),
              child: RichText(
                text: TextSpan(
                    text: 'Total size ',
                    style: Theme.of(home_context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 11.fss),
                    children: [TextSpan(text: data.fileSize)]),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteFile(data, onDeleted);
              },
              style: ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(
                      ColorTheme.PRIMARY.withOpacity(0.5)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
                  fixedSize: WidgetStatePropertyAll(
                      Size(MediaQuery.of(home_context).size.width, 65))),
              child: Text(
                'Delete',
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
}

void _deleteFile(Data data, OnChanged onDeleted) async {
    try {
      onDeleted(await Read.removeFiles(data));
    } catch (exception, trace) {
      print('$exception : $trace');
    }
}

// void _deleteFile(Data data, OnDeleted onDeleted) async {
//   if (await data.file.exists()) {
//     try {
//       data.file.deleteSync();
//       onDeleted(true,data);
//     } catch (exception, trace) {
//       onDeleted(false,data);
//       print('$exception : $trace');
//     }
//   } else {
//     onDeleted(false,data);
//     print('file does not exist');
//   }
// }
