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
        return true;
      }
    }
    return false;
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

  static void sortBy(SortBy sort) async {
    if(sort == SortBy.NAME){
      AllFiles = Sort(filesData: AllFiles).sortByName();
      PDFFiles = Sort(filesData: PDFFiles).sortByName();
      DocFiles = Sort(filesData: DocFiles).sortByName();
      XlsFiles = Sort(filesData: XlsFiles).sortByName();
      PptFiles = Sort(filesData: PptFiles).sortByName();
    }else if(sort == SortBy.DATE){
      AllFiles = Sort(filesData: AllFiles).sortByDate();
      PDFFiles = Sort(filesData: PDFFiles).sortByDate();
      DocFiles = Sort(filesData: DocFiles).sortByDate();
      XlsFiles = Sort(filesData: XlsFiles).sortByDate();
      PptFiles = Sort(filesData: PptFiles).sortByDate();
    }else if(sort == SortBy.SIZE){
      AllFiles = Sort(filesData: AllFiles).sortBySize();
      PDFFiles = Sort(filesData: PDFFiles).sortBySize();
      DocFiles = Sort(filesData: DocFiles).sortBySize();
      XlsFiles = Sort(filesData: XlsFiles).sortBySize();
      PptFiles = Sort(filesData: PptFiles).sortBySize();
    }
  }
}

