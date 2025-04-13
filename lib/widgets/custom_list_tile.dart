import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/get_icon_path.dart';


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
        contentPadding: EdgeInsets.only(left: 18, right: 6),
        onTap: ()=> onTap(),
        leading: Image.asset(
          getIconPath(data.fileType),
          width: 45,
          height: 45,
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
              'assets/icons/three_dots_icon.webp',
              width: 25,
              height: 25,
            )
        )
    );
  }
}
