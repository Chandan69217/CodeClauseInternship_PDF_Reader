import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf_reader/external_storage/database_helper.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/callbacks.dart';

import '../external_storage/read_storage.dart';
import '../screens/pdf_viewer.dart';


void fileViewHandler(BuildContext context,Data data,)async{
  _addToHistory(data);
  if(data.fileType.toLowerCase() == 'pdf'){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>PdfViewer(data:data,)));
  }else {
    OpenFile.open(data.filePath);
  }
}

Future<bool> _addToHistory(Data data)async {
  var database = await DatabaseHelper.getInstance();
  if(!data.isHistory){
    Read.instance.updateFiles(data,typeOfUpdate: TypeOfUpdate.HISTORY);
    return await database.insertInto(table_name: DatabaseHelper.HISTORY_TABLE_NAME, filePath: data.filePath);
  }
  return false;
}