
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/external_storage/read_storage.dart';
import 'package:pdf_reader/screens/pdf_viewer.dart';
import 'package:pdf_reader/utilities/color.dart';

import '../../../model/data.dart';
import '../../../widgets/custom_list_tile.dart';

class PdfFileTab extends StatefulWidget {
  final String trailing;

  PdfFileTab({
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
        future: Read(context).getPdfFiles(),
        builder: (BuildContext context, AsyncSnapshot<List<Data>> snapshot) {
          print(snapshot.hasData);
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context,index){
                  return CustomListTile(
                      title: snapshot.data![index].fileName,
                      subTitle: snapshot.data![index].details,
                      trailing: widget.trailing,
                    onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>PdfViewer(filePath: snapshot.data![index].filePath,)));
                    },
                  );
                });
          }else{
            return const Center(child: CircularProgressIndicator(color: ColorTheme.RED,),);
          }
        },
      )
      ),
    );


  }

}
