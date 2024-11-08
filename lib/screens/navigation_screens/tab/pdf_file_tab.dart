import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/external_storage/read_storage.dart';
import 'package:pdf_reader/utilities/file_view_handler.dart';
import '../../../model/data.dart';
import '../../../widgets/custom_bottomsheet.dart';
import '../../../widgets/custom_list_tile.dart';

class PdfFileTab extends StatefulWidget {
  final String trailing;

  PdfFileTab({Key? key, this.trailing = 'assets/icons/three_dots_icon.png'})
      : super(key: key);

  @override
  State<PdfFileTab> createState() => PdfFileTabState();
}

class PdfFileTabState extends State<PdfFileTab> with WidgetsBindingObserver {
  List<Data> _snapshot = [];
  @override
  void initState() {
    super.initState();
    _snapshot = _getPdf();
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
                        onRenamed: (oldData, newData) {
                          setState(() {
                            Read.updateFilesRename(oldData, newData);
                            _snapshot = _getPdf();
                          });
                        },
                        onDeleted: (status, data) {
                          if (status) {
                            setState(() {
                              Read.updateFilesDeletion(data);
                              _snapshot = _getPdf();
                            });
                          }
                        });
                  },
                  onTap: () {
                    fileViewHandler(context, _snapshot[index],onDelete: (status,data){if(status){Read.updateFilesDeletion(data);refresh();}},onRenamed:(oldData,newData){Read.updateFilesRename(oldData, newData);refresh();} );
                  },
                );
              })),
    );
  }

  refresh(){
    setState(() {
      _snapshot = _getPdf();
    });
  }

  List<Data> _getPdf(){
    List<Data> pdf = [];
    for(var data in Read.AllFiles){
      if(data.fileType == 'pdf'){
        pdf.add(data);
      }
    }
    return pdf;
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
