import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pdf_reader/api/api_urls.dart';
import 'package:path/path.dart' as path;
import 'package:pdf_reader/utilities/save_files/save_files.dart';




import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';



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
      _trackUploadProgress(file.openRead(), fileLength,fileLength, progress),
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
        'message':'Converting to Image...'
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
      int fileLength,
      int totalLength,
      ValueNotifier<Map<String, dynamic>> progress, {
        bool isPDF = true,
      }) async* {
    int bytesSent = 0;
    await for (var chunk in stream) {
      bytesSent += chunk.length;
      double ratio = fileLength / totalLength;
      double progressPart = isPDF ? ratio * 0.5 : ratio * 0.5 + 0.5; // adjust progress split if needed
      progress.value = {
        'progress': isPDF
            ? (bytesSent / fileLength) * 0.5
            : 0.5 + (bytesSent / fileLength) * 0.5,
        'message': isPDF ? 'Uploading PDF...' : 'Uploading Watermark Image...',
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
      _trackUploadProgress(file.openRead(), fileLength,fileLength, progress),
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




  static Future<void> unlockPDF({
    required String path,
    required String password,
    required ValueNotifier<Map<String,dynamic>> progress,
    required void Function(String? outputPath) onDownloadComplete,
  }) async {
    final uri = Uri.https(APIUrl.baseUrl, APIUrl.unlockPDF);
    final file = File(path);
    final fileLength = await file.length();

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({'accept': '*/*'})
      ..fields['password'] = password;


    final fileStream = http.ByteStream(
      _trackUploadProgress(file.openRead(), fileLength,fileLength, progress),
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
        }else if(streamedResponse.statusCode == 500){
          onDownloadComplete('Incorrect Password');
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



  static Future<void> splitPDF({
    required String path,
    required String pages,
    required ValueNotifier<Map<String,dynamic>> progress,
    required void Function(String? outputPath) onDownloadComplete,
  }) async {
    final uri = Uri.https(APIUrl.baseUrl, APIUrl.splitPDF);
    final file = File(path);
    final fileLength = await file.length();

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({'accept': '*/*'})
      ..fields['pageNumbers'] = pages;


    final fileStream = http.ByteStream(
      _trackUploadProgress(file.openRead(), fileLength,fileLength, progress),
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
        }else {
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



  static Future<void> MargePDF({
    required List<File> files,
    required String sortType,
    required bool removeCertSign,
    required ValueNotifier<Map<String, dynamic>> progress,
    required void Function(String? outputPath) onDownloadComplete,
  }) async {

    final uri = Uri.https(APIUrl.baseUrl, APIUrl.mergePDF);

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({'accept': '*/*'})
      ..fields['sortType'] = sortType
      ..fields['removeCertSign'] = removeCertSign.toString();

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
        contentType: MediaType('application', 'pdf'), // Change if PNG, etc.
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



  static Future<void> convertFileToPDF({
    required String path,
    required ValueNotifier<Map<String,dynamic>> progress,
    required void Function(String? outputPath) onDownloadComplete,
  }) async {
    final uri = Uri.https(APIUrl.baseUrl, APIUrl.fileToPDF);
    final file = File(path);
    final fileLength = await file.length();

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({'accept': '*/*'});

    final fileStream = http.ByteStream(
      _trackUploadProgress(file.openRead(), fileLength,fileLength, progress),
    );

    final multipartFile = http.MultipartFile(
      'fileInput',
      fileStream,
      fileLength,
      filename: file.path.split('/').last,
      contentType: _getMediaTypeFromExtension(file.path),
    );

    request.files.add(multipartFile);

    try {
      progress.value = {
        'progress': 0.5,
        'message':'converting...'
      };

      final client = http.Client();
      try {
        final streamedResponse = await client.send(request).timeout(Duration(minutes: 10));
        if (streamedResponse.statusCode == 200) {
          var outputPath = await SaveFiles.saveToDownloadsWithProgress(
            streamedResponse,
            progress,
          );
          onDownloadComplete('File Saved: $outputPath');
        }else if(streamedResponse.statusCode == 500){
          onDownloadComplete('Incorrect Password');
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


  static MediaType _getMediaTypeFromExtension(String filePath) {
    final extension = path.extension(filePath).toLowerCase();

    switch (extension) {
      case '.pdf':
        return MediaType('application', 'pdf');
      case '.doc':
        return MediaType('application', 'msword');
      case '.docx':
        return MediaType('application', 'vnd.openxmlformats-officedocument.wordprocessingml.document');
      case '.ppt':
        return MediaType('application', 'vnd.ms-powerpoint');
      case '.pptx':
        return MediaType('application', 'vnd.openxmlformats-officedocument.presentationml.presentation');
      case '.xls':
        return MediaType('application', 'vnd.ms-excel');
      case '.xlsx':
        return MediaType('application', 'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      default:
        return MediaType('application', 'octet-stream'); // Fallback for unknown types
    }
  }

  static Future<void> convertPdfToWordWithProgress({
    required String filePath,
    required String fileFormat,
    required ValueNotifier<Map<String,dynamic>> progress,
    required void Function(String? outputPath) onDownloadComplete,
  }) async {
    final uri = Uri.https(APIUrl.baseUrl, APIUrl.pdfToWord);
    final file = File(filePath);
    final fileLength = await file.length();

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({'accept': '*/*'})
      ..fields['outputFormat'] = fileFormat;

    final fileStream = http.ByteStream(
      _trackUploadProgress(file.openRead(), fileLength, fileLength,progress),
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
        'message':'Converting to Image...'
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


  static Future<void> addWatermarkToPDFWithProgress({
    required String filePath,
    required String watermarkType,
    required String watermarkText,
    required String watermarkImage,
    required String fontSize,
    required String rotation,
    required String width_spacer,
    required String height_spacer,
    required String opacity,
    required String converToImage,
    required String watermarkColor,
    required String alphabet,
    required ValueNotifier<Map<String, dynamic>> progress,
    required void Function(String? outputPath) onDownloadComplete,
  }) async {
    final uri = Uri.https(APIUrl.baseUrl, APIUrl.addWatermark);

    final pdfFile = File(filePath);
    if (!pdfFile.existsSync()) {
      onDownloadComplete('Invalid PDF file path!');
      return;
    }
    final pdfFileLength = await pdfFile.length();

    // Optional watermark image
    File? watermarkImageFile;
    int imageFileLength = 0;
    if (watermarkType == 'image') {
      watermarkImageFile = File(watermarkImage);
      if (!watermarkImageFile.existsSync()) {
        onDownloadComplete('Invalid watermark image file path!');
        return;
      }
      imageFileLength = await watermarkImageFile.length();
    }

    final int totalLength = pdfFileLength + (imageFileLength);

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({'accept': '*/*'})
      ..fields['watermarkText'] = watermarkText
      ..fields['watermarkType'] = watermarkType
      ..fields['alphabet'] = alphabet
      ..fields['fontSize'] = fontSize
      ..fields['rotation'] = rotation
      ..fields['opacity'] = opacity
      ..fields['widthSpacer'] = width_spacer
      ..fields['heightSpacer'] = height_spacer
      ..fields['customColor'] = watermarkColor
      ..fields['convertPDFToImage'] = converToImage;

    // Track PDF upload
    final pdfStream = http.ByteStream(
      _trackUploadProgress(pdfFile.openRead(), pdfFileLength, totalLength, progress, isPDF: true),
    );

    final pdfMultipartFile = http.MultipartFile(
      'fileInput',
      pdfStream,
      pdfFileLength,
      filename: pdfFile.path.split('/').last,
      contentType: MediaType('application', 'pdf'),
    );

    request.files.add(pdfMultipartFile);

    // Add watermark image if applicable
    if (watermarkType == 'image' && watermarkImageFile != null) {
      final imageStream = http.ByteStream(
        _trackUploadProgress(watermarkImageFile.openRead(), imageFileLength, totalLength, progress, isPDF: false),
      );

      final imageMultipartFile = http.MultipartFile(
        'watermarkImage',
        imageStream,
        imageFileLength,
        filename: watermarkImageFile.path.split('/').last,
        contentType: MediaType('image', watermarkImage.split('.').last),
      );

      request.files.add(imageMultipartFile);
    }

    try {
      progress.value = {
        'progress': 0.5,
        'message': 'Converting to Image...',
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
          print('Server did not respond: status code: ${streamedResponse.statusCode}');
          onDownloadComplete('Something went wrong! Please try again');
        }
      } catch (e) {
        print('Exception: ${e.toString()}');
        onDownloadComplete('Server timeout or did not respond!');
      }
    } catch (e) {
      onDownloadComplete('Something went wrong! Please try again');
      print('Exception during upload/download: $e');
    }
  }


  static Future<void> compressedPDF({
    required String filePath,
    required String optimizeLevel,
    required String expectedOutputSize,
    required String linearize,
    required String normalize,
    required String grayscale,
    required ValueNotifier<Map<String, dynamic>> progress,
    required void Function(String? outputPath) onDownloadComplete,
  }) async {
    final uri = Uri.https(APIUrl.baseUrl, APIUrl.compressPDF);

    final pdfFile = File(filePath);
    if (!pdfFile.existsSync()) {
      onDownloadComplete('Invalid PDF file path!');
      return;
    }
    final int totalLength = await pdfFile.length();


    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({'accept': '*/*'})
      ..fields['optimizeLevel'] = optimizeLevel
      ..fields['expectedOutputSize'] = expectedOutputSize
      ..fields['linearize'] = linearize
      ..fields['normalize'] = normalize
      ..fields['grayscale'] = grayscale;

    // Track PDF upload
    final pdfStream = http.ByteStream(
      _trackUploadProgress(pdfFile.openRead(), totalLength, totalLength, progress, isPDF: true),
    );

    final pdfMultipartFile = http.MultipartFile(
      'fileInput',
      pdfStream,
      totalLength,
      filename: pdfFile.path.split('/').last,
      contentType: MediaType('application', 'pdf'),
    );

    request.files.add(pdfMultipartFile);

    try {
      progress.value = {
        'progress': 0.5,
        'message': 'Converting to Image...',
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
          print('Server did not respond: status code: ${streamedResponse.statusCode}');
          onDownloadComplete('Something went wrong! Please try again');
        }
      } catch (e) {
        print('Exception: ${e.toString()}');
        onDownloadComplete('Server timeout or did not respond!');
      }
    } catch (e) {
      onDownloadComplete('Something went wrong! Please try again');
      print('Exception during upload/download: $e');
    }
  }


  static Future<void> signPDF({
    required String filePath,
    required String pageNumbers,
    required String signType,
    required String signText,
    required String signImage,
    required String alphabet,
    required String fontSize,
    required String rotation,
    required String opacity,
    required String position,
    required String overrideX,
    required String overrideY,
    required String customMargin,
    required String customColor,
    required ValueNotifier<Map<String, dynamic>> progress,
    required void Function(String? outputPath) onDownloadComplete,
  })async {
   final uri = Uri.https(APIUrl.baseUrl, APIUrl.signPDF);

   final pdfFile = File(filePath);
   if (!pdfFile.existsSync()) {
     onDownloadComplete('Invalid PDF file path!');
     return;
   }
   final pdfFileLength = await pdfFile.length();

   // Optional watermark image
   File? signImageFile;
   int imageFileLength = 0;
   if ( signType== 'image') {
     signImageFile = File(signImage);
     if (!signImageFile.existsSync()) {
       onDownloadComplete('Invalid image file path!');
       return;
     }
     imageFileLength = await signImageFile.length();
   }

   final int totalLength = pdfFileLength + (imageFileLength);

   final request = http.MultipartRequest('POST', uri)
     ..headers.addAll({'accept': '*/*'})
     ..fields['pageNumbers'] = pageNumbers
     ..fields['stampType'] = signType
     ..fields['alphabet'] = alphabet
     ..fields['fontSize'] = fontSize
     ..fields['rotation'] = rotation
     ..fields['opacity'] = opacity
     ..fields['stampText'] = signText
     ..fields['position'] = position
     ..fields['overrideX'] = overrideX
     ..fields['overrideY'] = overrideY
   ..fields['customMargin'] = customMargin
   ..fields['customColor'] = customColor;

   // Track PDF upload
   final pdfStream = http.ByteStream(
     _trackUploadProgress(pdfFile.openRead(), pdfFileLength, totalLength, progress, isPDF: true),
   );

   final pdfMultipartFile = http.MultipartFile(
     'fileInput',
     pdfStream,
     pdfFileLength,
     filename: pdfFile.path.split('/').last,
     contentType: MediaType('application', 'pdf'),
   );

   request.files.add(pdfMultipartFile);

   // Add watermark image if applicable
   if (signType == 'image' && signImageFile != null) {
     final imageStream = http.ByteStream(
       _trackUploadProgress(signImageFile.openRead(), imageFileLength, totalLength, progress, isPDF: false),
     );

     final imageMultipartFile = http.MultipartFile(
       'stampImage',
       imageStream,
       imageFileLength,
       filename: signImageFile.path.split('/').last,
       contentType: MediaType('image', signImage.split('.').last),
     );

     request.files.add(imageMultipartFile);
   }

   try {
     progress.value = {
       'progress': 0.5,
       'message': 'Converting to Image...',
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
         print('Server did not respond: status code: ${streamedResponse.statusCode}');
         onDownloadComplete('Something went wrong! Please try again');
       }
     } catch (e) {
       print('Exception: ${e.toString()}');
       onDownloadComplete('Server timeout or did not respond!');
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