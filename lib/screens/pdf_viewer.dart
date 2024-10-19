



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sizing/sizing.dart';

import '../utilities/color.dart';

class PdfViewer extends StatefulWidget{
  String filePath;
  PdfViewer({super.key, required this.filePath});

  @override
  State<StatefulWidget> createState() => _PdfViewerStates();

}


class _PdfViewerStates extends State<PdfViewer>{
  PdfControllerPinch? controllerPinch ;
  int _totalPage = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    controllerPinch = PdfControllerPinch(document: PdfDocument.openFile(widget.filePath),);
  }
  @override
  Widget build(BuildContext context) {
    String title = widget.filePath.split('/').last;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        bottom: PreferredSize(preferredSize: Size(35.ss, 35.ss), child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.ss),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Total Pages: $_totalPage',style: Theme.of(context).textTheme.bodySmall,),
              IconButton(onPressed: (){
                controllerPinch!.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.linear);
              }, icon: Icon(Icons.arrow_back_ios,size: 18.ss,)),
              Text('Current Page: $_currentPage',style: Theme.of(context).textTheme.bodySmall,),
              IconButton(onPressed: (){
                controllerPinch!.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.linear);
              }, icon: Icon(Icons.arrow_forward_ios_rounded,size: 18.ss,)),
            ],
          ),
        )),
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (context){
            return <PopupMenuItem>[
              PopupMenuItem(child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(flex:6 ,child: Text('Rename',style: Theme.of(context).textTheme.bodyMedium,)),
                  Expanded(flex: 1,child: Icon(Icons.drive_file_rename_outline_sharp))
                ],
              ),),

              PopupMenuItem(child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(flex:6 ,child: Text('Share',style: Theme.of(context).textTheme.bodyMedium,)),
                  Expanded(flex: 1,child: Icon(Icons.share))
                ],
              ),),

              PopupMenuItem(child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(flex:6 ,child: Text('Delete',style: Theme.of(context).textTheme.bodyMedium,)),
                  Expanded(flex: 1,child: Icon(Icons.delete))
                ],
              ),)
            ];
          },
            icon: Image.asset('assets/icons/three_dots_icon.png',width: 20.ss,height: 20.ss,),
            color: ColorTheme.WHITE,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.ss)),
          ),
        ],
      ),
      body: SafeArea(
          child: Expanded(
            child: PdfViewPinch(
              controller: controllerPinch!,
              onDocumentLoaded: (pdfDocument){
                setState(() {
                  _totalPage = pdfDocument.pagesCount;
                  _currentPage = controllerPinch!.page;
                });
              },
              onPageChanged: (pageNo){
                setState(() {
                  _currentPage = pageNo;
                });
              },
            ),
          )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controllerPinch!.dispose();
  }

}