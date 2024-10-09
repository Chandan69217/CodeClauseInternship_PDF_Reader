import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_list_tile.dart';

class DocFileTab extends StatefulWidget {
  final String iconPath;
  final String title;
  final String subTitle;
  final String trailing;

  DocFileTab({
    required this.iconPath,
    required this.title,
    required this.subTitle,
    this.trailing ='assets/icons/three_dots_icon.png',
});

  @override
  State<DocFileTab> createState() => _DocFileTabState();
}

class _DocFileTabState extends State<DocFileTab> {
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
