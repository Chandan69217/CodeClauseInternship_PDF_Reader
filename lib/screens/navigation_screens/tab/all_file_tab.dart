import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/file_view_handler.dart';
import 'package:pdf_reader/utilities/screen_type.dart';
import 'package:pdf_reader/widgets/confirm_bottomsheet.dart';
import 'package:pdf_reader/widgets/custom_bottomsheet.dart';
import 'package:pdf_reader/widgets/custom_list_tile.dart';
import '../../../external_storage/database_helper.dart';
import '../../../external_storage/read_storage.dart';
import '../../../model/data.dart';

class AllFileTab extends StatefulWidget {
  final String trailing;
  final ScreenType screenType;
  AllFileTab({
    Key? key,
    this.trailing = 'assets/icons/three_dots_icon.png',
    required this.screenType
  }):super(key: key);

  @override
  State<StatefulWidget> createState() => AllFilesTabStates();
}

class AllFilesTabStates extends State<AllFileTab> with WidgetsBindingObserver{
  List<Data> _snapshot = [];
  @override
  void initState() {
    super.initState();
   _handleFileData(widget.screenType);
    WidgetsBinding.instance.addObserver(this);
  }


  _handleFileData(ScreenType screenType){
    switch(screenType){
      case ScreenType.ALL_FILES : _snapshot = Read.AllFiles;
      break;
      case ScreenType.HISTORY :  _snapshot = _getHistory();
      break;
      case ScreenType.BOOKMARKS: _snapshot = _getBookmark();
      break;
      default : _snapshot = [];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView.builder(
              itemCount: _snapshot.length,
              itemBuilder: (context, index) {
                final item = _snapshot[index];
                return CustomListTile(
                  title: item.fileName,
                  subTitle: item.details,
                  trailing: widget.trailing,
                  onOptionClick: () {
                    if(widget.screenType == ScreenType.BOOKMARKS){
                      _bookmarkOptionBtn(item,index);
                    }else{
                      _threeDotOptionBtn(item);
                    }
                  },
                  onTap: () {
                    fileViewHandler(context, item,onDelete: (status,data){if(status){Read.removeFiles(data);refresh();}},onRenamed:(oldData,newData){Read.updateFiles(oldData, newData);refresh();} );
                  },
                );
              })
      ),
    );
  }

  _bookmarkOptionBtn(Data data,int index)async{
    if(await showConfirmWidget(home_context: context, data: data, message: 'Remove')){
      var database = await DatabaseHelper.getInstance();
      var isBookmarked = await database.deleteFrom(table_name: DatabaseHelper.BOOKMARK_TABLE_NAME, filePath: _snapshot[index].filePath);
      if(isBookmarked){
        var oldData = data;
        data.isBookmarked = false;
        Read.updateFiles(oldData,data);
        refresh();
      }
    }
  }

  _threeDotOptionBtn(Data item){
    customBottomSheet(
        home_context: context,
        data:item,
        onRenamed: (oldData,newData) {
          Read.updateFiles(oldData, newData);
          refresh();
        },
        onDeleted: (status,data) {
          if (status) {
            Read.removeFiles(data);
            refresh();
          }
        });
  }

  List<Data> _getBookmark() {
    return Read.AllFiles.where((data) => data.isBookmarked).toList();
  }

  void refresh(){
    setState(() {
      _handleFileData(widget.screenType);
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  List<Data> _getHistory() {
    return Read.AllFiles.where((data) => data.isHistory).toList();
  }
}
