

import 'dart:io';

class Data{
  File file;
  String details;
  String fileType;
  String filePath;
  String fileName;
  String fileSize;
  String date;

  Data({required this.file,
    required this.fileName,
    required this.fileType,
    required this.details,
    required this.filePath,
    required this.fileSize,
    required this.date
  });


 // factory Data(File file,String fileName, String  fileType,String  details,String filePath)=> Data._(file: file,fileName: fileName,details: details,filePath: filePath,fileType: fileType);

}