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

  Future<List<Data>> sortByName() async {
    await _quickSortName(0,filesData.length - 1);
    return filesData;
  }
  Future<void> _quickSortName(int low,int high)async{
    if(low<high){
      int pivotIndex = await _partitionByName(low, high);
      await _quickSortName(low, pivotIndex-1);
      await _quickSortName(pivotIndex+1, high);
    }
  }
  Future<int> _partitionByName(int low,int high) async {
    var pivot = filesData[high].fileName;
    int i = low - 1;
    for(int j = low;j<high;j++){
      var fileName = filesData[j].fileName;
      if(pivot.toLowerCase().trim().compareTo(fileName.toLowerCase().trim())>0){
        i++;
        var temp = filesData[i];
        filesData[i] = filesData[j];
        filesData[j] = temp;
      }
    }
    i++;
    var temp = filesData[i];
    filesData[i] = filesData[high];
    filesData[high] = temp;
    return i;
  }

  Future<List<Data>> sortBySize() async{
    await _quickSortBySize(0, filesData.length - 1);
    return filesData;
  }
  Future<void> _quickSortBySize(int low,int high)async{
    if(low<high){
      int pivotIndex = await _partitionBySize(low, high);
      await _quickSortBySize(low, pivotIndex-1);
      await _quickSortBySize(pivotIndex+1, high);
    }
  }
  Future<int> _partitionBySize(int low,int high) async{
    var pivot = filesData[high].bytes;
    int i = low - 1;
    for(int j = low;j<high;j++){
      var bytes = filesData[j].bytes;
      if(pivot>bytes){
        i++;
        var temp = filesData[i];
        filesData[i] = filesData[j];
        filesData[j] = temp;
      }
    }
    i++;
    var temp = filesData[i];
    filesData[i] = filesData[high];
    filesData[high] = temp;
    return i;
  }



  Future<List<Data>> sortByDate() async {
    await _quickSortByDate(0, filesData.length - 1);
    return filesData;
  }
  Future<void> _quickSortByDate(int low, int high) async {
    if (low < high) {
      int pivotIndex = await _partitionByDate(low, high);

      await _quickSortByDate(low, pivotIndex - 1);
      await _quickSortByDate(pivotIndex + 1, high);
    }
  }
  Future<int> _partitionByDate(int low, int high) async {
    var pivot = _format.parse(filesData[high].date);
    int i = low - 1;
    for (int j = low; j < high; j++) {
      var currentDate = _format.parse(filesData[j].date);

      if (pivot.isBefore(currentDate)) {
        i++;
        var temp = filesData[i];
        filesData[i] = filesData[j];
        filesData[j] = temp;
      }
    }
    var temp = filesData[i + 1];
    filesData[i + 1] = filesData[high];
    filesData[high] = temp;
    return i + 1;
  }




}