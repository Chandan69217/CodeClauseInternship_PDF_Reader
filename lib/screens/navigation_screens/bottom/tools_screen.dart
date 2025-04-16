import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf_reader/all_tools/convert_tools/pdf_to_image.dart';
import 'package:pdf_reader/screens/selection_screen.dart';
import 'package:pdf_reader/utilities/color_theme.dart';

class ToolsScreen extends StatefulWidget {
  ToolsScreen._();
  factory ToolsScreen() {
    return ToolsScreen._();
  }

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 14),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               _convert(),
              SizedBox(height: 10.0,),
              _edit(),
              _manage()
            ],
          ),
        ),
      ),
    );
  }

  Widget _convert() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 120,),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              'Convert',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            flex: 5,
            child: GridView.count(
                crossAxisCount: 4,
                physics: NeverScrollableScrollPhysics(),
                addRepaintBoundaries: true,
                crossAxisSpacing: 0, // Horizontal spacing
                mainAxisSpacing: 0,
                children: <Widget>[
              _items(iconData: Icons.picture_as_pdf_rounded, label:'PDF to Image',onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PdfToImageConverterScreen() ));
              }),
              _items(iconData: Icons.document_scanner, label: 'Scan to PDF',onTap: _message),
              _items(iconData: Icons.wordpress_rounded, label: 'Word to PDF',onTap: _message),
              _items(iconData: Icons.image_rounded, label: 'Image to PDF',onTap: _message),
            ]),
          )
        ],
      ),
    );
  }

  Widget _edit() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 240),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              'Edit',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: GridView.count(
                crossAxisCount: 4,
                addRepaintBoundaries: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 0, // Horizontal spacing
                mainAxisSpacing: 0,
                children: <Widget>[
                  _items(iconData: Icons.account_balance_wallet_rounded, label: 'Annotate',onTap: _message),
                  _items(iconData: Icons.follow_the_signs, label: 'Sign',onTap: _message),
                  _items(iconData: Icons.picture_as_pdf_rounded, label: 'Merge PDF',onTap: _message),
                  _items(iconData: Icons.splitscreen_outlined, label: 'Split PDF',onTap: _message),
                  _items(iconData: Icons.add_box_sharp, label: 'Add Text',onTap: _message),
                ]),
          )
        ],
      ),
    );
  }

  Widget _manage(){
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 120),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // SizedBox(height: 8.0,),
          Expanded(
            flex: 1,
            child: Text(
              'Manage',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: GridView.count(
                crossAxisCount: 4,
                // crossAxisSpacing: 10,
                addRepaintBoundaries: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 0, // Horizontal spacing
                mainAxisSpacing: 0,
                children: <Widget>[
                  _items(iconData: Icons.insert_drive_file_sharp, label: 'Import Files',onTap: _message),
                  _items(iconData: Icons.print, label: 'Print PDF',onTap:()=> Navigator.push(context,MaterialPageRoute(builder: (context)=> SelectionScreen()))),
                  _items(iconData: Icons.lock, label: 'Lock PDF',onTap: _message),
                  _items(iconData: Icons.lock_open_outlined, label: 'Unlock PDF',onTap: _message),
                ]),
          )
        ],
      ),
    );
  }

  Widget _items({required IconData iconData, required String label,required VoidCallback onTap }) {
    return InkWell(
      overlayColor: WidgetStatePropertyAll(Theme.of(context).brightness == Brightness.dark?Colors.grey:ColorTheme.PRIMARY),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark  ?ColorTheme.BLACK: ColorTheme.WHITE,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Icon(iconData),
            ),
          ),
          SizedBox(height: 8,),
          Text(label,style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11,fontWeight: FontWeight.w500),)
        ],
      ),
    );
  }


  void _message(){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text('work in process for this. please stay connected.'),)));
  }
}
