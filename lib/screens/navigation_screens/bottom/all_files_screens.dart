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

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: SafeArea(
          child: DefaultTabController(
              length: 5,child: Column(
            children: [
              TabBar(
                labelStyle: Theme.of(context).textTheme.titleSmall,
                tabs: const <Tab>[
                Tab(text: 'ALL',),
                Tab(text: 'PDF'),
                Tab(text: 'DOC'),
                Tab(text: 'EXCEL'),
                Tab(text: 'PPT'),
              ],indicatorColor: ColorTheme.RED,),
              Expanded(child: TabBarView(children: [
                AllFileTab(screenType: ScreenType.ALL_FILES,),
                PdfFileTab(screenType: ScreenType.ALL_FILES,),
                DocFileTab(screenType: ScreenType.ALL_FILES,),
                ExcelFileTab(screenType: ScreenType.ALL_FILES,),
                PptFileTab(screenType: ScreenType.ALL_FILES,)
              ]))
            ],
          )),
        ),
      ),
    );
  }
}