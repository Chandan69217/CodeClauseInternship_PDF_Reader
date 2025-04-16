import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as path;

class SaveFiles {
  SaveFiles._();
  static final _externalDir = Directory('/storage/emulated/0/Download/PDF Reader');

  static Future<String?> saveToDownloads(StreamedResponse streamedResponse) async {

    final contentType = streamedResponse.headers['content-type'];
    final contentDisposition = streamedResponse.headers['content-disposition'];

    final bytes = await streamedResponse.stream.toBytes();

    String extension = 'bin';
    String filename = 'output_file';

    if (contentDisposition != null && contentDisposition.contains('filename=')) {
      final extractedName = contentDisposition.split('filename=').last.replaceAll('"', '');
      filename = extractedName;
      extension = path.extension(extractedName).replaceFirst('.', '');
    } else if (contentType != null) {
      extension = _getExtensionFromContentType(contentType);
    }

    Directory downloadsDir;
    if (Platform.isAndroid) {
      if (!(await _externalDir.exists())) {
        await _externalDir.create(recursive: true);
      }
      downloadsDir = _externalDir;
    } else {
      downloadsDir = Directory(await ExternalPath.DIRECTORY_DOWNLOADS);
    }

    final outputPath = path.join(downloadsDir.path, '$filename');
    final file = File(outputPath);
    await file.writeAsBytes(bytes);
    return outputPath;
  }

  static String _getExtensionFromContentType(String contentType) {
    final Map<String, String> typeMap = {
      'zip': 'zip',
      'jpeg': 'jpeg',
      'jpg': 'jpg',
      'png': 'png',
      'webp': 'webp',
    };

    for (final entry in typeMap.entries) {
      if (contentType.contains(entry.key)) {
        return entry.value;
      }
    }

    return 'bin';
  }


}
