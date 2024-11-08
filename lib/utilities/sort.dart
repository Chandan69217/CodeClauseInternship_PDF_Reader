import 'package:intl/intl.dart';
import 'package:pdf_reader/model/data.dart';

class SortType{
  static const String KEY = 'SORTED_TYPE';
  static const String NAME = 'NAME';
  static const String DATE = 'DATE';
  static const String SIZE = 'SIZE';
}

class Sort{
  List<Data> filesData;
  int length = 0;
  DateFormat _format = DateFormat('MMMM dd,yyyy hh:m a');
  Sort({required this.filesData}): length = filesData.length;

  List<Data> sortByName(){
    for(int i = 1; i < length; i++){
      for(int j = 0; j< (length-i); j++){
        var file1 = filesData[j].fileName;
        var file2 = filesData[j+1].fileName;
        if(file1.toLowerCase().compareTo(file2.toLowerCase())>0){
          var temp = filesData[j];
          filesData[j] = filesData[j+1];
          filesData[j+1] = temp;
        }
      }
    }
    return filesData;
  }

  List<Data> sortBySize(){
    for(int i = 0; i<(length-1);i++){
      for(int j = (i+1); j<length;j++){
        var file1 = filesData[i];
        var file2 = filesData[j];
        if(file1.bytes >file2.bytes){
          var temp = filesData[i];
          filesData[i] = filesData[j];
          filesData[j] = temp;
        }
      }
    }
    return filesData;
  }

  List<Data> sortByDate(){
    for(int i = 0; i<(length-1);i++){
      for(int j = (i+1); j<length;j++){
        var file1 = _format.parse(filesData[i].date);
        var file2 = _format.parse(filesData[j].date);
        if(file1.isBefore(file2)){
          var temp = filesData[i];
          filesData[i] = filesData[j];
          filesData[j] = temp;
        }
      }
    }
    return filesData;
  }

}