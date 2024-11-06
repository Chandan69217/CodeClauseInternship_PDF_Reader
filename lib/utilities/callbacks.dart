import 'package:pdf_reader/model/data.dart';

typedef OnRenamed = void Function(Data oldData,Data newData);
typedef OnDeleted = void Function(bool status,Data data);