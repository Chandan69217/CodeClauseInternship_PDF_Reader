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
  static GlobalKey<AllFilesTabStates> _allFileTabKey = GlobalKey();
  static GlobalKey<PdfFileTabState> _pdfFileTabKey = GlobalKey();
  static GlobalKey<DocFileTabState> _docFileTabKey = GlobalKey();
  static GlobalKey<ExcelFileTabState> _xlsFileTabKey = GlobalKey();
  static GlobalKey<PptFileTabState> _pptFileTabKey = GlobalKey();

  void handleSortEvent(){
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
                  key: _allFileTabKey,
                  screenType: ScreenType.BOOKMARKS,
                  trailing: 'assets/icons/bookmark_filled.png',
                ),
                PdfFileTab(
                  key: _pdfFileTabKey,
                  screenType: ScreenType.BOOKMARKS,
                  trailing: 'assets/icons/bookmark_filled.png',
                ),
                DocFileTab(
                  key: _docFileTabKey,
                  screenType: ScreenType.BOOKMARKS,
                  trailing: 'assets/icons/bookmark_filled.png',
                ),
                ExcelFileTab(
                  key: _xlsFileTabKey,
                  screenType: ScreenType.BOOKMARKS,
                  trailing: 'assets/icons/bookmark_filled.png',
                ),
                PptFileTab(
                  key: _pptFileTabKey,
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
