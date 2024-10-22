import 'dart:io';

import 'package:intl/intl.dart';

Future<String> getFileDetails(File file) async {
  const int kb = 1024;
  const int mb = kb * 1024;
  const int gb = mb * 1024;

  var bytes = await file.length();
  var date = await file.lastModified();
  var formatData = DateFormat('MMM dd yyyy').format(date);
  if (bytes >= gb) {
    return '${(bytes / gb).toStringAsFixed(2)} GB $formatData';
  } else if (bytes >= mb) {
    return '${(bytes / mb).toStringAsFixed(2)} MB $formatData';
  } else if (bytes >= kb) {
    return '${(bytes / kb).toStringAsFixed(2)} KB $formatData';
  } else {
    return '$bytes Bytes $formatData';
  }

}