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
  final _extension = {'ppt','pptx'};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }


 List<Data> _handleFileData(ScreenType screenType,List<Data> allFiles){
    switch(screenType){
      case ScreenType.ALL_FILES : return _getPpt(allFiles);
      case ScreenType.HISTORY :  return _getHistory(allFiles);
      case ScreenType.BOOKMARKS: return _getBookmark(allFiles);
      default : return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Consumer<Read>(
              builder:(context,value,child){
                return CustomListView(
                  snapshot: _handleFileData(widget.screenType, value.AllFiles),
                  screenType: widget.screenType,
                );
              }
          )
      ),
    );
  }



  List<Data> _getPpt(List<Data> allFiles){
    return allFiles.where((data)=> _extension.contains(data.fileType)).toList();
  }

  List<Data> _getBookmark(List<Data> allFiles) {
    return allFiles.where((data) => data.isBookmarked && _extension.contains(data.fileType) ).toList();
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
