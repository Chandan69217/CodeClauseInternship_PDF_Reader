


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


 class Read{
   List<FileSystemEntity>? _AllFiles;
   List<FileSystemEntity>? _PDFFiles;
   List<FileSystemEntity>? _DocFiles;
   List<FileSystemEntity>? _XlsFiles;
   List<FileSystemEntity>? _PptFiles;

   Read._();

   factory Read() => Read._();

   Future<void> _scanForAllFiles() async {
     if(await requestPermission()){
       final directory = await getExternalStorageDirectory();
       if(_AllFiles == null){
         _AllFiles = directory!.listSync(recursive: true).where((files){
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
     var status = await Permission.storage.request();
     return status.isGranted;
   }

   Future<List<FileSystemEntity>> getAllFiles() async {
     if(_AllFiles == null){
       await _scanForAllFiles();
     }
     return _AllFiles!;
   }


   Future<List<FileSystemEntity>> getPdfFiles() async {

     if(_PDFFiles == null){
       await _scanForAllFiles();
       _PDFFiles = _AllFiles!.where((files){
         String extension = files.path.split('.').last.toLowerCase();
         if(extension =='pdf'){
           return true;
         }else{
           return false;
         }
       }).toList();
     }
     return _PDFFiles!;
   }


   Future<List<FileSystemEntity>> getDocFiles() async{

     if(_DocFiles == null){
       await _scanForAllFiles();
       _DocFiles = _AllFiles!.where((files){
         String extension = files.path.split('.').last.toLowerCase();
         if(extension =='doc'||extension == 'docx'){
           return true;
         }else{
           return false;
         }
       }).toList();
     }
     return _DocFiles!;
   }

   Future<List<FileSystemEntity>> getExcelsFiles() async{

     if(_XlsFiles == null){
       await _scanForAllFiles();
       _XlsFiles = _AllFiles!.where((files){
         String extension = files.path.split('.').last.toLowerCase();
         if(extension =='xls'||extension == 'xlsx'){
           return true;
         }else{
           return false;
         }
       }).toList();
     }
     return _XlsFiles!;
   }

   Future<List<FileSystemEntity>> getPptFiles() async {
     if(_PptFiles == null){
       await _scanForAllFiles();
       _PptFiles = _AllFiles!.where((files){
         String extension = files.path.split('.').last.toLowerCase();
         if(extension =='ppt' || extension == 'pptx'){
           return true;
         }else{
           return false;
         }
       }).toList();
     }
     return _PptFiles!;
   }


 }