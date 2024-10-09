import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_list_tile.dart';

class PdfFileTab extends StatefulWidget {
  final String iconPath;
  final String title;
  final String subTitle;
  final String trailing;

  PdfFileTab({
    required this.iconPath,
    required this.title,
    required this.subTitle,
    this.trailing ='assets/icons/three_dots_icon.png'
});


  @override
  State<PdfFileTab> createState() => _PdfFileTabState();
}

class _PdfFileTabState extends State<PdfFileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:ListView.builder(
          itemCount: 100,
          itemBuilder: (context,index){
            return CustomListTile(iconPath: widget.iconPath, title: widget.title, subTitle: widget.subTitle,trailing: widget.trailing,);
          })
      ),
    );
  }
}
