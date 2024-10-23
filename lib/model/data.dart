

import 'dart:io';

class Data{
  File file;
  String details;
  String fileType;
  String filePath;
  String fileName;

  Data({required this.file,
    required this.fileName,
    required this.fileType,
    required this.details,
    required this.filePath,
  });


 // factory Data(File file,String fileName, String  fileType,String  details,String filePath)=> Data._(file: file,fileName: fileName,details: details,filePath: filePath,fileType: fileType);

}