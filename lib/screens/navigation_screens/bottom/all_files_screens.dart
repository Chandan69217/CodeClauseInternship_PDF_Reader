import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/all_file_tab.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/doc_file_tab.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/excel_file_tab.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/pdf_file_tab.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/ppt_file_tab.dart';
import 'package:pdf_reader/utilities/color.dart';

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

  void handleSortEvent(){
    _allFileTabKey.currentState?.sort();
    _pdfFileTabKey.currentState?.sort();
    _docFileTabKey.currentState?.sort();
    _xlsFileTabKey.currentState?.sort();
    _pptFileTabKey.currentState?.sort();
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
                tabs: <Tab>[
                Tab(text: 'ALL',),
                Tab(text: 'PDF'),
                Tab(text: 'DOC'),
                Tab(text: 'EXCEL'),
                Tab(text: 'PPT'),
              ],indicatorColor: ColorTheme.RED,),
              Expanded(child: TabBarView(children: [
                AllFileTab(key:_allFileTabKey,),
                PdfFileTab(key: _pdfFileTabKey,),
                DocFileTab(key: _docFileTabKey,),
                ExcelFileTab(key: _xlsFileTabKey,),
                PptFileTab(key: _pptFileTabKey,)
              ]))
            ],
          )),
        ),
      ),
    );
  }
}