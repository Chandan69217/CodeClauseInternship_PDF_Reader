import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/external_storage/read_storage.dart';
import 'package:pdf_reader/screens/pdf_viewer.dart';
import 'package:pdf_reader/utilities/color.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:FutureBuilder(
        future: Read().getPdfFiles(),
        builder: (BuildContext context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context,index){
                  String title = snapshot.data![index].path.split('/').last;
                  return CustomListTile(
                      iconPath: widget.iconPath,
                      title: title,
                      subTitle: widget.subTitle,
                      trailing: widget.trailing,
                    onTap: (){
                        print('Clicked:  $index');
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>PdfViewer(filePath: snapshot.data![index].path,)));
                    },
                  );
                });
          }else{
            return Center(child: CircularProgressIndicator(color: ColorTheme.RED,),);
          }
        },
      )
      ),
    );
  }


}
