import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final VoidCallback onOptionClick;
  final VoidCallback onTap;
  final String trailing;

  CustomListTile(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.onOptionClick,
      required this.onTap,
      required this.trailing});


  String _getIconPath(String title) {
    String extension = title.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'assets/icons/pdf.png';
      case 'doc':
      case 'docx':
        return 'assets/icons/doc.png';
      case 'ppt':
      case 'pptx':
        return 'assets/icons/ppt.png';
      case 'xls':
      case 'xlsx':
        return 'assets/icons/xls.png';
      default:
        return 'assets/icons/pdf.png';
    }
  }
  @override
  Widget build(BuildContext context) {

    String iconPath = _getIconPath(title);
    return ListTile(
        contentPadding: EdgeInsets.only(left: 18.ss, right: 6.ss),
        onTap: ()=> onTap(),
        leading: Image.asset(
          iconPath,
          width: 45.ss,
          height: 45.ss,
        ),
        title: Text(
          title,
          maxLines: 1,
        ),
        subtitle: Text(
          subTitle,
          maxLines: 1,
        ),
        trailing: IconButton(
            onPressed: () {
              onOptionClick();
            },
            icon: Image.asset(
              trailing,
              width: 25.ss,
              height: 25.ss,
            )));
  }
}
