import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/sort.dart';

typedef OnRenamed = void Function(Data oldData,Data newData);
typedef OnDeleted = void Function(bool status,Data data);
typedef OnSort = void Function(SortBy sort);