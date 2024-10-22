import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/all_file_tab.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/doc_file_tab.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/excel_file_tab.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/pdf_file_tab.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/ppt_file_tab.dart';
import 'package:pdf_reader/utilities/color.dart';

class AllFilesScreens extends StatefulWidget{
  AllFilesScreens._();
  factory AllFilesScreens(){
    return AllFilesScreens._();
  }
  @override
  State<StatefulWidget> createState() => _AllFilesStates();
}

class _AllFilesStates extends State<AllFilesScreens> {
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
                AllFileTab(),
                PdfFileTab(),
                DocFileTab(),
                ExcelFileTab(),
                PptFileTab()
              ]))
            ],
          )),
        ),
      ),
    );
  }
}