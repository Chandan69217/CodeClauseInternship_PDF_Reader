import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/file_view_handler.dart';
import '../../../external_storage/read_storage.dart';
import '../../../widgets/custom_bottomsheet.dart';
import '../../../widgets/custom_list_tile.dart';

class PptFileTab extends StatefulWidget {
  final String trailing;

  PptFileTab({
    super.key,
    this.trailing = 'assets/icons/three_dots_icon.png',
  });

  @override
  State<PptFileTab> createState() => PptFileTabState();
}

class PptFileTabState extends State<PptFileTab> with WidgetsBindingObserver{
  List<Data> _snapshot = [];
  @override
  void initState() {
    super.initState();
    _snapshot = Read.PptFiles;
    WidgetsBinding.instance.addObserver(this);
  }

  void sort(){
    setState(() {
      _snapshot = Read.PptFiles;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
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
                            _snapshot = Read.PptFiles;
                          });
                        },
                        onDeleted: (status,data) {
                          if (status)
                            setState(() {
                              Read.updateFilesDeletion(data);
                              _snapshot = Read.AllFiles;
                            });
                        });
                  },
                  onTap: () {
                    // Navigator.push(context,MaterialPageRoute(builder: (context)=>FileViewer(filePath: snapshot.data![index].filePath,)));
                    fileViewHandler(context, _snapshot[index],onDelete: (status,data){if(status){Read.updateFilesDeletion(data);refresh();}},onRenamed:(oldData,newData){Read.updateFilesRename(oldData, newData);refresh();} );
                  },
                );
              })),
    );
  }

  refresh(){
    setState(() {
      _snapshot = Read.PptFiles;
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
