import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pdf_reader/api/stirling_pdf.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/widgets/custom_linearprogress_indicator/CustomLinearProgressIndicator.dart';
import 'package:pdf_reader/widgets/sticky_snackbar/show_snackbar.dart';



class ImageToPdfScreen extends StatefulWidget {
  @override
  _ImageToPdfScreenState createState() => _ImageToPdfScreenState();
}

class _ImageToPdfScreenState extends State<ImageToPdfScreen> {
  List<File> selectedImages = [];
  String fitOption = 'fitDocumentToImage';
  String colorType = 'color';
  bool autoRotate = true;
  bool _isLoading = false;
  ValueNotifier<Map<String,dynamic>> _progress = ValueNotifier<Map<String,dynamic>>({
    'progress' : 0.0,
    'message' : 'Uploading image....'
  });

  final fitOptions = ['fillPage', 'fitDocumentToImage', 'maintainAspectRatio'];
  final colorOptions = ['color', 'grayscale', 'blackwhite'];

  void pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        selectedImages = result.paths.map((p) => File(p!)).toList();
      });
    }
  }

  Future<File?> _cropImage(File pickedFile) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          statusBarColor: isDark? Colors.black:ColorTheme.PRIMARY,
          toolbarColor: isDark? Colors.black:Colors.orangeAccent,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          backgroundColor: isDark? Colors.black:ColorTheme.WHITE
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );

    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }


  void reorderImages(int oldIndex, int newIndex) {
    setState(() {
      final image = selectedImages.removeAt(oldIndex);
      selectedImages.insert(newIndex, image);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text("Images to PDF")),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // image preview section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        color:  Colors.grey.withValues(alpha: 0.15),
                        child: selectedImages.isEmpty
                            ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.photo_library,size: 60,color: Colors.redAccent,),
                                SizedBox(height: 8.0,),
                                Center(child: Text("No images selected.")),
                              ],
                            )
                            : ReorderableListView.builder(
                          onReorder: reorderImages,
                          padding: const EdgeInsets.all(12),
                          itemBuilder: (BuildContext context, int index) {
                            return  Stack(
                                key: ValueKey(selectedImages[index].path),
                              children: [
                                SizedBox(
                                height: 300,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.0)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.file(
                                      selectedImages[index],
                                      fit: getBoxFit(fitOption),
                                      height: 200,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                              ),
                                Positioned(
                                  bottom: 8,
                                  left: 8,
                                  child: IconButton(
                                    style: Theme.of(context).iconButtonTheme.style!.copyWith(
                                        backgroundColor: WidgetStatePropertyAll(Colors.black.withValues(alpha: 0.6))
                                    ),
                                    icon: const Icon(Icons.crop, color: Colors.white, size: 20),
                                    onPressed: () async{
                                      final croppedFile = await _cropImage(selectedImages[index]);
                                      if(croppedFile!=null){
                                        setState(() {
                                          selectedImages[index] = croppedFile;
                                        });
                                      }
                                    },
                                    splashRadius: 24, // smaller splash radius
                                  ),
                                ),

                                Positioned(
                                    right:0,
                                  top: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: ColorTheme.RED, size: 25),
                                    onPressed: () {
                                      setState(() {
                                        selectedImages.removeAt(index);
                                      });
                                    },
                                    splashRadius: 24, // smaller splash radius
                                  ),
                                ),
                              ]
                            );
                          },
                          itemCount: selectedImages.length,
                        ),
                      ),
                    ),
                  ),
                ),
            
                // setting controls
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Fit Option"),
                      DropdownButton<String>(
                        value: fitOption,
                        items: fitOptions.map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
                        onChanged: (value) => setState(() => fitOption = value!),
                      ),
                      const SizedBox(height: 12),
            
                      const Text("Color Type"),
                      DropdownButton<String>(
                        value: colorType,
                        items: colorOptions.map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
                        onChanged: (value) => setState(() => colorType = value!),
                      ),
                      const SizedBox(height: 12),
            
                      Row(
                        children: [
                          const Text("Auto Rotate"),
                          Switch(
                            value: autoRotate,
                            activeColor: ColorTheme.RED,
                            onChanged: (value) => setState(() => autoRotate = value),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
            
                      ElevatedButton.icon(
                        onPressed: pickImages,
                        style: Theme.of(context).iconButtonTheme.style!.copyWith(
                          foregroundColor: const WidgetStatePropertyAll(ColorTheme.WHITE),
                          padding: const WidgetStatePropertyAll( EdgeInsets.symmetric(horizontal: 12,))
                        ),
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text("Pick Images"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _isLoading? CustomLinearProgressBar(progress: _progress):
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedImages.isNotEmpty ? () {
                        setState(() {
                          _isLoading = true;
                        });
                       StirlingApiService.convertImageToPDFWithProgress(files:selectedImages, fitOption: fitOption, colorType: colorType, autoRotate: autoRotate, progress: _progress, onDownloadComplete: (outputFile)async{
                         if(outputFile != null)
                         await ShowStickySnackbar.showStickySnackBarAndWait(context, outputFile);
                         setState(() {
                           _isLoading = false;
                         });
                       }) ;
                      } : null,
                      child: const Text("Convert to PDF"),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  BoxFit getBoxFit(String fitOption) {
    switch (fitOption) {
      case 'fillPage':
        return BoxFit.fill;
      case 'fitDocumentToPage':
        return BoxFit.cover;
      case 'maintainAspectRatio':
      default:
        return BoxFit.scaleDown;
    }
  }

}
