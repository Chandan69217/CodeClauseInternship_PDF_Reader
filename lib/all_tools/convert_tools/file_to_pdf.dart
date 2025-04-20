import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_reader/api/stirling_pdf.dart';
import 'package:pdf_reader/widgets/custom_linearprogress_indicator/CustomLinearProgressIndicator.dart';
import 'package:pdf_reader/widgets/sticky_snackbar/show_snackbar.dart';

class FileToPdfScreen extends StatefulWidget {
  @override
  _FileToPdfScreenState createState() => _FileToPdfScreenState();
}

class _FileToPdfScreenState extends State<FileToPdfScreen> {
  PlatformFile? _selectedFile;
  ValueNotifier<Map<String, dynamic>> _progress =
  ValueNotifier<Map<String, dynamic>>(
      {'progress': 0.0, 'message': 'file uploading..'});
  bool _isLoading = false;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
    );

    if (result != null) {
      final file = result.files.first;
      final fileExtension = file.extension?.toLowerCase();

      setState(() {
        _selectedFile = file;
      });
    }
  }

  void _submit() async{
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a file")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    await StirlingApiService.convertFileToPDF(path: _selectedFile!.path!,progress: _progress, onDownloadComplete: (outputPath)async{
      if(outputPath != null){
        await ShowStickySnackbar.showStickySnackBarAndWait(context, outputPath);
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File to PDF')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickFile,
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
                          Icon(Icons.file_upload,
                              size: 48,
                              color: isDark
                                  ? Colors.red[200]
                                  : Colors.redAccent),
                          const SizedBox(height: 12),
                          Text(
                            _selectedFile != null
                                ? _selectedFile!.name
                                : "Tap to select File",
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
            const SizedBox(height: 24),
            const Spacer(),
            AnimatedSwitcher(duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child:  _isLoading?CustomLinearProgressBar(progress: _progress):SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Convert to PDF'),
                  onPressed: _submit,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


}
