import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_reader/external_storage/database_helper.dart';
import 'package:pdf_reader/screens/permission_screen.dart';
import 'package:pdf_reader/utilities/get_file_details.dart';
import 'package:pdf_reader/utilities/sort.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/data.dart';

enum TypeOfUpdate{
  BOOKMARK,
  HISTORY,
  RENAME,
}

Set<String> validExtensions = {
  'pdf', 'docx', 'ppt', 'xls', 'doc', 'xlsx', 'pptx'
};

class Read with ChangeNotifier {
  // ignore: non_constant_identifier_names
  List<String> _FilePaths = [];
  List<Data> AllFiles = [];
  final BuildContext _context;
  Map<String,String> appliedSorting = {};
  List<Map<String,dynamic>> _bookmarks = [];
  List<Map<String,dynamic>> _history = [];
  VoidCallback? onClick;


  Read._(this._context);
  factory Read(BuildContext context) {
    _instance ??= Read._(context);
    return _instance!;
  }

  static Read? _instance;
  static Read get instance {
    if (_instance == null) {
      throw Exception('Read instance is not initialized. Call Read(context) first.');
    }
    return _instance!;
  }

  Future<bool> scanForAllFiles() async {
    var database = await DatabaseHelper.getInstance();
    if (await requestPermission()) {
      _FilePaths = await _getAllPathsFromDirectory();
      _bookmarks = await database.getFiles(table_name: DatabaseHelper.BOOKMARK_TABLE_NAME);
      _history = await database.getFiles(table_name: DatabaseHelper.HISTORY_TABLE_NAME);
      for (var path in _FilePaths) {
        String extension = path.split('.').last.toLowerCase();
        await FileDetails.fetch(File(path));
        AllFiles.add(Data(
          file: File(path),
          fileType: extension,
          fileName: path.split('/').last,
          filePath: path,
          details: FileDetails.getDetails(),
          fileSize: FileDetails.getSize(),
          date: FileDetails.getDate(),
          bytes: FileDetails.getBytes(),
          isBookmarked: _isBookmarked(path),
          isHistory:  _isHistory(path),
        )
        );
      }
      appliedSorting = await _checkSortingSetup();
      sortBy(appliedSorting[SortType.KEY]!);
      notifyListeners();
      return true;
    }
    return false;
  }

  bool _isBookmarked(String path) {
    return _bookmarks.any((bookmark) => bookmark[DatabaseHelper.FILE_PATH] == path);
  }

  Future<Map<String,String>> _checkSortingSetup() async {
    final SharedPreferences instance = await SharedPreferences.getInstance();

    if (!instance.containsKey(SortType.KEY)) {
      instance.setString(SortType.KEY, SortType.NAME);
      return {SortType.KEY:SortType.NAME};
    }
    final getType = instance.get(SortType.KEY);
    return {SortType.KEY:getType.toString()};
  }

  Future<bool> requestPermission() async {
    PermissionStatus status;
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;
    if (deviceInfo.version.sdkInt < 30) {
      status = await Permission.storage.request();
    } else {
      status = await Permission.manageExternalStorage.request();
    }

    if (status.isDenied) {
      onClick() async {
        if (deviceInfo.version.sdkInt < 30) {
          status = await Permission.storage.request();
        } else {
          status = await Permission.manageExternalStorage.request();
        }
        if (status.isDenied) {
          Navigator.pushReplacement(_context,
              MaterialPageRoute(builder: (context) => PermissionScreen()));
        }
      }
      _showMessage(
          'Permission Required',
          'Storage permission is required for accessing files on your devices. please allow the permission',
          onClick);
    } else if (status.isPermanentlyDenied) {
      Navigator.pushReplacement(
          _context, MaterialPageRoute(builder: (context) => PermissionScreen()));
    }
    return status.isGranted;
  }


