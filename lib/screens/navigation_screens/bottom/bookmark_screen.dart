import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/utilities/screen_type.dart';
import '../tab/all_file_tab.dart';
import '../tab/doc_file_tab.dart';
import '../tab/excel_file_tab.dart';
import '../tab/pdf_file_tab.dart';
import '../tab/ppt_file_tab.dart';

class BookmarkScreen extends StatefulWidget {
  BookmarkScreen._({Key? key}):super(key: key);
  factory BookmarkScreen({Key? key}){
    return BookmarkScreen._(key: key,);
  }
  @override
  State<BookmarkScreen> createState() => BookmarkScreenState();
}

class BookmarkScreenState extends State<BookmarkScreen> {


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
                  screenType: ScreenType.BOOKMARKS,
                  trailing: 'assets/icons/bookmark_filled.png',
                ),
                PdfFileTab(
                  screenType: ScreenType.BOOKMARKS,
                  trailing: 'assets/icons/bookmark_filled.png',
                ),
                DocFileTab(
                  screenType: ScreenType.BOOKMARKS,
                  trailing: 'assets/icons/bookmark_filled.png',
                ),
                ExcelFileTab(
                  screenType: ScreenType.BOOKMARKS,
                  trailing: 'assets/icons/bookmark_filled.png',
                ),
                PptFileTab(
                  screenType: ScreenType.BOOKMARKS,
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
