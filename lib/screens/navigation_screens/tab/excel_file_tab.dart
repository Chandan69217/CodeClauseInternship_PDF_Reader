import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/file_view_handler.dart';

import '../../../external_storage/read_storage.dart';
import '../../../widgets/custom_bottomsheet.dart';
import '../../../widgets/custom_list_tile.dart';

class ExcelFileTab extends StatefulWidget {
  final String trailing;

  ExcelFileTab({
    Key? key,
    this.trailing = 'assets/icons/three_dots_icon.png',
  }):super(key: key);

  @override
  State<ExcelFileTab> createState() => ExcelFileTabState();
}

class ExcelFileTabState extends State<ExcelFileTab> with WidgetsBindingObserver{
  List<Data> _snapshot = [];
  @override
  void initState() {
    super.initState();
    _snapshot = _getXls();
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
                            _snapshot = _getXls();
                          });
                        },
                        onDeleted: (status,data) {
                          if (status)
                            setState(() {
                              Read.updateFilesDeletion(data);
                              _snapshot = _getXls();
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
      _snapshot = _getXls();
    });
  }

  List<Data> _getXls(){
    List<Data> xls = [];
    for(var data in Read.AllFiles){
      if(data.fileType == 'xls' || data.fileType == 'xlsx'){
        xls.add(data);
      }
    }
    return xls;
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
