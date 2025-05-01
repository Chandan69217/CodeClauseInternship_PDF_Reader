import 'dart:typed_data';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

class PdfAnnotateScreen extends StatefulWidget {
  const PdfAnnotateScreen({Key? key}) : super(key: key);

  @override
  _PdfAnnotateScreenState createState() => _PdfAnnotateScreenState();
}

class _PdfAnnotateScreenState extends State<PdfAnnotateScreen> {


  PdfViewerController _pdfViewerController = PdfViewerController();
  Uint8List? _pdfBytes;
  PlatformFile? _selectedFile;


  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null) {
      _selectedFile = result.files.first;
      final ext = _selectedFile!.extension??'';
      if(ext.contains('pdf')){
        setState(() {
          _pdfBytes = _selectedFile!.bytes;
        });
      }else{
        _showSnackBar('Please select pdf file');
      }
    }
  }


  Future<void> saveAnnotatedPdf() async {
    if (_pdfBytes == null) {
      _showSnackBar('No PDF selected');
      return;
    }

    final _externalDir = Directory('/storage/emulated/0/Download/PDF Reader');

    Directory downloadsDir;
    if (Platform.isAndroid) {
      if (!(await _externalDir.exists())) {
        await _externalDir.create(recursive: true);
      }
      downloadsDir = _externalDir;
    } else {
      downloadsDir = Directory(await ExternalPath.DIRECTORY_DOWNLOAD);
    }

    final outputPath = path.join(downloadsDir.path, '${_selectedFile!.name}');
    final file = File(outputPath);
    final bytes = await _pdfViewerController.saveDocument();
    await file.writeAsBytes(bytes);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Done'),
        content: Text(outputPath),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  _showSnackBar(String label) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label)));
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Annotator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: _pickPDF,
          ),
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: saveAnnotatedPdf,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    if (_pdfBytes != null)
                      SfPdfViewer.memory(
                        _pdfBytes!,
                        controller: _pdfViewerController,
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GestureDetector(
                          onTap: _pickPDF,
                          child: Builder(
                            builder: (context) {
                              final isDark =
                                  Theme.of(context).brightness == Brightness.dark;
                              return Container(
                                height: 160,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey.shade900
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.grey.shade700
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.picture_as_pdf,
                                          size: 48,
                                          color: isDark
                                              ? Colors.red[200]
                                              : Colors.redAccent),
                                      const SizedBox(height: 12),
                                      Text(
                                        _selectedFile != null
                                            ? _selectedFile!.name
                                            : "Tap to select PDF file",
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (_selectedFile != null)
                                        Text(
                                          'Size: ${(_selectedFile!.size / 1024).toStringAsFixed(2)} KB',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          // Controls for annotating
        ],
      ),
    );
  }


}
