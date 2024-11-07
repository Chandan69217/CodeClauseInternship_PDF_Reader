

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/callbacks.dart';

import '../screens/pdf_viewer.dart';

void fileViewHandler(BuildContext context,Data data,{OnRenamed? onRenamed,OnDeleted? onDelete}){
  if(data.fileType == 'pdf'){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>PdfViewer(data:data,onRenamed: onRenamed,onDeleted: onDelete,)));
  }else {
    OpenFile.open(data.filePath);
  }
}