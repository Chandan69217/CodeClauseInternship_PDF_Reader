import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/screen_type.dart';
import 'package:pdf_reader/widgets/confirm_bottomsheet.dart';
import '../../../external_storage/database_helper.dart';
import '../../../external_storage/read_storage.dart';
import '../../../widgets/custom_bottomsheet.dart';
import '../../../widgets/custom_listview_widget.dart';

class PptFileTab extends StatefulWidget {
  final String trailing;
  final ScreenType screenType;

  PptFileTab({
    super.key,
    this.trailing = 'assets/icons/three_dots_icon.png',
    required this.screenType
  });

  @override
  State<PptFileTab> createState() => PptFileTabState();
}

class PptFileTabState extends State<PptFileTab> with WidgetsBindingObserver{
  List<Data> _snapshot = [];
  final _extension = {'ppt','pptx'};
  @override
  void initState() {
    super.initState();
    _handleFileData(widget.screenType);
    WidgetsBinding.instance.addObserver(this);
  }


  _handleFileData(ScreenType screenType){
    switch(screenType){
      case ScreenType.ALL_FILES : _snapshot = _getPpt();
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
        });
  }
  void refresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _handleFileData(widget.screenType);
      });
    });
  }


  List<Data> _getPpt(){
    return Read.AllFiles.where((data)=> _extension.contains(data.fileType)).toList();
  }

  List<Data> _getBookmark() {
    return Read.AllFiles.where((data) => data.isBookmarked && _extension.contains(data.fileType) ).toList();
  }

  List<Data> _getHistory() {
    return Read.AllFiles.where((data) => data.isHistory && _extension.contains(data.fileType)).toList();
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  
}
