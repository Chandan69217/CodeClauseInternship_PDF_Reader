

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf_reader/model/data.dart';

import '../screens/pdf_viewer.dart';

void fileViewHandler(BuildContext context,Data data){
  if(data.fileType == 'pdf'){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>PdfViewer(filePath:data.filePath)));
  }else {
    OpenFile.open(data.filePath);
  }
}