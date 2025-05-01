import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pdf_reader/api/stirling_pdf.dart';
import 'package:pdf_reader/widgets/custom_linearprogress_indicator/CustomLinearProgressIndicator.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';



import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';




class StampFormScreen extends StatefulWidget {
  const StampFormScreen({super.key});

  @override
  State<StampFormScreen> createState() => _StampFormScreenState();
}

class _StampFormScreenState extends State<StampFormScreen> {
  PlatformFile? _selectedFile;
  String pageNumbers = 'all';
  String signType = 'text';
  String signText = '';
  PlatformFile? _stampImage;
  String alphabet = 'en';
  double fontSize = 12.0;
  double rotation = 0.0;
  double opacity = 1.0;
  int position = 0;
  double overrideX = -1;
  double overrideY = -1;
  String customMargin = '';
  Color customColor = Colors.black;
  bool _isLoading = false;
  ValueNotifier<Map<String, dynamic>> _progress =
      ValueNotifier<Map<String, dynamic>>(
          {'progress': 0.0, 'message': 'Uploading image....'});

  final TextEditingController _textController = TextEditingController();
  final TextEditingController _marginController = TextEditingController();
  final TextEditingController _pageController =
      TextEditingController(text: 'all');

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  void _submit() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a PDF file')),
      );
      return;
    }

    if (signType == 'image' && _stampImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a sign image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    await StirlingApiService.signPDF(
      filePath: _selectedFile!.path!,
      fontSize: fontSize.toString(),
      rotation: rotation.toString(),
      opacity: opacity.toString(),
      customColor: _colorToHex(customColor),
      alphabet: alphabet,
      progress: _progress,
      customMargin: customMargin,
      overrideX: overrideX.toString(),
      overrideY: overrideY.toString(),
      pageNumbers: pageNumbers,
      position: position.toString(),
      signImage: _stampImage != null ? _stampImage!.path!:'',
      signText: signText,
      signType: signType,
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

  Future<void> _pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true, allowMultiple: false);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _stampImage = result.files.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stamp PDF'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: _pageController,
                    decoration: const InputDecoration(
                        labelText: 'Page Numbers (e.g. 1,3,5-9, all)'),
                    onChanged: (value) => pageNumbers = value,
                  ),
                  const SizedBox(height: 16),
                  const Text('Stamp Type'),
                  Row(
                    children: [
                      Radio(
                        value: 'text',
                        groupValue: signType,
                        onChanged: (value) =>
                            setState(() => signType = value.toString()),
                      ),
                      const Text('Text'),
                      Radio(
                        value: 'image',
                        groupValue: signType,
                        onChanged: (value) =>
                            setState(() => signType = value.toString()),
                      ),
                      const Text('Image'),
                    ],
                  ),
                  if (signType == 'text') ...[
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(labelText: 'Sign Text'),
                      onChanged: (value) => signText = value,
                    ),
                  ] else ...[
                    GestureDetector(
                      onTap: _pickImage,
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
                                  Icon(Icons.photo,
                                      size: 48,
                                      color: isDark
                                          ? Colors.red[200]
                                          : Colors.redAccent),
                                  const SizedBox(height: 12),
                                  Text(
                                    _stampImage != null
                                        ? _stampImage!.name
                                        : "Tap to select Image Image",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration:
                              const InputDecoration(labelText: 'Font Size'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              fontSize = double.tryParse(value) ?? 12.0,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          decoration:
                              const InputDecoration(labelText: 'Rotation (°)'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              rotation = double.tryParse(value) ?? 0.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Opacity'),
                      Expanded(
                        child: Slider(
                          value: opacity,
                          onChanged: (value) => setState(() => opacity = value),
                          min: 0.0,
                          max: 1.0,
                        ),
                      ),
                      Text(opacity.toStringAsFixed(2)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                        labelText:
                            'Position 1-9 grid (1: bottom-left, 2: bottom-center, ..., 9: top-right)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => position = int.tryParse(value) ?? 5,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                              labelText: 'Override X (-1 if not used)'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              overrideX = double.tryParse(value) ?? -1,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                              labelText: 'Override Y (-1 if not used)'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              overrideY = double.tryParse(value) ?? -1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _marginController,
                    decoration:
                        const InputDecoration(labelText: 'Custom Margin'),
                    onChanged: (value) => customMargin = value,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Pick Custom Color:'),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () async {
                          Color? picked = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Pick Color'),
                              content: SingleChildScrollView(
                                child: BlockPicker(
                                  pickerColor: customColor,
                                  onColorChanged: (color) {
                                    setState(() {
                                      customColor = color;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: customColor,
                            border: Border.all(color: Colors.black),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                  icon: const Icon(Icons.draw_outlined),
                  label: const Text("Sign PDF"),
                  onPressed: _submit,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SignPDFScreen extends StatefulWidget {
  const SignPDFScreen({super.key});

  @override
  State<SignPDFScreen> createState() => _SignPDFScreenState();
}

class _SignPDFScreenState extends State<SignPDFScreen> {
  Uint8List? _signatureBytes;
  Offset _signatureOffset = const Offset(100, 100);
  double _signatureWidth = 180;
  double _signatureHeight = 80;
  PlatformFile? _selectedFile;
  String pageNumbers = 'all';
  String signType = 'text';
  String signText = '';
  PlatformFile? _stampImage;
  String alphabet = 'en';
  double fontSize = 12.0;
  double rotation = 0.0;
  double opacity = 1.0;
  int position = 0;
  double overrideX = -1;
  double overrideY = -1;
  String customMargin = '';
  Color customColor = Colors.black;
  bool _isLoading = false;
  ValueNotifier<Map<String, dynamic>> _progress =
  ValueNotifier<Map<String, dynamic>>(
      {'progress': 0.0, 'message': 'Uploading image....'});

  Future<void> _pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
  void _submit() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a PDF file')),
      );
      return;
    }

    if (signType == 'image' && _stampImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a sign image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    await StirlingApiService.signPDF(
      filePath: _selectedFile!.path!,
      fontSize: fontSize.toString(),
      rotation: rotation.toString(),
      opacity: opacity.toString(),
      customColor: _colorToHex(customColor),
      alphabet: alphabet,
      progress: _progress,
      customMargin: customMargin,
      overrideX: overrideX.toString(),
      overrideY: overrideY.toString(),
      pageNumbers: pageNumbers,
      position: position.toString(),
      signImage: _stampImage != null ? _stampImage!.path!:'',
      signText: signText,
      signType: signType,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign PDF"),
        actions: _selectedFile != null
            ? [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => SignaturePadDialog(
                        onDone: (signatureBytes) {
                          setState(() {
                            _signatureBytes = signatureBytes;
                          });
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.draw),
                )
              ]
            : null,
      ),
      body: Column(
        children: [
          if (_selectedFile == null)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
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
            ),
          if (_selectedFile != null)
            Expanded(
              child: Column(
                children: [
                  // PDF Preview + Draggable Signature
                  Expanded(
                    child: Stack(
                      children: [
                        SfPdfViewer.file(
                          File(_selectedFile!.path!),
                          canShowTextSelectionMenu: false,
                          enableTextSelection: false,
                        ),
                        _buildSignatureWidget(),
                      ],
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
                          icon: const Icon(Icons.draw_outlined),
                          label: const Text("Sign PDF"),
                          onPressed: _submit,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSignatureWidget() {
    return _signatureBytes == null
        ? const SizedBox()
        : Stack(
            children: [
              Positioned(
                left: _signatureOffset.dx,
                top: _signatureOffset.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _signatureOffset += details.delta;
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        width: _signatureWidth,
                        height: _signatureHeight,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.grey)),
                          child: Image.memory(
                            _signatureBytes!,
                            fit: BoxFit.fill,
                            width: _signatureWidth,
                            height: _signatureHeight,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _signatureBytes = null;
                            });
                          },
                          child: const Icon(
                            Icons.cancel,
                            size: 22,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              _signatureWidth += details.delta.dx;
                              _signatureHeight += details.delta.dy;
                              // Clamp to limits
                              _signatureWidth =
                                  _signatureWidth.clamp(60.0, 500.0);
                              _signatureHeight =
                                  _signatureHeight.clamp(30.0, 300.0);
                            });
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: Colors.grey),
                              shape: BoxShape.rectangle,
                            ),
                            child: const Icon(
                              Icons.open_in_full,
                              size: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}

class SignaturePadDialog extends StatefulWidget {
  final void Function(Uint8List signatureBytes) onDone;

  const SignaturePadDialog({super.key, required this.onDone});

  @override
  State<SignaturePadDialog> createState() => _SignaturePadDialogState();
}

class _SignaturePadDialogState extends State<SignaturePadDialog> {
  final GlobalKey<SfSignaturePadState> _signatureKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  final GlobalKey _textWidgetKey = GlobalKey();

  Color _selectedColor = Colors.black;
  bool _isDrawingMode = true;

  void _clear() {
    if (_isDrawingMode) {
      _signatureKey.currentState?.clear();
    } else {
      setState(() {
        _textController.clear();
      });
    }
  }

  Future<void> _done() async {
    Uint8List? resultBytes;

    if (_isDrawingMode) {
      final image = await _signatureKey.currentState?.toImage(pixelRatio: 3.0);
      final byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        resultBytes = byteData.buffer.asUint8List();
      }
    } else {
      RenderRepaintBoundary boundary = _textWidgetKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        resultBytes = byteData.buffer.asUint8List();
      }
    }

    if (resultBytes != null) {
      widget.onDone(resultBytes);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Signature'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildModeButton(true, "Draw"),
              const SizedBox(width: 8),
              _buildModeButton(false, "Text"),
            ],
          ),
          const SizedBox(height: 12),
          // Color palette
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildColorOption(Colors.black),
              const SizedBox(width: 8),
              _buildColorOption(Colors.blue),
              const SizedBox(width: 8),
              _buildColorOption(Colors.red),
            ],
          ),
          const SizedBox(height: 12),
          // Signature pad or Text input
          _isDrawingMode ? _buildSignaturePad() : _buildTextSignature(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _clear,
          child: const Text('Clear'),
        ),
        ElevatedButton(
          onPressed: _done,
          child: const Text('Done'),
        ),
      ],
    );
  }

  Widget _buildModeButton(bool isDrawMode, String label) {
    final bool isSelected = _isDrawingMode == isDrawMode;
    return SizedBox(
      height: 40.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade300,
          foregroundColor: isSelected ? Colors.white : Colors.black,
        ),
        onPressed: () {
          setState(() {
            _isDrawingMode = isDrawMode;
          });
        },
        child: Text(label),
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    final bool isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Colors.black, width: 3)
              : Border.all(color: Colors.grey.shade300, width: 1),
        ),
      ),
    );
  }

  Widget _buildSignaturePad() {
    return Container(
      height: 250,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: SfSignaturePad(
        key: _signatureKey,
        backgroundColor: Colors.transparent,
        strokeColor: _selectedColor,
        minimumStrokeWidth: 1.5,
        maximumStrokeWidth: 4.0,
      ),
    );
  }

  Widget _buildTextSignature() {
    return Column(
      children: [
        // Render pure text as image
        Container(
          color: Colors.transparent,
          child: RepaintBoundary(
            key: _textWidgetKey,
            child: Text(
              _textController.text,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: _selectedColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Text input field (only for typing, not for painting)
        TextField(
          controller: _textController,
          textAlign: TextAlign.center,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            hintText: "Type your signature",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
