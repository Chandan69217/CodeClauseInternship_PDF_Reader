import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


class AddWatermarkScreen extends StatefulWidget {
  @override
  State<AddWatermarkScreen> createState() => _WatermarkFormScreenState();
}

class _WatermarkFormScreenState extends State<AddWatermarkScreen> {
  PlatformFile? _selectedFile;
  File? watermarkImage;
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
      watermarkImage = File(file.path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Watermark PDF")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            ElevatedButton(
              onPressed: _pickPDF,
              child: Text(_selectedFile == null ? "Select PDF File" : "Selected: ${_selectedFile!.path}"),
            ),

            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: watermarkType,
              decoration: InputDecoration(labelText: "Watermark Type"),
              items: ['text', 'image']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) => setState(() => watermarkType = value!),
            ),

            if (watermarkType == 'text')
              TextFormField(
                decoration: InputDecoration(labelText: "Watermark Text"),
                onChanged: (val) => watermarkText = val,
              )
            else
              ElevatedButton(
                onPressed: pickImage,
                child: Text(watermarkImage == null ? "Select Watermark Image" : "Image Selected"),
              ),

            DropdownButtonFormField<String>(
              value: alphabet,
              decoration: InputDecoration(labelText: "Alphabet"),
              items: ['roman', 'greek', 'cyrillic']
                  .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                  .toList(),
              onChanged: (value) => setState(() => alphabet = value!),
            ),

            TextFormField(
              decoration: InputDecoration(labelText: "Font Size"),
              keyboardType: TextInputType.number,
              initialValue: fontSize.toString(),
              onChanged: (val) => fontSize = double.tryParse(val) ?? 30,
            ),

            TextFormField(
              decoration: InputDecoration(labelText: "Rotation"),
              keyboardType: TextInputType.number,
              initialValue: rotation.toString(),
              onChanged: (val) => rotation = double.tryParse(val) ?? 60,
            ),

            TextFormField(
              decoration: InputDecoration(labelText: "Opacity (0.0 - 1.0)"),
              keyboardType: TextInputType.number,
              initialValue: opacity.toString(),
              onChanged: (val) => opacity = double.tryParse(val) ?? 0.5,
            ),

            TextFormField(
              decoration: InputDecoration(labelText: "Width Spacer"),
              keyboardType: TextInputType.number,
              initialValue: widthSpacer.toString(),
              onChanged: (val) => widthSpacer = int.tryParse(val) ?? 50,
            ),

            TextFormField(
              decoration: InputDecoration(labelText: "Height Spacer"),
              keyboardType: TextInputType.number,
              initialValue: heightSpacer.toString(),
              onChanged: (val) => heightSpacer = int.tryParse(val) ?? 50,
            ),

            TextFormField(
              decoration: InputDecoration(labelText: "Custom Color (Hex)"),
              initialValue: customColor,
              onChanged: (val) => customColor = val,
            ),

            SwitchListTile(
              title: Text("Convert to Image"),
              value: convertToImage,
              onChanged: (val) => setState(() => convertToImage = val),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle watermark submission
              },
              child: const Text("Apply Watermark"),
            ),
          ],
        ),
      ),
    );
  }
}
