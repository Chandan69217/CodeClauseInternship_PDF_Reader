
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';

import '../../../external_storage/read_storage.dart';
import '../../../utilities/color.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../file_viewer.dart';

class ExcelFileTab extends StatefulWidget {
  final String trailing;

  ExcelFileTab({
    this.trailing ='assets/icons/three_dots_icon.png',
});

  @override
  State<ExcelFileTab> createState() => _ExcelFileTabState();
}

class _ExcelFileTabState extends State<ExcelFileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:FutureBuilder(
        future: Read(context).getExcelsFiles(),
        builder: (BuildContext context, AsyncSnapshot<List<Data>> snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context,index){
                  return CustomListTile(
                    title: snapshot.data![index].fileName,
                    subTitle: snapshot.data![index].details,
                    trailing: widget.trailing,
                    onTap: (){
                      print('Clicked:  $index');
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>FileViewer(filePath: snapshot.data![index].filePath,)));
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
