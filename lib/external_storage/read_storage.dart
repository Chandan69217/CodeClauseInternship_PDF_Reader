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

class Read {
  // ignore: non_constant_identifier_names
  static List<String> _FilePaths = [];
  static List<Data> AllFiles = [];
  final BuildContext context;
  static String sortingType = '';
  static List<Map<String,dynamic>> _bookmarks = [];
  VoidCallback? onClick;

  Read._(this.context);

  factory Read(BuildContext context) => Read._(context);

  Future<bool> scanForAllFiles() async {
    var database = await DatabaseHelper.getInstance();
    if (await requestPermission()) {
      if (_FilePaths.isEmpty) {
        _FilePaths = await _getAllPathsFromDirectory();
        _bookmarks = await database.getFiles(table_name: DatabaseHelper.BOOKMARK_TABLE_NAME);
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
            isBookmarked: _isBookmarked(path)
          )
          );
        }
        sortingType = await _checkSortingSetup();
        sortBy(sortingType);
        return true;
      }
    }
    return false;
  }

  bool _isBookmarked(String path) {
    return _bookmarks.any((bookmark) => bookmark[DatabaseHelper.FILE_PATH] == path);
  }

  Future<String> _checkSortingSetup() async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    final bool isKeyContains = instance.containsKey('SORTED_TYPE');
    if (!isKeyContains) {
      instance.setString(SortType.KEY, SortType.NAME);
    }
    final getType = instance.get('SORTED_TYPE');
    if (getType == SortType.DATE) {
      return SortType.DATE;
    } else if (getType == SortType.NAME) {
      return SortType.NAME;
    } else {
      return SortType.SIZE;
    }
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
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => PermissionScreen()));
        }
      }

      _showMessage(
          'Permission Required',
          'Storage permission is required for accessing files on your devices. please allow the permission',
          onClick);
    } else if (status.isPermanentlyDenied) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PermissionScreen()));
    }
    return status.isGranted;
  }

  static void updateFiles(Data oldData, Data newData) {
    AllFiles[AllFiles.indexOf(oldData)] = newData;
  }

  static void removeFiles(Data data) {
    AllFiles.remove(data);
  }

  void _showMessage(String title, String content, VoidCallback onClick) {
    AwesomeDialog(
            context: context,
            width: MediaQuery.of(context).size.width,
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

  static void sortBy(String sort) async {
    if (sort == SortType.NAME) {
      AllFiles = await Sort(filesData: AllFiles).sortByName();
    } else if (sort == SortType.DATE) {
      AllFiles = await Sort(filesData: AllFiles).sortByDate();
    } else if (sort == SortType.SIZE) {
      AllFiles = await Sort(filesData: AllFiles).sortBySize();
    }
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
          Set<String> validExtensions = {
            'pdf', 'docx', 'ppt', 'xls', 'doc', 'xlsx', 'pptx'
          };
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

}
