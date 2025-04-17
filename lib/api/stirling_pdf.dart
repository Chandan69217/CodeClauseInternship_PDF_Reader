import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pdf_reader/api/api_urls.dart';
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
          onDownloadComplete('Something went wrong! Please try again');
        }
      } catch (e) {
        onDownloadComplete('Server timeout or did not response!');
      }
    } catch (e) {
      onDownloadComplete('Something went wrong! Please try again');
      print('Exception during upload/download: $e');
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
}
