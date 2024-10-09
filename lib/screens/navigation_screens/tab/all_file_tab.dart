

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/widgets/custom_list_tile.dart';

class AllFileTab extends StatefulWidget{
  final String iconPath;
  final String title;
  final String subTitle;
  final String trailing;

  AllFileTab({
    required this.iconPath,
    required this.title,
    required this.subTitle,
    this.trailing ='assets/icons/three_dots_icon.png',
});

  @override
  State<StatefulWidget> createState() => _States();
}

class _States extends State<AllFileTab> {
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