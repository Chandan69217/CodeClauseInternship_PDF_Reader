


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/file_view_handler.dart';
import 'package:pdf_reader/widgets/custom_list_tile.dart';

import '../../../external_storage/read_storage.dart';
import '../../../model/data.dart';
import '../../../utilities/color.dart';

class AllFileTab extends StatefulWidget{
  final String trailing;

  AllFileTab({
    this.trailing ='assets/icons/three_dots_icon.png',
});

  @override
  State<StatefulWidget> createState() => _States();
}

class _States extends State<AllFileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:FutureBuilder(
        future: Read(context).getAllFiles(),
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