import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/callbacks.dart';
import 'package:sizing/sizing.dart';

import '../model/data.dart';
import '../utilities/color.dart';

void showDeleteWidget(
    BuildContext home_context, Data data, OnDeleted onDeleted) {
  showModalBottomSheet(
      context: home_context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(0),
          child: Column(
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
          ),
        );
      });
}

void _deleteFile(Data data, OnDeleted onDeleted) async {
  if (await data.file.exists()) {
    try {
      data.file.deleteSync();
      onDeleted(true);
    } catch (exception, trace) {
      onDeleted(false);
      print('$exception : $trace');
    }
  } else {
    onDeleted(false);
    print('file does not exist');
  }
}
