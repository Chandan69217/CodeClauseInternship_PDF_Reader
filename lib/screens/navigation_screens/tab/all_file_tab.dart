

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/widgets/custom_list_tile.dart';

class AllFileTab extends StatefulWidget{
  AllFileTab._();
  factory AllFileTab(){
    return AllFileTab._();
  }
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
        return CustomListTile(iconPath: 'assets/icons/pdf.png', title: 'My Offer Letter.pdf', subTitle: '253.2 OCT 9 2024');
      })
      ),
    );
  }
}