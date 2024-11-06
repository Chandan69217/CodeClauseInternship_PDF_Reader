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
    _snapshot = Read.DocFiles;
    WidgetsBinding.instance.addObserver(this);
  }

  void sort(){
    setState(() {
      _snapshot = Read.AllFiles;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state ==  AppLifecycleState.resumed){
      setState(() {
        _snapshot = Read.DocFiles;
      });
    }
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
                            _snapshot = Read.DocFiles;
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
                    fileViewHandler(context, _snapshot[index]);
                  },
                );
              })
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
