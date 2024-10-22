import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/color.dart';

import '../tab/all_file_tab.dart';
import '../tab/doc_file_tab.dart';
import '../tab/excel_file_tab.dart';
import '../tab/pdf_file_tab.dart';
import '../tab/ppt_file_tab.dart';

class BookmarkScreen extends StatefulWidget {
  BookmarkScreen._();
  factory BookmarkScreen(){
    return BookmarkScreen._();
  }
  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
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
                AllFileTab(
                  trailing: 'assets/icons/bookmark_filled.png',
                ),
                PdfFileTab(
                  trailing: 'assets/icons/bookmark_filled.png',
                ),
                DocFileTab(
                  trailing: 'assets/icons/bookmark_filled.png',
                ),
                ExcelFileTab(
                  trailing: 'assets/icons/bookmark_filled.png',
                ),
                PptFileTab(
                  trailing: 'assets/icons/bookmark_filled.png',
                )
              ]))
            ],
          )),
        ),
      ),
    );
  }
}
