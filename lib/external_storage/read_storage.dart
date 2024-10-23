import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_reader/screens/permission_screen.dart';
import 'package:pdf_reader/utilities/get_file_details.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizing/sizing.dart';
import '../model/data.dart';


 class Read{
   // ignore: non_constant_identifier_names
   List<FileSystemEntity>? _AllEntity = [];
   List<Data>? _AllFiles = [];
   List<Data>? _PDFFiles = [];
   List<Data>? _DocFiles = [];
   List<Data>? _XlsFiles = [];
   List<Data>? _PptFiles = [];
   final BuildContext context;
   VoidCallback? onClick;

   Read._(this.context);

   factory Read(BuildContext context) => Read._(context);

   Future<void> _scanForAllFiles() async {
     if(await requestPermission()){
       final dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
       if(_AllEntity!.isEmpty){
         Directory directory = Directory(dir);
         _AllEntity = directory.listSync(recursive: true).where((files){
           String extension = files.path.split('.').last.toLowerCase();
           if(extension =='pdf'||extension == 'docx' || extension == 'ppt' || extension == 'xls' || extension == 'doc' || extension == 'xlsx' || extension == 'pptx'){
             return true;
           }else{
             return false;
           }
         }).toList();
       }
     }
   }

   Future<bool> requestPermission()async{
     PermissionStatus status;

     DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
     AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;
     if(deviceInfo.version.sdkInt < 30){
       status = await Permission.storage.request();
     }else{
       status = await Permission.manageExternalStorage.request();
     }

     if(status.isDenied){
       onClick() async {
         if(deviceInfo.version.sdkInt < 30){
           status = await Permission.storage.request();
         }else{
           status = await Permission.manageExternalStorage.request();
         }
         if(status.isDenied){
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> PermissionScreen()));
         }
       }
       showMessage('Permission Required', 'Storage permission is required for accessing files on your devices. please allow the permission',onClick);
     }else if(status.isPermanentlyDenied){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> PermissionScreen()));
     }
     return status.isGranted;
   }

   Future<List<Data>> getAllFiles() async {
     if(_AllFiles!.isEmpty){
       await _scanForAllFiles();
       for( var entity in _AllEntity!){
         String extension = entity.path.split('.').last.toLowerCase();
           var fileName = entity.path.split('/').last;
           var details = await getFileDetails(File(entity.path));
           _AllFiles!.add(Data(
               file: File(entity.path),
               fileType: extension,
               fileName: fileName,
               details: details,
               filePath: entity.path
           ));
       }
     }
     return _AllFiles!;
   }


   Future<List<Data>> getPdfFiles() async {

     if(_PDFFiles!.isEmpty){
       await _scanForAllFiles();
       for( var entity in _AllEntity!){
         String extension = entity.path.split('.').last.toLowerCase();
         if(extension == 'pdf'){
           var fileName = entity.path.split('/').last;
           var details = await getFileDetails(File(entity.path));
           _PDFFiles!.add(Data(
             file: File(entity.path),
             fileType: extension,
             fileName: fileName,
             details: details,
             filePath: entity.path
           ));
         }
       }
     }
     return _PDFFiles!;
   }


   Future<List<Data>> getDocFiles() async{

     if(_DocFiles!.isEmpty){
       await _scanForAllFiles();
       for( var entity in _AllEntity!){
         String extension = entity.path.split('.').last.toLowerCase();
         if(extension == 'doc' || extension == 'docx'){
           var fileName = entity.path.split('/').last;
           var details = await getFileDetails(File(entity.path));
           _DocFiles!.add(Data(
               file: File(entity.path),
               fileType: extension,
               fileName: fileName,
               details: details,
               filePath: entity.path
           ));
         }
       }
     }
     return _DocFiles!;
   }

   Future<List<Data>> getExcelsFiles() async{

     if(_XlsFiles!.isEmpty){
       await _scanForAllFiles();
       for( var entity in _AllEntity!){
         String extension = entity.path.split('.').last.toLowerCase();
         if(extension == 'xls' || extension == 'xlsx'){
           var fileName = entity.path.split('/').last;
           var details = await getFileDetails(File(entity.path));
           _XlsFiles!.add(Data(
               file: File(entity.path),
               fileType: extension,
               fileName: fileName,
               details: details,
               filePath: entity.path
           ));
         }
       }
     }
     return _XlsFiles!;
   }

   Future<List<Data>> getPptFiles() async {
     if(_PptFiles!.isEmpty){
       await _scanForAllFiles();
       for( var entity in _AllEntity!){
         String extension = entity.path.split('.').last.toLowerCase();
         if(extension == 'ppt' || extension == 'pptx'){
           var fileName = entity.path.split('/').last;
           var details = await getFileDetails(File(entity.path));
           _PptFiles!.add(Data(
               file: File(entity.path),
               fileType: extension,
               fileName: fileName,
               details: details,
               filePath: entity.path
           ));
         }
       }
     }
     return _PptFiles!;
   }

   void showMessage(String title,String content,VoidCallback onClick){
     showDialog(context: context,barrierDismissible: false,useSafeArea: true,
         builder: (context){
       return AlertDialog(
         title: Row(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Icon(Icons.perm_media_outlined),
             SizedBox(width: 8.ss,),
             Text(title,style: TextStyle(overflow: TextOverflow.ellipsis),),
           ],
         ),
         content: Text(content),
         actions: [
           TextButton(onPressed: (){SystemNavigator.pop();}, child: const Text('Cancel')),
           TextButton(onPressed: (){onClick(); Navigator.of(context).pop();}, child: const Text('Ok')),
         ],
       );
     });
   }


 }