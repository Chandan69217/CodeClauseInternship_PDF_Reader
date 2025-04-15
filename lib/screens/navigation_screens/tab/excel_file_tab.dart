import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/screen_type.dart';
import 'package:pdf_reader/widgets/custom_bottomsheets/confirm_bottomsheet.dart';
import 'package:pdf_reader/widgets/custom_bottomsheets/custom_bottomsheet.dart';
import 'package:pdf_reader/widgets/custom_listview/custom_listview_widget.dart';
import 'package:provider/provider.dart';
import '../../../external_storage/database_helper.dart';
import '../../../external_storage/read_storage.dart';



class ExcelFileTab extends StatefulWidget {
  final String trailing;
  final ScreenType screenType;

  ExcelFileTab({
    Key? key,
    this.trailing = 'assets/icons/three_dots_icon.png',
    required this.screenType
  }):super(key: key);

  @override
  State<ExcelFileTab> createState() => ExcelFileTabState();
}

class ExcelFileTabState extends State<ExcelFileTab> with WidgetsBindingObserver{
  final _extension = {'xls','xlsx'};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }


  List<Data> _handleFileData(ScreenType screenType,List<Data> allFiles){
    switch(screenType){
      case ScreenType.ALL_FILES : return _getXls(allFiles);
      case ScreenType.HISTORY :   return _getHistory(allFiles);
      case ScreenType.BOOKMARKS:  return _getBookmark(allFiles);
      default : return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Consumer<Read>(
              builder: (context,value,child){
                return CustomListView(
                  snapshot: _handleFileData(widget.screenType, value.AllFiles),
                  screenType: widget.screenType,
                );
              }
          )
      ),
    );
  }


  // _bookmarkOptionBtn(Data data,int index)async{
  //   if(await showConfirmWidget(home_context: context, data: data, label: 'Remove')){
  //     var database = await DatabaseHelper.getInstance();
  //     var isBookmarked = await database.deleteFrom(table_name: DatabaseHelper.BOOKMARK_TABLE_NAME, filePath: _snapshot[index].filePath);
  //     if(isBookmarked){
  //       if(await Read.instance.updateFiles(data,typeOfUpdate: TypeOfUpdate.BOOKMARK)){
  //         refresh();
  //       }
  //     }
  //   }
  // }

  _threeDotOptionBtn(Data item){
    customBottomSheet(
        home_context: context,
        data:item,
    );
  }

  List<Data> _getXls(List<Data> allFiles){
    return allFiles.where((data) => _extension.contains(data.fileType)).toList();
  }

  List<Data> _getBookmark(List<Data> allFiles) {
    return allFiles.where((data) => data.isBookmarked && _extension.contains(data.fileType)).toList();
  }

  List<Data> _getHistory(List<Data> allFiles) {
    return allFiles.where((data) => data.isHistory && _extension.contains(data.fileType)).toList();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }


}
