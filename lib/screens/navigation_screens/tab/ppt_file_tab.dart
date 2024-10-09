import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_list_tile.dart';

class PptFileTab extends StatefulWidget {
  PptFileTab._();
  factory PptFileTab(){
    return PptFileTab._();
  }

  @override
  State<PptFileTab> createState() => _PptFileTabState();
}

class _PptFileTabState extends State<PptFileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:ListView.builder(
          itemCount: 100,
          itemBuilder: (context,index){
            return CustomListTile(iconPath: 'assets/icons/ppt.png', title: 'My Offer Letter.pdf', subTitle: '253.2 OCT 9 2024');
          })
      ),
    );
  }
}
