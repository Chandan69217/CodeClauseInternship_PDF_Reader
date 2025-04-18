import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_reader/api/stirling_pdf.dart';
import 'package:pdf_reader/widgets/custom_linearprogress_indicator/CustomLinearProgressIndicator.dart';
import 'package:pdf_reader/widgets/sticky_snackbar/show_snackbar.dart';

class SplitPdfScreen extends StatefulWidget {
  @override
  _SplitPdfScreenState createState() => _SplitPdfScreenState();
}

class _SplitPdfScreenState extends State<SplitPdfScreen> {
  final _formKey = GlobalKey<FormState>();
  String _pageNumbers = 'all';
  PlatformFile? _selectedFile;
  ValueNotifier<Map<String, dynamic>> _progress =
  ValueNotifier<Map<String, dynamic>>(
      {'progress': 0.0, 'message': 'file uploading..'});
  bool _isLoading = false;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null) {
      final file = result.files.first;
      final fileExtension = file.extension?.toLowerCase();

      if (fileExtension == 'pdf') {
        setState(() {
          _selectedFile = file;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Only PDF files are allowed.')),
        );
      }
    }
  }

  void _submit() async{
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a PDF file")),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    await StirlingApiService.splitPDF(path: _selectedFile!.path!, pages: _pageNumbers, progress: _progress, onDownloadComplete: (outputPath)async{
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
      appBar: AppBar(title: const Text('Split PDF')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
              const SizedBox(height: 24),
              _buildTextField("Page Numbers (e.g. 1,3,5-9 or all)", _pageNumbers, (val) => _pageNumbers = val),
              const Spacer(),
              AnimatedSwitcher(duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child:  _isLoading?CustomLinearProgressBar(progress: _progress):SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.splitscreen),
                    label: const Text('Split PDF'),
                    onPressed: _submit,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildTextField(
      String label,
      String initialValue,
      Function(String) onChanged,
      ) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return TextFormField(
          initialValue: initialValue,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            labelText: label,
          ),
          onChanged: onChanged,
        );
      },
    );
  }

}
