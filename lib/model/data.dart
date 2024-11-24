

import 'dart:io';

class Data{
  File file;
  String details;
  String fileType;
  String filePath;
  String fileName;
  String fileSize;
  String date;
  int bytes;
  bool isBookmarked;
  bool isHistory;

  Data({required this.file,
    required this.fileName,
    required this.fileType,
    required this.details,
    required this.filePath,
    required this.fileSize,
    required this.date,
    required this.bytes,
    this.isBookmarked = false,
    this.isHistory = false
  });

}