import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_list_tile.dart';

class PdfFileTab extends StatefulWidget {
  PdfFileTab._();
  factory PdfFileTab(){
    return PdfFileTab._();
  }

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
            return CustomListTile(iconPath: 'assets/icons/pdf.png', title: 'My Offer Letter.pdf', subTitle: '253.2 OCT 9 2024');
          })
      ),
    );
  }
}
