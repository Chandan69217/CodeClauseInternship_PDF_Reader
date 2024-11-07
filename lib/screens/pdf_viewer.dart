// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/screens/navigation_screens/bottom/all_files_screens.dart';
import 'package:pdf_reader/screens/navigation_screens/tab/all_file_tab.dart';
import 'package:pdf_reader/utilities/callbacks.dart';
import 'package:pdf_reader/widgets/show_delete_widget.dart';
import 'package:pdf_reader/widgets/show_file_details_widget.dart';
import 'package:pdf_reader/widgets/show_rename_widget.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizing/sizing.dart';

import '../utilities/color.dart';

class PdfViewer extends StatefulWidget {
  Data data;
  OnRenamed? onRenamed;
  OnDeleted? onDeleted;
  final GlobalKey<AllFilesTabStates> _allFilesKey = GlobalKey();
  PdfViewer({
    this.onRenamed,
    this.onDeleted,
    required this.data,
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
    String title = widget.data.filePath.split('/').last;
    return Scaffold(
      appBar: AppBar(
          title: Text(title),
          bottom: PreferredSize(
              preferredSize: Size(35.ss, 35.ss),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.ss),
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
                          size: 18.ss,
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
                          size: 18.ss,
                        )),
                  ],
                ),
              )),
          actions: _actionsButton()),
      body: SafeArea(
          child: Expanded(
        child: PdfViewPinch(
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
        ),
      )),
    );
  }

  List<Widget> _actionsButton() {
    return <Widget>[
      PopupMenuButton(
        menuPadding: EdgeInsets.all(5.ss),
        onSelected: (value) => _onSelected(value, widget.data),
        style: ButtonStyle(
          overlayColor: WidgetStatePropertyAll(ColorTheme.PRIMARY),
        ),
        itemBuilder: (context) {
          return <PopupMenuItem>[
            PopupMenuItem(
              child: _popupMenuItemUI(
                  title: 'Rename',
                  icon: Icons.drive_file_rename_outline_rounded),
              value: 1,
            ),
            PopupMenuItem(
              child: _popupMenuItemUI(title: 'Share', icon: Icons.share),
              value: 2,
            ),
            PopupMenuItem(
              child:
                  _popupMenuItemUI(title: 'Delete', icon: Icons.delete_rounded),
              value: 3,
            ),
            PopupMenuItem(
              child: _popupMenuItemUI(
                  title: 'Details', icon: Icons.info_outline_rounded),
              value: 4,
            )
          ];
        },
        icon: Image.asset(
          'assets/icons/three_dots_icon.png',
          width: 20.ss,
          height: 20.ss,
        ),
        color: ColorTheme.WHITE,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.ss)),
      ),
      SizedBox(
        width: 10.ss,
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
          width: 5.ss,
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
            onRenamed: (oldData, newData) {
              widget.onRenamed!(oldData,newData);
              _refresh(newData);
            });
        break;
      case 2:
        Share.shareXFiles([XFile(data.filePath)]);
        break;
      case 3:
        showDeleteWidget(context, data, (status,data){
          if(status){
            widget.onDeleted!(status,data);
            Navigator.pop(context);
          }
        });
        break;
      case 4:
        showFileDetails(home_context: context, data: data);
        break;
    }
  }
  _refresh(Data newData){
    setState(() {
      widget.data = newData;
    });
  }
}
