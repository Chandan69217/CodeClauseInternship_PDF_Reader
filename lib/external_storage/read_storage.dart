import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_reader/screens/permission_screen.dart';
import 'package:pdf_reader/utilities/get_file_details.dart';
import 'package:pdf_reader/utilities/sort.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/data.dart';

class Read {
  // ignore: non_constant_identifier_names
  static List<FileSystemEntity> _AllEntity = [];
  static List<Data> AllFiles = [];
  static List<Data> PDFFiles = [];
  static List<Data> DocFiles = [];
  static List<Data> XlsFiles = [];
  static List<Data> PptFiles = [];
  final BuildContext context;
  static String sortingType = '';
  VoidCallback? onClick;

  Read._(this.context);

  factory Read(BuildContext context) => Read._(context);

  Future<bool> scanForAllFiles() async {
    if (await requestPermission()) {
      final dir = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      if (_AllEntity.isEmpty) {
        Directory directory = Directory(dir);
        _AllEntity = directory.listSync(recursive: true);
        for (FileSystemEntity files in _AllEntity) {
          String extension = files.path.split('.').last.toLowerCase();
          if (extension == 'pdf' ||
              extension == 'docx' ||
              extension == 'ppt' ||
              extension == 'xls' ||
              extension == 'doc' ||
              extension == 'xlsx' ||
              extension == 'pptx') {
            await FileDetails.fetch(File(files.path));
            AllFiles.add(Data(
                file: File(files.path),
                fileType: extension,
                fileName: files.path.split('/').last,
                filePath: files.path,
                details: FileDetails.getDetails(),
                fileSize: FileDetails.getSize(),
                date: FileDetails.getDate(),
                bytes: FileDetails.getBytes()));
          }
        }
        for (Data data in AllFiles) {
          switch (data.fileType) {
            case 'pdf':
              PDFFiles.add(data);
              break;
            case 'doc':
            case 'docx':
              DocFiles.add(data);
              break;
            case 'xls':
            case 'xlsx':
              XlsFiles.add(data);
              break;
            case 'ppt':
            case 'pptx':
              PptFiles.add(data);
              break;
          }
        }
        sortingType = await checkSortingSetup();
        sortBy(sortingType);
        return true;
      }
    }
    return false;
  }

  Future<String> checkSortingSetup() async{
    var instance = await SharedPreferences.getInstance();
    var isKeyContains = await instance.containsKey('SORTED_TYPE');
    if(!isKeyContains){
      instance.setString(SortType.KEY,SortType.NAME);
    }
    var getType = instance.get('SORTED_TYPE');
    if(getType == 'DATE'){
        return SortType.DATE;
    }else if(getType == 'NAME'){
        return SortType.NAME;
    }else{
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

  static void updateFilesRename(Data oldData, newData) {
    switch (oldData.fileType) {
      case 'pdf':
        AllFiles[AllFiles.indexOf(oldData)] = newData;
        PDFFiles[PDFFiles.indexOf(oldData)] = newData;
        break;
      case 'doc':
      case 'docx':
        AllFiles[AllFiles.indexOf(oldData)] = newData;
        DocFiles[DocFiles.indexOf(oldData)] = newData;
        break;
      case 'xls':
      case 'xlsx':
        AllFiles[AllFiles.indexOf(oldData)] = newData;
        XlsFiles[XlsFiles.indexOf(oldData)] = newData;
        break;
      case 'ppt':
      case 'pptx':
        AllFiles[AllFiles.indexOf(oldData)] = newData;
        PptFiles[PptFiles.indexOf(oldData)] = newData;
        break;
    }
  }

  static void updateFilesDeletion(Data data) {
    switch (data.fileType) {
      case 'pdf':
        AllFiles.remove(data);
        PDFFiles.remove(data);
        break;
      case 'doc':
      case 'docx':
        AllFiles.remove(data);
        DocFiles.remove(data);
        break;
      case 'xls':
      case 'xlsx':
        AllFiles.remove(data);
        XlsFiles.remove(data);
        break;
      case 'ppt':
      case 'pptx':
        AllFiles.remove(data);
        PptFiles.remove(data);
        break;
    }
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
    if(sort == SortType.NAME){
      AllFiles = Sort(filesData: AllFiles).sortByName();
      PDFFiles = Sort(filesData: PDFFiles).sortByName();
      DocFiles = Sort(filesData: DocFiles).sortByName();
      XlsFiles = Sort(filesData: XlsFiles).sortByName();
      PptFiles = Sort(filesData: PptFiles).sortByName();
    }else if(sort == SortType.DATE){
      AllFiles = Sort(filesData: AllFiles).sortByDate();
      PDFFiles = Sort(filesData: PDFFiles).sortByDate();
      DocFiles = Sort(filesData: DocFiles).sortByDate();
      XlsFiles = Sort(filesData: XlsFiles).sortByDate();
      PptFiles = Sort(filesData: PptFiles).sortByDate();
    }else if(sort == SortType.SIZE){
      AllFiles = Sort(filesData: AllFiles).sortBySize();
      PDFFiles = Sort(filesData: PDFFiles).sortBySize();
      DocFiles = Sort(filesData: DocFiles).sortBySize();
      XlsFiles = Sort(filesData: XlsFiles).sortBySize();
      PptFiles = Sort(filesData: PptFiles).sortBySize();
    }
  }
}