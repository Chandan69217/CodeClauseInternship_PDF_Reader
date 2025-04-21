import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pdf_reader/api/stirling_pdf.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/widgets/custom_linearprogress_indicator/CustomLinearProgressIndicator.dart';


class AddWatermarkScreen extends StatefulWidget {
  @override
  State<AddWatermarkScreen> createState() => _WatermarkFormScreenState();
}

class _WatermarkFormScreenState extends State<AddWatermarkScreen> {
  PlatformFile? _selectedFile;
  PlatformFile? watermarkImage;
  bool _isLoading = false;
  String watermarkType = 'text'; // or 'image'
  String watermarkText = '';
  String alphabet = 'roman';
  double fontSize = 30;
  double rotation = 60;
  double opacity = 0.5;
  int widthSpacer = 50;
  int heightSpacer = 50;
  String customColor = '#d3d3d3';
  bool convertToImage = false;
  ValueNotifier<Map<String,dynamic>> _progress = ValueNotifier<Map<String,dynamic>>({
    'progress' : 0.0,
    'message' : 'Uploading image....'
  });

  void _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
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

  void pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      final file = result.files.first;
      setState(() {
        watermarkImage = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Watermark PDF")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
            
                  GestureDetector(
                    onTap: _pickPDF,
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
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Convert to Image"),
                    value: convertToImage,
                    onChanged: (val) => setState(() => convertToImage = val),
                  ),

                  const SizedBox(height: 16),

                  _buildDropdown('Watermark Type', ['text','image'],watermarkType, (value) => setState(() => watermarkType = value!)),
            
                  const SizedBox(height: 16),
            
                  if (watermarkType == 'text')
                    _buildTextField('Watermark Text', watermarkText, (val) => watermarkText = val,)
                  else
                    GestureDetector(
                      onTap: pickImage,
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
                                  Icon(Icons.image_rounded,
                                      size: 48, color: isDark ? Colors.red[200] : Colors.redAccent),
                                  const SizedBox(height: 12),
                                  Text(
                                    watermarkImage != null
                                        ? watermarkImage!.name
                                        : "Tap to select Image",
                                    style:Theme.of(context).textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (watermarkImage != null)
                                    Text(
                                      'Size: ${(watermarkImage!.size / 1024).toStringAsFixed(2)} KB',
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
            
                  _buildTextField('font Size',fontSize.toString(), (val) => fontSize = double.tryParse(val) ?? 30),
            
                  const SizedBox(height: 16),
            
                  _buildTextField('Rotation', rotation.toString(), (val) => rotation = double.tryParse(val) ?? 60),
            
                  const SizedBox(height: 16),
            
                  _buildTextField('Width Spacer',  widthSpacer.toString(), (val) => widthSpacer = int.tryParse(val) ?? 50,),
            
                  const SizedBox(height: 16),
            
                  _buildTextField('Height Spacer',heightSpacer.toString() , (val) => heightSpacer = int.tryParse(val) ?? 50,),

                  const SizedBox(height: 16),

                  Text(
                    'Opacity: ${opacity.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                  Slider(
                    value: opacity,
                    activeColor: ColorTheme.PRIMARY,
                    onChanged: (val) => setState(() => opacity = val),
                    min: 0.0,
                    max: 1.0,
                    divisions: 100,
                    label: opacity.toStringAsFixed(2),
                  ),


                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Watermark Color',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: _showColorPicker,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _hexToColor(customColor),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: _isLoading
                  ?  CustomLinearProgressBar(progress: _progress)
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  key: const ValueKey('submit'),
                  icon: const Icon(Icons.add),
                  label: const Text("Add Watermark"),
                  onPressed: _handleAddWatermark,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  void _showColorPicker() {
    Color pickerColor = _hexToColor(customColor);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick Watermark Color',style: Theme.of(context).textTheme.bodyMedium,),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              displayThumbColor: true,
              hexInputBar: true,
              
              onColorChanged: (color) {
                pickerColor = color;
              },
              enableAlpha: false,
              labelTypes: const [],
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Select'),
              style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12.0))
              ),
              onPressed: () {
                setState(() {
                  customColor = _colorToHex(pickerColor);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex'; // add alpha if missing
    return Color(int.parse(hex, radix: 16));
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


  Future<void> _handleAddWatermark() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a PDF file')),
      );
      return;
    }

    if (watermarkType == 'image' && watermarkImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a watermark image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    await StirlingApiService.addWatermarkToPDFWithProgress(
      filePath: _selectedFile!.path!,
      watermarkType: watermarkType,
      watermarkText: watermarkText,
      watermarkImage: watermarkImage?.path ?? '',
      fontSize: fontSize.toString(),
      rotation: rotation.toString(),
      width_spacer: widthSpacer.toString(),
      height_spacer: heightSpacer.toString(),
      opacity: opacity.toString(),
      converToImage: convertToImage.toString(),
      watermarkColor: customColor,
      alphabet: alphabet,
      progress: _progress,
      onDownloadComplete: (outputPath) {
        setState(() => _isLoading = false);

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
          ),
        );
      },
    );
  }



}
