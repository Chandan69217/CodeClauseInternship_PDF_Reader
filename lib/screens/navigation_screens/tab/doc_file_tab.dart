import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/screen_type.dart';
import 'package:pdf_reader/widgets/confirm_bottomsheet.dart';
import 'package:pdf_reader/widgets/custom_bottomsheet.dart';
import '../../../external_storage/database_helper.dart';
import '../../../external_storage/read_storage.dart';
import '../../../model/data.dart';
import '../../../widgets/custom_listview_widget.dart';

class DocFileTab extends StatefulWidget {
  final String trailing;
  final ScreenType screenType;

  DocFileTab({
    Key? key,
    this.trailing = 'assets/icons/three_dots_icon.png',
    required this.screenType
  }):super(key: key);

  @override
  State<DocFileTab> createState() => DocFileTabState();
}

class DocFileTabState extends State<DocFileTab> with WidgetsBindingObserver{
  List<Data> _snapshot = [];
  final _extension = {'doc','docx'};
  @override
  void initState() {
    super.initState();
   _handleFileData(widget.screenType);
    WidgetsBinding.instance.addObserver(this);
  }


  _handleFileData(ScreenType screenType){
    switch(screenType){
      case ScreenType.ALL_FILES : _snapshot = _getDoc();
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
          child: CustomListView(
            snapshot: _snapshot,
            screenType: widget.screenType,
            refresh: refresh,
          )
      ),
    );
  }

  void refresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _handleFileData(widget.screenType);
      });
    });
  }

  List<Data> _getDoc() {
    return Read.AllFiles.where((data) =>_extension.contains(data.fileType)).toList();
  }

  List<Data> _getBookmark() {
    return Read.AllFiles.where((data) => data.isBookmarked && _extension.contains(data.fileType)).toList();
  }

  List<Data> _getHistory() {
    return Read.AllFiles.where((data) => data.isHistory && _extension.contains(data.fileType)).toList();
  }

  _bookmarkOptionBtn(Data data,int index)async{
    if(await showConfirmWidget(home_context: context, data: data, label: 'Remove')){
      var database = await DatabaseHelper.getInstance();
      var isBookmarked = await database.deleteFrom(table_name: DatabaseHelper.BOOKMARK_TABLE_NAME, filePath: _snapshot[index].filePath);
      if(isBookmarked){
        if(await Read.updateFiles(data,typeOfUpdate: TypeOfUpdate.BOOKMARK)){
          refresh();
        }
      }
    }
  }

  _threeDotOptionBtn(Data item){
    customBottomSheet(
        home_context: context,
        data:item,
        onChanged: (status,{Data? newData}) {
          if(status){
            refresh();
          }
        },
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  
}