// class Read {
//   // ignore: non_constant_identifier_names
//   List<FileSystemEntity>? _AllEntity = [];
//   List<Data>? _AllFiles = [];
//   List<Data>? _PDFFiles = [];
//   List<Data>? _DocFiles = [];
//   List<Data>? _XlsFiles = [];
//   List<Data>? _PptFiles = [];
//   final BuildContext context;
//   VoidCallback? onClick;
//
//   Read._(this.context);
//
//   factory Read(BuildContext context) => Read._(context);
//
//   Future<void> _scanForAllFiles() async {
//     if (await requestPermission()) {
//       final dir = await ExternalPath.getExternalStoragePublicDirectory(
//           ExternalPath.DIRECTORY_DOWNLOADS);
//       if (_AllEntity!.isEmpty) {
//         Directory directory = Directory(dir);
//         _AllEntity = directory.listSync(recursive: true).where((files) {
//           String extension = files.path.split('.').last.toLowerCase();
//           if (extension == 'pdf' ||
//               extension == 'docx' ||
//               extension == 'ppt' ||
//               extension == 'xls' ||
//               extension == 'doc' ||
//               extension == 'xlsx' ||
//               extension == 'pptx') {
//             return true;
//           } else {
//             return false;
//           }
//         }).toList();
//       }
//     }
//   }
//
//   Future<bool> requestPermission() async {
//     PermissionStatus status;
//
//     DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//     AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;
//     if (deviceInfo.version.sdkInt < 30) {
//       status = await Permission.storage.request();
//     } else {
//       status = await Permission.manageExternalStorage.request();
//     }
//
//     if (status.isDenied) {
//       onClick() async {
//         if (deviceInfo.version.sdkInt < 30) {
//           status = await Permission.storage.request();
//         } else {
//           status = await Permission.manageExternalStorage.request();
//         }
//         if (status.isDenied) {
//           Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (context) => PermissionScreen()));
//         }
//       }
//
//       _showMessage(
//           'Permission Required',
//           'Storage permission is required for accessing files on your devices. please allow the permission',
//           onClick);
//     } else if (status.isPermanentlyDenied) {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => PermissionScreen()));
//     }
//     return status.isGranted;
//   }
//
//   Future<List<Data>> getAllFiles() async {
//     if (_AllFiles!.isEmpty) {
//       await _scanForAllFiles();
//       for (var entity in _AllEntity!) {
//         String extension = entity.path.split('.').last.toLowerCase();
//         var fileName = entity.path.split('/').last;
//         await FileDetails.fetch(File(entity.path));
//         var details = FileDetails.getDetails();
//         var fileSize = FileDetails.getSize();
//         var date = FileDetails.getDate();
//         _AllFiles!.add(Data(
//             file: File(entity.path),
//             fileType: extension,
//             fileName: fileName,
//             details: details,
//             filePath: entity.path,
//             fileSize: fileSize,
//             date: date));
//       }
//     }
//     return _AllFiles!;
//   }
//
//   Future<List<Data>> getPdfFiles() async {
//     if (_PDFFiles!.isEmpty) {
//       await _scanForAllFiles();
//       for (var entity in _AllEntity!) {
//         String extension = entity.path.split('.').last.toLowerCase();
//         if (extension == 'pdf') {
//           var fileName = entity.path.split('/').last;
//           await FileDetails.fetch(File(entity.path));
//           var details = FileDetails.getDetails();
//           var fileSize = FileDetails.getSize();
//           var date = FileDetails.getDate();
//           _PDFFiles!.add(Data(
//               file: File(entity.path),
//               fileType: extension,
//               fileName: fileName,
//               details: details,
//               filePath: entity.path,
//               fileSize: fileSize,
//               date: date));
//         }
//       }
//     }
//     return _PDFFiles!;
//   }
//
//   Future<List<Data>> getDocFiles() async {
//     if (_DocFiles!.isEmpty) {
//       await _scanForAllFiles();
//       for (var entity in _AllEntity!) {
//         String extension = entity.path.split('.').last.toLowerCase();
//         if (extension == 'doc' || extension == 'docx') {
//           var fileName = entity.path.split('/').last;
//           await FileDetails.fetch(File(entity.path));
//           var details = FileDetails.getDetails();
//           var fileSize = FileDetails.getSize();
//           var date = FileDetails.getDate();
//           _DocFiles!.add(Data(
//               file: File(entity.path),
//               fileType: extension,
//               fileName: fileName,
//               details: details,
//               filePath: entity.path,
//               fileSize: fileSize,
//               date: date));
//         }
//       }
//     }
//     return _DocFiles!;
//   }
//
//   Future<List<Data>> getExcelsFiles() async {
//     if (_XlsFiles!.isEmpty) {
//       await _scanForAllFiles();
//       for (var entity in _AllEntity!) {
//         String extension = entity.path.split('.').last.toLowerCase();
//         if (extension == 'xls' || extension == 'xlsx') {
//           var fileName = entity.path.split('/').last;
//           await FileDetails.fetch(File(entity.path));
//           var details = FileDetails.getDetails();
//           var fileSize = FileDetails.getSize();
//           var date = FileDetails.getDate();
//           _XlsFiles!.add(Data(
//               file: File(entity.path),
//               fileType: extension,
//               fileName: fileName,
//               details: details,
//               filePath: entity.path,
//               fileSize: fileSize,
//               date: date));
//         }
//       }
//     }
//     return _XlsFiles!;
//   }
//
//   Future<List<Data>> getPptFiles() async {
//     if (_PptFiles!.isEmpty) {
//       await _scanForAllFiles();
//       for (var entity in _AllEntity!) {
//         String extension = entity.path.split('.').last.toLowerCase();
//         if (extension == 'ppt' || extension == 'pptx') {
//           var fileName = entity.path.split('/').last;
//           await FileDetails.fetch(File(entity.path));
//           var details = FileDetails.getDetails();
//           var fileSize = FileDetails.getSize();
//           var date = FileDetails.getDate();
//           _PptFiles!.add(Data(
//               file: File(entity.path),
//               fileType: extension,
//               fileName: fileName,
//               details: details,
//               filePath: entity.path,
//               fileSize: fileSize,
//               date: date));
//         }
//       }
//     }
//     return _PptFiles!;
//   }
//
//   void _showMessage(String title, String content, VoidCallback onClick) {
//     AwesomeDialog(
//             context: context,
//             dismissOnBackKeyPress: false,
//             dismissOnTouchOutside: false,
//             animType: AnimType.scale,
//             btnOkOnPress: () {
//               onClick();
//             },
//             btnCancelOnPress: () {
//               SystemNavigator.pop();
//             },
//             dialogType: DialogType.info,
//             title: title,
//             desc: content)
//         .show();
//   }
// }
