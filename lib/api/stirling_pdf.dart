import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pdf_reader/api/api_urls.dart';
import 'package:path/path.dart' as path;
import 'package:pdf_reader/utilities/save_files/save_files.dart';



class StirlingApiService {
  StirlingApiService._();

  static Future<void> convertPdfToImageWithProgress({
    required String filePath,
    required String imageFormat,
    required String singleOrMultiple,
    required String pageNumber,
    required String colorType,
    required String dpi,
    required ValueNotifier<Map<String,dynamic>> progress,
    required void Function(String? outputPath) onDownloadComplete,
  }) async {
    final uri = Uri.https(APIUrl.baseUrl, APIUrl.pdfToImage);
    final file = File(filePath);
    final fileLength = await file.length();

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({'accept': '*/*'})
      ..fields['imageFormat'] = imageFormat
      ..fields['singleOrMultiple'] = singleOrMultiple
      ..fields['pageNumbers'] = pageNumber
      ..fields['colorType'] = colorType
      ..fields['dpi'] = dpi;

    final fileStream = http.ByteStream(
      _trackUploadProgress(file.openRead(), fileLength, progress),
    );

    final multipartFile = http.MultipartFile(
      'fileInput',
      fileStream,
      fileLength,
      filename: file.path.split('/').last,
      contentType: MediaType('application', 'pdf'),
    );

    request.files.add(multipartFile);

    try {
      progress.value = {
        'progress': 0.5,
        'message':'converting...'
      };

      final client = http.Client();
      try {
        final streamedResponse = await client.send(request).timeout(Duration(minutes: 5));
        if (streamedResponse.statusCode == 200) {
          var outputPath = await SaveFiles.saveToDownloadsWithProgress(
            streamedResponse,
            progress,
          );
          onDownloadComplete('File Saved: $outputPath');
        } else {
          print('server did not response: status code: ${streamedResponse.statusCode}');
          onDownloadComplete('Something went wrong! Please try again');
        }
      } catch (e) {
        print('Exception: ${e.toString()}');
        onDownloadComplete('Server timeout or did not response!');
      }
    } catch (e) {
      onDownloadComplete('Something went wrong! Please try again');
      print('Exception during upload/download: $e');
    }
  }






  static Future<void> convertImageToPDFWithProgress({
    required List<File> files,
    required String fitOption,
    required String colorType,
    required bool autoRotate,
    required ValueNotifier<Map<String, dynamic>> progress,
    required void Function(String? outputPath) onDownloadComplete,
  }) async {

    final uri = Uri.https(APIUrl.baseUrl, APIUrl.imageToPDF);

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({'accept': '*/*'})
      ..fields['fitOption'] = fitOption
      ..fields['colorType'] = colorType
      ..fields['autoRotate'] = autoRotate.toString();

    int totalBytes = 0;
    List<_FileProgressInfo> fileInfos = [];

    // Prepare all files and calculate total size
    for (File file in files) {
      final length = await file.length();
      final extension =  path.extension(file.path).replaceFirst('.', '');
      totalBytes += length;
      fileInfos.add(_FileProgressInfo(file: file, length: length,extension: extension));
    }

    int uploadedBytes = 0;


    for (var info in fileInfos) {
      final fileStream = http.ByteStream(info.file.openRead().transform(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            uploadedBytes += data.length;
            double uploadProgress = uploadedBytes / totalBytes;
            progress.value = {
              'progress': uploadProgress * 0.5,
              'message': 'Uploading images...'
            };
            sink.add(data);
          },
        ),
      ));

      final multipartFile = http.MultipartFile(
        'fileInput',
        fileStream,
        info.length,
        filename: info.file.path.split('/').last,
        contentType: MediaType('image', info.extension), // Change if PNG, etc.
      );

      request.files.add(multipartFile);
    }

    try {
      progress.value = {
        'progress': 0.5,
        'message': 'Converting to PDF...'
      };

      final client = http.Client();
      try {
        final streamedResponse = await client.send(request).timeout(Duration(minutes: 5));
        if (streamedResponse.statusCode == 200) {
          var outputPath = await SaveFiles.saveToDownloadsWithProgress(
            streamedResponse,
            progress,
          );
          onDownloadComplete('File Saved: $outputPath');
        } else {
          print('status code: ${streamedResponse.statusCode}, Reason: ${streamedResponse.reasonPhrase}');
          onDownloadComplete('Something went wrong! Please try again');
        }
      } catch (e) {
        print('exception: ${e.toString()}');
        onDownloadComplete('Server timeout or did not respond!');
      }
    } catch (e) {
      onDownloadComplete('Something went wrong! Please try again');
      print('❌ Exception during upload/download: $e');
    }
  }


  static Stream<List<int>> _trackUploadProgress(
      Stream<List<int>> stream,
      int total,
      ValueNotifier<Map<String,dynamic>> progress,
      ) async* {
    int bytesSent = 0;
    await for (var chunk in stream) {
      bytesSent += chunk.length;
      progress.value = {
        'progress':bytesSent / total * 0.5,
        'message':'file uploading...'
      };
      yield chunk;
    }
  }



  static Future<void> lockPDF({
    required Map<String,dynamic> data,
    required ValueNotifier<Map<String,dynamic>> progress,
    required void Function(String? outputPath) onDownloadComplete,
  }) async {
    final uri = Uri.https(APIUrl.baseUrl, APIUrl.lockPDF);
    final file = File(data['fileInput']);
    final fileLength = await file.length();

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({'accept': '*/*'})
      ..fields['ownerPassword'] = data['ownerPassword']
      ..fields['password'] = data['password']
      ..fields['keyLength'] = '40'
      ..fields['canAssembleDocument'] = data['canAssembleDocument'].toString()
      ..fields['canExtractForAccessibility'] = data['canExtractForAccessibility'].toString()
      ..fields['canExtractContent'] = data['canExtractContent'].toString()
      ..fields['canFillInForm'] = data['canFillInForm'].toString()
      ..fields['canModify'] = data['canModify'].toString()
      ..fields['canModifyAnnotations'] = data['canModifyAnnotations'].toString()
      ..fields['canPrint'] = data['canPrint'].toString()
      ..fields['canPrintFaithful'] = data['canPrintFaithful'].toString();


    final fileStream = http.ByteStream(
      _trackUploadProgress(file.openRead(), fileLength, progress),
    );

    final multipartFile = http.MultipartFile(
      'fileInput',
      fileStream,
      fileLength,
      filename: file.path.split('/').last,
      contentType: MediaType('application', 'pdf'),
    );

    request.files.add(multipartFile);

    try {
      progress.value = {
        'progress': 0.5,
        'message':'converting...'
      };

      final client = http.Client();
      try {
        final streamedResponse = await client.send(request).timeout(Duration(minutes: 5));
        if (streamedResponse.statusCode == 200) {
          var outputPath = await SaveFiles.saveToDownloadsWithProgress(
            streamedResponse,
            progress,
          );
          onDownloadComplete('File Saved: $outputPath');
        } else {
          print('server did not response: status code: ${streamedResponse.statusCode},reason: ${streamedResponse.reasonPhrase}');
          onDownloadComplete('Something went wrong! Please try again');
        }
      } catch (e) {
        print('Exception: ${e.toString()}');
        onDownloadComplete('Server timeout or did not response!');
      }
    } catch (e) {
      onDownloadComplete('Something went wrong! Please try again');
      print('Exception during upload/download: $e');
    }
  }




}


class _FileProgressInfo {
final File file;
final int length;
final String extension;
_FileProgressInfo({required this.file, required this.length,required this.extension});
}