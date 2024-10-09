import 'package:flutter/cupertino.dart';
import 'package:pdf_reader/utilities/color.dart';

class BookmarkScreen extends StatefulWidget {
  BookmarkScreen._();
  factory BookmarkScreen(){
    return BookmarkScreen._();
  }
  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(color: ColorTheme.PRIMARY,);
  }
}
