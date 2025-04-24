import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_reader/api/stirling_pdf.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/utilities/get_file_details.dart';
import 'package:pdf_reader/widgets/custom_linearprogress_indicator/CustomLinearProgressIndicator.dart';




class MergePDFScreen extends StatefulWidget {
  @override
  _MergePDFScreenState createState() => _MergePDFScreenState();
}

class _MergePDFScreenState extends State<MergePDFScreen> {
  List<File> selectedPDFS = [];
  String sortType = 'orderProvided';
  bool removeCertSign = true;
  bool _isLoading = false;
  List<String> _size = [];
  ValueNotifier<Map<String,dynamic>> _progress = ValueNotifier<Map<String,dynamic>>({
    'progress' : 0.0,
    'message' : 'Uploading image....'
  });

  final sortTypeOptions = ['orderProvided', 'byFileName', 'byDateModified'];


  void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    if (result != null) {
      selectedPDFS = result.paths.map((p) => File(p!)).toList();
      _size = await Future.wait(
        selectedPDFS.map((f) async {
          await FileDetails.fetch(f);
          return FileDetails.getSize();
        }),
      );
      setState(() {
      });
    }
  }



  void reorderImages(int oldIndex, int newIndex){
    setState(() {
      final pdfFile = selectedPDFS.removeAt(oldIndex);
      selectedPDFS.insert(newIndex, pdfFile);
      final fileSize = _size.removeAt(oldIndex);
      _size.insert(newIndex, fileSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text("merge PDF")),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PDF preview section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        color:  Colors.grey.withValues(alpha: 0.15),
                        child: selectedPDFS.isEmpty
                            ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.picture_as_pdf,size: 60,color: Colors.redAccent,),
                            SizedBox(height: 8.0,),
                            Center(child: Text("No PDF selected.")),
                          ],
                        )
                            : ReorderableListView.builder(
                          onReorder: reorderImages,
                          padding: const EdgeInsets.all(12),
                          itemBuilder: (BuildContext context, int index) {
                            FileDetails.fetch(selectedPDFS[index]);
                            return  Stack(
                                key: ValueKey(selectedPDFS[index].path),
                                children: [
                                  SizedBox(
                                    height: 300,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(2.0)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.picture_as_pdf,
                                                  size: 48, color: isDark ? Colors.red[200] : Colors.redAccent),
                                              const SizedBox(height: 12),
                                              Text(
                                                selectedPDFS[index].path.split('/').last,
                                                style:Theme.of(context).textTheme.bodyMedium,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                                Text(
                                                    'Size: ${_size[index]}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right:0,
                                    top: 0,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete, color: ColorTheme.RED, size: 25),
                                      onPressed: () {
                                        setState(() {
                                          selectedPDFS.removeAt(index);
                                          _size.removeAt(index);
                                        });
                                      },
                                      splashRadius: 24, // smaller splash radius
                                    ),
                                  ),
                                ]
                            );
                          },
                          itemCount: selectedPDFS.length,
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
                      const Text("Sort Type"),
                      DropdownButton<String>(
                        value: sortType,
                        items: sortTypeOptions.map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
                        onChanged: (value)async => {
                          setState(() => sortType = value!)
                        },
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Text("removeCertSign"),
                          Switch(
                            value: removeCertSign,
                            activeColor: ColorTheme.RED,
                            onChanged: (value) => setState(() => removeCertSign = value),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      ElevatedButton.icon(
                        onPressed: pickFiles,
                        style: Theme.of(context).iconButtonTheme.style!.copyWith(
                            foregroundColor: const WidgetStatePropertyAll(ColorTheme.WHITE),
                            padding: const WidgetStatePropertyAll( EdgeInsets.symmetric(horizontal: 12,))
                        ),
                        icon: const Icon(Icons.attach_file_sharp),
                        label: const Text("Pick PDF Files"),
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 12),

                  AnimatedSwitcher(duration:const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child:  _isLoading? CustomLinearProgressBar(progress: _progress):
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.merge_type),
                        onPressed: selectedPDFS.isNotEmpty ? () {
                          setState(() {
                            _isLoading = true;
                          });
                          StirlingApiService.MargePDF(files:selectedPDFS, sortType: sortType,removeCertSign: removeCertSign, progress: _progress, onDownloadComplete: (outputFile)async{
                            if(outputFile != null)
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Done'),
                                    content: Text(outputFile ?? 'Download complete'),
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
                          }) ;
                        } : null,
                        label: const Text("merge PDF"),
                      ),
                    ),
                  )

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}
