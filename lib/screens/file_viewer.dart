import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore_for_file: must_be_immutable
class FileViewer extends StatefulWidget{
  String filePath;
  FileViewer({super.key, required this.filePath});

  @override
  State<StatefulWidget> createState() => _FileViewerState();

}


class _FileViewerState extends State<FileViewer> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }

}




class OfficeFileViewer extends StatefulWidget {
  final String fileUrl; // URL of the .docx, .pptx, .xlsx file

  const OfficeFileViewer({super.key, required this.fileUrl});

  @override
  State<OfficeFileViewer> createState() => _OfficeFileViewerState();
}

class _OfficeFileViewerState extends State<OfficeFileViewer> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadRequest(
        Uri.parse(
          "https://view.officeapps.live.com/op/embed.aspx?src=${Uri.encodeComponent(widget.fileUrl)}",
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Office File Viewer")),
      body: WebViewWidget(controller: _controller),
    );
  }
}