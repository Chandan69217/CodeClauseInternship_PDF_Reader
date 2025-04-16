// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:pdf_reader/external_storage/database_helper.dart';
import 'package:pdf_reader/external_storage/read_storage.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/widgets/custom_bottomsheets/show_delete_widget.dart';
import 'package:pdf_reader/widgets/custom_bottomsheets/show_file_details_widget.dart';
import 'package:pdf_reader/widgets/custom_bottomsheets/show_rename_widget.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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
  PdfControllerPinch? controllerPinch;
  int _totalPage = 0;
  int _currentPage = 0;


  @override
  void initState() {
    super.initState();
    controllerPinch = PdfControllerPinch(
      document: PdfDocument.openFile(widget.data.filePath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
          child: Expanded(
        child: Consumer<Read>(
            builder: (context,value,child){
              return PdfViewPinch(
                controller: controllerPinch!,
                onDocumentLoaded: (pdfDocument) {
                  setState(() {
                    _totalPage = pdfDocument.pagesCount;
                    _currentPage = controllerPinch!.page;
                  });
                },
                onPageChanged: (pageNo) {
                  setState(() {
                    _currentPage = pageNo;
                  });
                },
              );
            }
        )
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
    controllerPinch!.dispose();
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
             padding: EdgeInsets.symmetric(horizontal: 10),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Text(
                   'Total Pages: $_totalPage',
                   style: Theme.of(context).textTheme.bodySmall,
                 ),
                 IconButton(
                     onPressed: () {
                       controllerPinch!.previousPage(
                           duration: const Duration(milliseconds: 500),
                           curve: Curves.linear);
                     },
                     icon: Icon(
                       Icons.arrow_back_ios,
                       size: 18,
                     )),
                 Text(
                   'Current Page: $_currentPage',
                   style: Theme.of(context).textTheme.bodySmall,
                 ),
                 IconButton(
                     onPressed: () {
                       controllerPinch!.nextPage(
                           duration: const Duration(milliseconds: 500),
                           curve: Curves.linear);
                     },
                     icon: Icon(
                       Icons.arrow_forward_ios_rounded,
                       size: 18,
                     )),
               ],
             ),
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
