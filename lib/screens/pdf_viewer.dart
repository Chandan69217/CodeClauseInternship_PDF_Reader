// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf_reader/external_storage/database_helper.dart';
import 'package:pdf_reader/external_storage/read_storage.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/widgets/custom_bottomsheets/show_delete_widget.dart';
import 'package:pdf_reader/widgets/custom_bottomsheets/show_file_details_widget.dart';
import 'package:pdf_reader/widgets/custom_bottomsheets/show_rename_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../utilities/color_theme.dart';



class PdfViewer extends StatefulWidget {
  Data data;
  final bool? isSharedIntent;
  PdfViewer({super.key,
    required this.data,
    this.isSharedIntent = false
  });

  @override
  State<StatefulWidget> createState() => _PdfViewerStates();
}

class _PdfViewerStates extends State<PdfViewer> {

  TextEditingController _searchController = TextEditingController();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  PdfTextSearchResult _searchResult = PdfTextSearchResult();


  @override
  void initState() {
    super.initState();
  }


  void _search(String query) {
    _searchResult = _pdfViewerController.searchText(query);
    _searchResult.addListener(() {
      setState(() {
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
          child: Consumer<Read>(
              builder: (context,value,child){
                return SfPdfViewer.file(widget.data.file,
                  currentSearchTextHighlightColor: Colors.blue.withValues(alpha: 0.3),
                  controller: _pdfViewerController,
                  otherSearchTextHighlightColor: Colors.yellow.withValues(alpha: 0.4),
                );
              }
          )),
    );
  }

  List<Widget> _actionsButton() {
    return <Widget>[
      IconButton(onPressed: !widget.data.isBookmarked ? _addToBookmark : _removeFromBookmark,
          icon: Icon(widget.data.isBookmarked?Icons.star:Icons.star_border)),
      PopupMenuButton(
        menuPadding: EdgeInsets.all(5),
        onSelected: (value) => _onSelected(value, widget.data),
        itemBuilder: (context) {
          return <PopupMenuItem>[
            PopupMenuItem(
              value: 1,
              child: _popupMenuItemUI(
                  title: 'Rename',
                  icon: Icons.drive_file_rename_outline_rounded,
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: _popupMenuItemUI(title: 'Share', icon: Icons.share),
            ),
            PopupMenuItem(
              value: 3,
              child:
                  _popupMenuItemUI(title: 'Delete', icon: Icons.delete_rounded),
            ),
            PopupMenuItem(
              value: 4,
              child: _popupMenuItemUI(
                  title: 'Details', icon: Icons.info_outline_rounded),
            )
          ];
        },
        icon: Image.asset(
          'assets/icons/three_dots_icon.webp',
          width: 20,
          height: 20,
          color: Theme.of(context).brightness == Brightness.dark? ColorTheme.WHITE:null,
        ),
      ),
      SizedBox(
        width: 10,
      ),
    ];
  }

  Widget _popupMenuItemUI({required String title, required IconData icon}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          flex: 1,
          child: Icon(
            icon,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pdfViewerController.dispose();
    _searchResult.removeListener((){});
  }

  void _onSelected(int value, Data data) {
    switch (value) {
      case 1:
        showRenameWidget(
            home_context: context,
            data: data,
          onChanged: (status, {newData}){
              if(status){
                setState(() {
                  widget.data = newData!;
                });
              }
          },
        );
        break;
      case 2:
        Share.shareXFiles([XFile(data.filePath)]);
        break;
      case 3:
        showDeleteWidget(context, data,onDeleted: (status, {newData}){
          if(status){
            Navigator.of(context).pop();
          }
        },);
        break;
      case 4:
        showFileDetails(home_context: context, data: data);
        break;
    }
  }

  AppBar _appBar() {
   return AppBar(
       title: Text(widget.data.fileName),
       bottom: PreferredSize(
           preferredSize: Size(35, 35),
           child: Padding(
             padding: EdgeInsets.symmetric(horizontal: 12.0),
             child: Row(
         children: [
         Expanded(
         child: TextField(
         controller: _searchController,
         decoration: InputDecoration(
             hintText: 'Search text...',
           suffixIcon: _searchController.text.isNotEmpty?IconButton(onPressed: (){
             _searchResult.clear();
             setState(() {
               _searchController.text = '';
             });
           }, icon: Icon(Icons.close)):null,
           focusedBorder: InputBorder.none
         ),
         onChanged: (value){
           _search(value);
         },
       ),
   ),
           if(_searchResult.hasResult)
           Text('Matches: ${_searchResult.totalInstanceCount}'),
           IconButton(
             icon: Icon(Icons.arrow_upward),
             onPressed: _searchResult.hasResult ? _searchResult.previousInstance : null,
           ),
           IconButton(
             icon: Icon(Icons.arrow_downward),
             onPressed: _searchResult.hasResult ? _searchResult.nextInstance : null,
           ),
         ],
    )

    )),
       actions: widget.isSharedIntent! ?null:_actionsButton());
  }


  _addToBookmark() async {
    var database = await DatabaseHelper.getInstance();
    var isBookmarked = await database.insertInto(table_name: DatabaseHelper.BOOKMARK_TABLE_NAME, filePath: widget.data.filePath);
    if(isBookmarked) {
      setState(() {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: Text('Add to Bookmark'),)));
        Read.instance.updateFiles(widget.data,typeOfUpdate: TypeOfUpdate.BOOKMARK);
      });
    }
  }
  _removeFromBookmark() async {
    var database = await DatabaseHelper.getInstance();
    var isBookmarked = await database.deleteFrom(table_name: DatabaseHelper.BOOKMARK_TABLE_NAME, filePath: widget.data.filePath);
    if(isBookmarked) {
      setState(() {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: Text('Remove from Bookmark'),)));
        Read.instance.updateFiles(widget.data,typeOfUpdate: TypeOfUpdate.BOOKMARK);
      });
    }
  }
}
