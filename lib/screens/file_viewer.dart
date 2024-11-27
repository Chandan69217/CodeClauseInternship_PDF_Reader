import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
