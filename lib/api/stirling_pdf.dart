import 'dart:async';
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
    required void Function(String? outputPath) onDownloadComplete,
  }) async {
    final uri = Uri.https(APIUrl.baseUrl, APIUrl.pdfToImage);

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({'accept': '*/*'})
      ..files.add(await http.MultipartFile.fromPath(
        'fileInput',
        filePath,
        contentType: MediaType('application', 'pdf'),
      ))
      ..fields['imageFormat'] = imageFormat
      ..fields['singleOrMultiple'] = singleOrMultiple
      ..fields['pageNumbers'] = pageNumber
      ..fields['colorType'] = colorType
      ..fields['dpi'] = dpi;

    try {
      final streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        var outputPath = await SaveFiles.saveToDownloads(streamedResponse);
        onDownloadComplete('File Saves: $outputPath');
      } else {
        onDownloadComplete('Somethings went wrong! Please try again');
      }
    } catch (e) {
      print('❌ Exception during download: $e');
    }
  }
}
