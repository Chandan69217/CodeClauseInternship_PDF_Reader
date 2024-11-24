

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf_reader/external_storage/database_helper.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/callbacks.dart';

import '../external_storage/read_storage.dart';
import '../screens/pdf_viewer.dart';

void fileViewHandler(BuildContext context,Data data,{OnRenamed? onRenamed,OnDeleted? onDelete}){
  _addToHistory(data);
  if(data.fileType == 'pdf'){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>PdfViewer(data:data,onRenamed: onRenamed,onDeleted: onDelete,)));
  }else {
    OpenFile.open(data.filePath);
  }
}

Future<void> _addToHistory(Data data)async {
  var database = await DatabaseHelper.getInstance();
  if(!data.isHistory){
    var oldData = data;
    data.isHistory = true;
    Read.updateFiles(oldData, data);
    database.insertInto(table_name: DatabaseHelper.HISTORY_TABLE_NAME, filePath: data.filePath);
  }
}