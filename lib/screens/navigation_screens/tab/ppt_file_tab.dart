
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/file_view_handler.dart';

import '../../../external_storage/read_storage.dart';
import '../../../utilities/color.dart';
import '../../../widgets/custom_bottomsheet.dart';
import '../../../widgets/custom_list_tile.dart';

class PptFileTab extends StatefulWidget {
  final String trailing;

  PptFileTab({
    this.trailing ='assets/icons/three_dots_icon.png',
});

  @override
  State<PptFileTab> createState() => _PptFileTabState();
}

class _PptFileTabState extends State<PptFileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:FutureBuilder(
        future: Read(context).getPptFiles(),
        builder: (BuildContext context, AsyncSnapshot<List<Data>> snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context,index){
                  return CustomListTile(
                    title: snapshot.data![index].fileName,
                    subTitle: snapshot.data![index].details,
                    trailing: widget.trailing,
                    onOptionClick: (){
                      customBottomSheet(context: context, data: snapshot.data![index]);
                    },
                    onTap: (){
                      print('Clicked:  $index');
                      // Navigator.push(context,MaterialPageRoute(builder: (context)=>FileViewer(filePath: snapshot.data![index].filePath,)));
                      fileViewHandler(context, snapshot.data![index]);
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
