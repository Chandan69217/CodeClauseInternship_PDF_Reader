import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/api/stirling_pdf.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/widgets/custom_linearprogress_indicator/CustomLinearProgressIndicator.dart';
import 'package:pdf_reader/widgets/sticky_snackbar/show_snackbar.dart';

class LockPdfScreen extends StatefulWidget {
  @override
  _LockPdfScreenState createState() => _LockPdfScreenState();
}

class _LockPdfScreenState extends State<LockPdfScreen> {
  PlatformFile? _selectedFile;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ownerPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _ownerPasswordObscure = true;
  bool _userPasswordObscure = true;
  final GlobalKey<FormState> formState = GlobalKey();
  ValueNotifier<Map<String, dynamic>> _progress =
      ValueNotifier<Map<String, dynamic>>(
          {'progress': 0.0, 'message': 'file uploading..'});
  static const Map<String, bool> _unHandlesPermission = {
    'canAssembleDocument': true,
    'canExtractForAccessibility': true,
    'canPrintFaithful': true,
  };
  Map<String, bool> permissions = {
    'canExtractContent': true,
    'canFillInForm': true,
    'canModify': true,
    'canModifyAnnotations': true,
    'canPrint': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lock PDF')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
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
              const SizedBox(height: 16),
              Form(
                key: formState,
                child: StatefulBuilder(builder: (context, refresh) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _userPasswordObscure,
                        decoration: InputDecoration(
                            labelText: 'User Password',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  refresh(() {
                                    _userPasswordObscure =
                                        !_userPasswordObscure;
                                  });
                                },
                                icon: Icon(_userPasswordObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'User password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _ownerPasswordController,
                        obscureText: _ownerPasswordObscure,
                        decoration: InputDecoration(
                            labelText: 'Owner Password',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  refresh(() {
                                    _ownerPasswordObscure =
                                        !_ownerPasswordObscure;
                                  });
                                },
                                icon: Icon(_ownerPasswordObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Owner password is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 24),
              const Text('Permissions',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...permissions.keys.map((key) => SwitchListTile(
                    title: Text(key),
                    activeColor: ColorTheme.RED,
                    value: permissions[key]!,
                    onChanged: (val) {
                      setState(() => permissions[key] = val);
                    },
                  )),
              const SizedBox(height: 34),
              
              _isLoading?CustomLinearProgressBar(progress: _progress):SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.lock_outline),
                  label: const Text('Encrypt PDF'),
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a PDF file")),
      );
      return;
    }

    if (!formState.currentState!.validate()) {
      return;
    }

    final data = {
      'fileInput': _selectedFile!.path,
      'password': _passwordController.text,
      'ownerPassword': _ownerPasswordController.text,
      ...permissions,
      ..._unHandlesPermission
    };

    print('value on submit click : ${data.toString()}');

    _progress.value = {'progress': 0.0, 'message': 'file uploading..'};
    setState(() {
      _isLoading = true;
    });

    await StirlingApiService.lockPDF(
      data: data,
        progress: _progress,
        onDownloadComplete: (outputPath)async{
          if(outputPath != null){
            await ShowStickySnackbar.showStickySnackBarAndWait(context, outputPath);
            setState(() {
              _isLoading = false;
            });
          }
        }
    );
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
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
}
