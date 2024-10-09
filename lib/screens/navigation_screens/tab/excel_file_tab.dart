import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_list_tile.dart';

class ExcelFileTab extends StatefulWidget {
  ExcelFileTab._();
  factory ExcelFileTab(){
    return ExcelFileTab._();
  }

  @override
  State<ExcelFileTab> createState() => _ExcelFileTabState();
}

class _ExcelFileTabState extends State<ExcelFileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:ListView.builder(
          itemCount: 100,
          itemBuilder: (context,index){
            return CustomListTile(iconPath: 'assets/icons/xls.png', title: 'My Offer Letter.pdf', subTitle: '253.2 OCT 9 2024');
          })
      ),
    );
  }
}
