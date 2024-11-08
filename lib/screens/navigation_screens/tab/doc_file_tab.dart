import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/file_view_handler.dart';
import 'package:pdf_reader/widgets/custom_bottomsheet.dart';

import '../../../external_storage/read_storage.dart';
import '../../../model/data.dart';
import '../../../widgets/custom_list_tile.dart';

class DocFileTab extends StatefulWidget {
  final String trailing;

  DocFileTab({
    Key? key,
    this.trailing = 'assets/icons/three_dots_icon.png',
  }):super(key: key);

  @override
  State<DocFileTab> createState() => DocFileTabState();
}

class DocFileTabState extends State<DocFileTab> with WidgetsBindingObserver{
  List<Data> _snapshot = [];
  @override
  void initState() {
    super.initState();
    _snapshot = _getDoc();;
    WidgetsBinding.instance.addObserver(this);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView.builder(
              itemCount: _snapshot.length,
              itemBuilder: (context, index) {
                return CustomListTile(
                  title: _snapshot[index].fileName,
                  subTitle: _snapshot[index].details,
                  trailing: widget.trailing,
                  onOptionClick: () {
                    customBottomSheet(
                        home_context: context,
                        data: _snapshot[index],
                        onRenamed: (oldData,newData) {
                          setState(() {
                            Read.updateFilesRename(oldData, newData);
                            _snapshot = _getDoc();;
                          });
                        },
                        onDeleted: (status,data) {
                          if (status)
                            setState(() {
                              Read.updateFilesDeletion(data);
                              _snapshot = _getDoc();;
                            });
                        });
                  },
                  onTap: () {
                    // Navigator.push(context,MaterialPageRoute(builder: (context)=>FileViewer(filePath: snapshot.data![index].filePath,)));
                    fileViewHandler(context, _snapshot[index],onDelete: (status,data){if(status){Read.updateFilesDeletion(data);refresh();}},onRenamed:(oldData,newData){Read.updateFilesRename(oldData, newData);refresh();} );
                  },
                );
              })
      ),
    );
  }

  refresh(){
    setState(() {
      _snapshot = _getDoc();
    });
  }

  List<Data> _getDoc(){
    List<Data> doc = [];
    for(var data in Read.AllFiles){
      if(data.fileType == 'doc' || data.fileType == 'docx'){
        doc.add(data);
      }
    }
    return doc;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
