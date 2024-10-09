import 'package:flutter/cupertino.dart';
import 'package:pdf_reader/utilities/color.dart';

class ToolsScreen extends StatefulWidget {
  ToolsScreen._();
  factory ToolsScreen(){
    return ToolsScreen._();
  }

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(color: ColorTheme.RED,);
  }
}
