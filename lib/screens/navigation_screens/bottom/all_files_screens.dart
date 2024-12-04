import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/all_file_tab.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/doc_file_tab.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/excel_file_tab.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/pdf_file_tab.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/ppt_file_tab.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/utilities/screen_type.dart';

class AllFilesScreens extends StatefulWidget{
  AllFilesScreens._({Key? key}):super(key: key);
  factory AllFilesScreens({Key? key}){
    return AllFilesScreens._(key: key,);
  }
  @override
  State<StatefulWidget> createState() => AllFilesStates();
}

class AllFilesStates extends State<AllFilesScreens>{
  static GlobalKey<AllFilesTabStates> _allFileTabKey = GlobalKey();
  static GlobalKey<PdfFileTabState> _pdfFileTabKey = GlobalKey();
  static GlobalKey<DocFileTabState> _docFileTabKey = GlobalKey();
  static GlobalKey<ExcelFileTabState> _xlsFileTabKey = GlobalKey();
  static GlobalKey<PptFileTabState> _pptFileTabKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  void refreshAllFiles(){
    _allFileTabKey.currentState?.refresh();
    _pdfFileTabKey.currentState?.refresh();
    _docFileTabKey.currentState?.refresh();
    _xlsFileTabKey.currentState?.refresh();
    _pptFileTabKey.currentState?.refresh();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: SafeArea(
          child: DefaultTabController(length: 5,child: Column(
            children: [
              TabBar(labelStyle: Theme.of(context).textTheme.titleSmall,
                tabs: const <Tab>[
                Tab(text: 'ALL',),
                Tab(text: 'PDF'),
                Tab(text: 'DOC'),
                Tab(text: 'EXCEL'),
                Tab(text: 'PPT'),
              ],indicatorColor: ColorTheme.RED,),
              Expanded(child: TabBarView(children: [
                AllFileTab(key:_allFileTabKey,screenType: ScreenType.ALL_FILES,),
                PdfFileTab(key: _pdfFileTabKey,screenType: ScreenType.ALL_FILES,),
                DocFileTab(key: _docFileTabKey,screenType: ScreenType.ALL_FILES,),
                ExcelFileTab(key: _xlsFileTabKey,screenType: ScreenType.ALL_FILES,),
                PptFileTab(key: _pptFileTabKey,screenType: ScreenType.ALL_FILES,)
              ]))
            ],
          )),
        ),
      ),
    );
  }
}