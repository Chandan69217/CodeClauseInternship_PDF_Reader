import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/get_file_details.dart';
import 'package:sizing/sizing.dart';

import '../utilities/callbacks.dart';
import '../utilities/color.dart';

void showRenameWidget(
    {required BuildContext home_context, required Data data,required OnRenamed onRenamed}) {
  showModalBottomSheet(
      context: home_context,
      isScrollControlled: true,
      builder: (context) {
        return _BottomSheetUI(
          data: data,
          onRenamed: onRenamed,
        );
      });
}

// ignore: must_be_immutable
class _BottomSheetUI extends StatefulWidget {
  Data data;
  OnRenamed? onRenamed;
  _BottomSheetUI({required this.data,this.onRenamed});
  @override
  State<_BottomSheetUI> createState() => _State();
}

class _State extends State<_BottomSheetUI> {
  TextEditingController _controller = TextEditingController();
  TextSelectionControls? textSelectionControls;
  @override
  void initState() {
    super.initState();
    _controller.text = widget.data.fileName;
    _controller.selection = TextSelection(baseOffset: 0, extentOffset: widget.data.fileName.split('.').first.length);
  }
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
          left: 24.ss, right: 24.ss, top: 15.ss, bottom: bottomInset + 20.ss),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
              contentPadding: EdgeInsets.zero,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    'assets/icons/close_icon.png',
                    width: 25.ss,
                    height: 25.ss,
                  )),
              title: Text(
                'Rename',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                  onPressed: renameFile,
                  icon: Image.asset(
                    'assets/icons/tick_icon.png',
                    width: 25.ss,
                    height: 25.ss,
                  ))),
          SizedBox(
            height: 20.ss,
          ),
          TextField(
            maxLines: 1,
            autofocus: true,
            cursorHeight: 20.ss,
            controller: _controller,
            cursorColor: ColorTheme.RED,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8.ss),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorTheme.RED)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorTheme.RED)),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                      });
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: ColorTheme.BLACK.withOpacity(0.5),
                    )),
              hintText: 'File name',
              hintStyle: TextStyle(color: ColorTheme.BLACK.withOpacity(0.4))
            ),
          ),
        ],
      ),
    );
  }

  void renameFile()async{
    String newFileName = _controller.text;
    Directory fileDir = widget.data.file.parent;
    File newFile = File('${fileDir.path}/$newFileName');
    try{
      if(await widget.data.file.exists()){
        File file = await widget.data.file.rename(newFile.path);
        String fileDetails = await getFileDetails(newFile);
        Data newData = Data(file: file, fileName: newFileName, fileType: newFileName.split('.').last, details: fileDetails, filePath: newFile.path);
        widget.onRenamed!(newData);
        Navigator.pop(context);
      }
    }catch(exception,track){
      print('${exception.toString()} : ${track.toString()}');
    }
    
    
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
