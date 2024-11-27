import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/get_icon_path.dart';
import 'package:sizing/sizing.dart';

class CustomListTile extends StatelessWidget {
  final VoidCallback onOptionClick;
  final VoidCallback onTap;
  final Data data;

  CustomListTile(
      {super.key,
      required this.data,
      required this.onOptionClick,
      required this.onTap,
      }
      );



  @override
  Widget build(BuildContext context) {


    return ListTile(
        contentPadding: EdgeInsets.only(left: 18.ss, right: 6.ss),
        onTap: ()=> onTap(),
        leading: Image.asset(
          getIconPath(data.fileType),
          width: 45.ss,
          height: 45.ss,
        ),
        title: Text(
          data.fileName,
          maxLines: 1,
        ),
        subtitle: Text(
          data.details,
          maxLines: 1,
        ),
        trailing: IconButton(
            onPressed: () {
              onOptionClick();
            },
            icon: Image.asset(
              'assets/icons/three_dots_icon.png',
              width: 25.ss,
              height: 25.ss,
            )));
  }
}
