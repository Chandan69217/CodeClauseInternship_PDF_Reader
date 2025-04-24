import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_reader/api/stirling_pdf.dart';
import 'package:pdf_reader/widgets/custom_linearprogress_indicator/CustomLinearProgressIndicator.dart';

class CompressPDF extends StatefulWidget {
  @override
  _CompressPDFState createState() => _CompressPDFState();
}

class _CompressPDFState extends State<CompressPDF> {
  PlatformFile? _selectedFile;
  int optimizeLevel = 1;
  String expectedOutputSize = '';
  bool linearize = false;
  bool normalize = false;
  bool grayscale = false;
  bool _isLoading = false;
  ValueNotifier<Map<String,dynamic>> _progress = ValueNotifier<Map<String,dynamic>>({
    'progress': 0.0,
    'message' : 'file uploading..'
  });



  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
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

    await StirlingApiService.compressedPDF(
        filePath: _selectedFile!.path!,
        optimizeLevel: optimizeLevel.toString(),
        expectedOutputSize: expectedOutputSize.toString(),
        linearize: linearize.toString(),
        normalize: normalize.toString(),
        grayscale: grayscale.toString(),
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compress PDF')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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

                    Text('Optimize Level: $optimizeLevel'),
                    Slider(
                      value: optimizeLevel.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: optimizeLevel.toString(),
                      onChanged: (value) {
                        setState(() {
                          optimizeLevel = value.toInt();
                        });
                      },
                    ),
                    _buildTextField('Expected Output Size (e.g., 100MB, 25KB)', '', (value) => expectedOutputSize = value),

                    SwitchListTile(
                      title: Text("Linearize PDF (Faster Web Viewing)"),
                      value: linearize,
                      onChanged: (value) => setState(() => linearize = value),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text("Normalize PDF Content"),
                      value: normalize,
                      onChanged: (value) => setState(() => normalize = value),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text("Convert to Grayscale"),
                      value: grayscale,
                      onChanged: (value) => setState(() => grayscale = value),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
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
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Compressed PDF"),
                  onPressed: _submit,
                ),
              ),
            ),
          ],
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
