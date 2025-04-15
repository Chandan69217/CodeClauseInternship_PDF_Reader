

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/utilities/screen_type.dart';

import '../tab/all_file_tab.dart';
import '../tab/doc_file_tab.dart';
import '../tab/excel_file_tab.dart';
import '../tab/pdf_file_tab.dart';
import '../tab/ppt_file_tab.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen._({Key? key}):super(key: key);
  factory HistoryScreen({Key? key}){
    return HistoryScreen._(key: key,);
  }

  @override
  State<HistoryScreen> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: SafeArea(
          child: DefaultTabController(length: 5, child: Column(
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
                AllFileTab(screenType: ScreenType.HISTORY,),
                PdfFileTab(screenType: ScreenType.HISTORY,),
                DocFileTab(screenType: ScreenType.HISTORY,),
                ExcelFileTab(screenType: ScreenType.HISTORY,),
                PptFileTab(screenType: ScreenType.HISTORY,)
              ]))
            ],
          )),
        ),
      ),
    );
  }
}
