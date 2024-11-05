import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/color.dart';
import 'package:pdf_reader/widgets/show_delete_widget.dart';
import 'package:pdf_reader/widgets/show_file_details_widget.dart';
import 'package:pdf_reader/widgets/show_rename_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizing/sizing.dart';

import '../utilities/callbacks.dart';

void customBottomSheet(
    {required BuildContext home_context,
    required Data data,
    required OnRenamed onRenamed,
    required OnDeleted onDeleted}) {
  showModalBottomSheet(
      context: home_context,
      sheetAnimationStyle: AnimationStyle(curve: Curves.linear),
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(24.ss),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 12.ss),
                  child: _topDesign(context, data.fileName, data.details)),
              SizedBox(
                height: 6.ss,
              ),
              Divider(
                height: 1,
                color: ColorTheme.BLACK.withOpacity(0.3),
              ),
              ListTile(
                leading: Icon(Icons.drive_file_rename_outline),
                title: Text(
                  'Rename',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showRenameWidget(
                      home_context: home_context,
                      data: data,
                      onRenamed: onRenamed);
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text(
                  'Share',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _shareFile(data);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_rounded),
                title: Text(
                  'Delete',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDeleteWidget(home_context, data, onDeleted);
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text(
                  'Details',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showFileDetails(home_context: home_context, data: data);
                },
              ),
            ],
          ),
        );
      });
}

Widget _topDesign(BuildContext context, String title, String subTitle) {
  String extension = title.split('.').last.toLowerCase();
  String iconPath = '';
  if (extension == 'pdf') {
    iconPath = 'assets/icons/pdf.png';
  } else if (extension == 'doc' || extension == 'docx') {
    iconPath = 'assets/icons/doc.png';
  } else if (extension == 'ppt' || extension == 'pptx') {
    iconPath = 'assets/icons/ppt.png';
  } else if (extension == 'xls' || extension == 'xlsx') {
    iconPath = 'assets/icons/xls.png';
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        flex: 1,
        child: Image.asset(
          iconPath,
          width: 45.ss,
          height: 45.ss,
        ),
      ),
      Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                subTitle,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          )),
      Expanded(
          flex: 1,
          child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/icons/bookmark_icon.png',
                width: 40.ss,
                height: 40.ss,
              )))
    ],
  );
}

void _shareFile(Data data) {
  Share.shareXFiles([XFile(data.filePath)]);
}