  Future<bool> updateFiles(Data data,{TypeOfUpdate? typeOfUpdate,Data? newData})async {
    final oldData = data;
    if(typeOfUpdate == TypeOfUpdate.BOOKMARK){
      data.isBookmarked = !data.isBookmarked;
    }else if(typeOfUpdate == TypeOfUpdate.HISTORY){
      data.isHistory = !data.isHistory;
    }else if(typeOfUpdate == TypeOfUpdate.RENAME){
      if(newData!=null){
        AllFiles[AllFiles.indexOf(oldData)] = newData;
        if(appliedSorting.isNotEmpty){
          sortBy(appliedSorting[SortType.KEY]!);
        }
        notifyListeners();
        return true;
      }else{
        return false;
      }
    }
    AllFiles[AllFiles.indexOf(oldData)] = data ;
    if(appliedSorting.isNotEmpty){
      sortBy(appliedSorting[SortType.KEY]!);
    }
    notifyListeners();
    return true;
  }

  Future<bool> removeFiles(Data data) async{
    try{
      if(await data.file.exists()){
       try{
         await data.file.delete();
         final value = AllFiles.remove(data);
         notifyListeners();
         return value;
       }catch(exception){
         print('Unable to delete file from storage ${data.fileName} : $exception');
         return false;
       }
      }else{
        print('File does not exists');
        return false;
      }
    }catch(e){
      print(e.toString());
      return false;
    }
  }


  void _showMessage(String title, String content, VoidCallback onClick) {
    AwesomeDialog(
            context: _context,
            width: MediaQuery.of(_context).size.width,
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            animType: AnimType.scale,
            btnOkOnPress: () {
              onClick();
            },
            btnCancelOnPress: () {
              SystemNavigator.pop();
            },
            dialogType: DialogType.info,
            title: title,
            desc: content)
        .show();
  }

  void sortBy(String sort) async {
    if (sort == SortType.NAME) {
      AllFiles = await Sort(filesData: AllFiles).sortByName();
    } else if (sort == SortType.DATE) {
      AllFiles = await Sort(filesData: AllFiles).sortByDate();
    } else if (sort == SortType.SIZE) {
      AllFiles = await Sort(filesData: AllFiles).sortBySize();
    }
    notifyListeners();
  }

  Future<List<String>> _getAllPathsFromDirectory() async {
    List<String> paths = [];
    List<String> rootDir = await ExternalPath.getExternalStorageDirectories();
    for (var dir in rootDir) {
      paths.addAll(await _listFilesRecursively(Directory(dir)));
    }
    return paths;
  }

  Future<List<String>> _listFilesRecursively(Directory dir) async {
    List<String> paths = [];

    if (_shouldSkipDirectory(dir.path)) {
      return paths;
    }

    try {
      await for (var entity in dir.list()) {
        if (entity is Directory) {
          paths.addAll(await _listFilesRecursively(entity));
        } else if (entity is File) {
          String extension = entity.path.split('.').last.toLowerCase();
          if (validExtensions.contains(extension)) {
            paths.add(entity.path);
          }
        }
      }
    } catch (e) {
      print("Error accessing directory: ${dir.path}, $e");
    }
    return paths;
  }

  bool _shouldSkipDirectory(String path) {
    List<String> skipPaths = [
      '/system',  // Android system folder
      '/proc',    // Virtual files in proc (process information)
      '/dev',     // Device files
      '/data',    // App data directories (restricted)
      '/storage/emulated/0/Android/data',
      '/storage/emulated/0/Android/obb'
    ];

    return skipPaths.any((skip) => path.startsWith(skip));
  }

  bool _isHistory(String path) {
    return _history.any((history) => history[DatabaseHelper.FILE_PATH] == path);
  }

  Future<void> saveSorting(String sortingType) async {
    var instance = await SharedPreferences.getInstance();
    instance.setString(SortType.KEY, sortingType);
    appliedSorting = {SortType.KEY : sortingType};
    sortBy(sortingType);
  }

}
