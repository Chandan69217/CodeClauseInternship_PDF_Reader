import 'dart:io';

import 'package:intl/intl.dart';

class FileDetails {
  static late DateTime _dateTime;
  static late int _bytes;

  static fetch(File file) async {
    _dateTime = file.lastModifiedSync();
    _bytes = await file.length();
  }
  static int getBytes(){
    return _bytes;
  }

  static String getSize() {
    const int KB = 1024;
    const int MB = KB * 1024;
    const int GB = MB * 1024;
    if (_bytes >= GB) {
      return '${(_bytes / GB).toStringAsFixed(2)} GB';
    } else if (_bytes >= MB) {
      return '${(_bytes / MB).toStringAsFixed(2)} MB';
    } else if (_bytes >= KB) {
      return '${(_bytes / KB).toStringAsFixed(2)} KB';
    } else {
      return '$_bytes bytes';
    }
  }

  static String getDate() {
    return DateFormat('MMMM dd,yyyy hh:m a').format(_dateTime);
  }

  static String getDetails() {
    var dateFormat = DateFormat('MMM dd yyyy').format(_dateTime);
    return '${getSize()} $dateFormat';
  }
}
