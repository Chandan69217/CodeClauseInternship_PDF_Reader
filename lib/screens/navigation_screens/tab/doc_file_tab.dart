import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_list_tile.dart';

class DocFileTab extends StatefulWidget {
  DocFileTab._();
  factory DocFileTab(){
    return DocFileTab._();
  }
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
            return CustomListTile(iconPath: 'assets/icons/doc.png', title: 'My Offer Letter.doc', subTitle: '253.2 OCT 9 2024');
          })
      ),
    );
  }
}
