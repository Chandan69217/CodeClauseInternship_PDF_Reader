import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_reader/api/stirling_pdf.dart';
import 'package:pdf_reader/widgets/custom_linearprogress_indicator/CustomLinearProgressIndicator.dart';
import 'package:pdf_reader/widgets/sticky_snackbar/show_snackbar.dart';


class PDFToWordScreen extends StatefulWidget {
  const PDFToWordScreen({super.key});

  @override
  _PDFToWordScreenState createState() => _PDFToWordScreenState();
}

class _PDFToWordScreenState extends State<PDFToWordScreen> {
  PlatformFile? _selectedFile;
  String? _fileFormat = 'docx';
  bool _isLoading = false;

  ValueNotifier<Map<String,dynamic>> _progress = ValueNotifier<Map<String,dynamic>>({
    'progress': 0.0,
    'message' : 'file uploading..'
  });

  final List<String> _fileFormatsOptions = ['doc', 'docx', 'odt',];


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


  void _submit()async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a PDF file")),
      );
      return;
    }

    _progress.value = {
      'progress': 0.0,
      'message' : 'file uploading..'
    };
    setState(() {
      _isLoading = true;
    });

    await StirlingApiService.convertPdfToWordWithProgress(
        filePath: _selectedFile!.path!,
        fileFormat: _fileFormat!,
        progress: _progress,
        onDownloadComplete: (outputPath)async{
          if(outputPath != null){
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Done'),
                  content: Text(outputPath ?? 'Download complete'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ));
            setState(() {
              _isLoading = false;
            });
          }
        }
    );

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF to Word Converter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  GestureDetector(
                    onTap: _pickFile,
                    child: Builder(
                      builder: (context) {
                        final isDark = Theme.of(context).brightness == Brightness.dark;
                        return Container(
                          height: 160,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.picture_as_pdf,
                                    size: 48, color: isDark ? Colors.red[200] : Colors.redAccent),
                                const SizedBox(height: 12),
                                Text(
                                  _selectedFile != null
                                      ? _selectedFile!.name
                                      : "Tap to select PDF file",
                                  style:Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (_selectedFile != null)
                                  Text(
                                    'Size: ${(_selectedFile!.size / 1024).toStringAsFixed(2)} KB',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildDropdown("File Format",_fileFormatsOptions , _fileFormat, (val) => setState(() => _fileFormat = val)),

                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: _isLoading
                  ?  CustomLinearProgressBar(progress: _progress)
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  key: const ValueKey('submit'),
                  icon: const Icon(Icons.wordpress),
                  label: const Text("Convert PDF to Word"),
                  onPressed: _submit,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }



  Widget _buildDropdown(
      String label,
      List<String> items,
      String? value,
      Function(String?) onChanged,
      ) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: value,
              items: items
                  .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
                  .toList(),
              onChanged: onChanged,
              dropdownColor: isDark ? Colors.grey[900] : Colors.white,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: Colors.purple,
                      width: 1.2
                  ),
                ),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
          ],
        );
      },
    );
  }


}
