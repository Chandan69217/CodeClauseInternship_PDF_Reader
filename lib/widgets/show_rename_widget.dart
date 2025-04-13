import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf_reader/external_storage/read_storage.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/get_file_details.dart';
import '../utilities/callbacks.dart';
import '../utilities/color_theme.dart';



void showRenameWidget(
    {required BuildContext home_context,
    required Data data,
    required OnChanged onChanged}) {
  showModalBottomSheet(
      context: home_context,
      constraints: BoxConstraints(minWidth: MediaQuery.of(home_context).size.width),
      isScrollControlled: true,
      builder: (context) {
        return _BottomSheetUI(
          data: data,
          onChanged: onChanged,
        );
      });
}

// ignore: must_be_immutable
class _BottomSheetUI extends StatefulWidget {
  Data data;
  OnChanged? onChanged;
  _BottomSheetUI({required this.data, this.onChanged});
  @override
  State<_BottomSheetUI> createState() => _State();
}

class _State extends State<_BottomSheetUI> {
  TextEditingController _controller = TextEditingController();
  TextSelectionControls? textSelectionControls;
  bool _clearButtonVisibility = true;
  bool _isOkIconButtonEnable = true;
  @override
  void initState() {
    super.initState();
    _controller.text = widget.data.fileName;
    _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: widget.data.fileName.split('.').first.length);
    _controller.addListener(_listenTextChanges);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
          left: 24, right: 24, top: 15, bottom: bottomInset + 20),
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
                    'assets/icons/close_icon.webp',
                    width: 25,
                    height: 25,
                    color: Theme.of(context).brightness == Brightness.dark ? ColorTheme.WHITE:null,
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
                  onPressed: _isOkIconButtonEnable ? ()=> _renameFile(widget.data) : null,
                  icon: Image.asset(
                    'assets/icons/tick_icon.webp',
                    width: 25,
                    height: 25,
                    color: _isOkIconButtonEnable
                        ? Theme.of(context).brightness == Brightness.dark ? ColorTheme.WHITE:ColorTheme.BLACK
                        : ColorTheme.BLACK.withOpacity(0.5),
                  ))),
          SizedBox(
            height: 20,
          ),
          TextSelectionTheme(
            data: Theme.of(context).textSelectionTheme,
            child: TextField(
              maxLines: 1,
              autofocus: true,
              cursorHeight: 20,
              controller: _controller,
              cursorColor: ColorTheme.RED,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorTheme.RED)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorTheme.RED)),
                  suffixIcon: Visibility(
                    visible: _clearButtonVisibility,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                          });
                        },
                        icon: Icon(
                          Icons.cancel,
                        )),
                  ),
                  hintText: 'File name',
                  hintStyle:
                      TextStyle(color: ColorTheme.BLACK.withOpacity(0.4))),
            ),
          ),
        ],
      ),
    );
  }

  void _renameFile(Data oldData) async {
    String newFileName = _controller.text;
    Directory fileDir = widget.data.file.parent;
    File newFile = File('${fileDir.path}/$newFileName');
    try {
      if (await widget.data.file.exists()) {
        File file = await widget.data.file.rename(newFile.path);
        await FileDetails.fetch(newFile);
        Data newData = Data(
            file: file,
            fileName: newFileName,
            fileType: newFileName.split('.').last,
            details: FileDetails.getDetails(),
            filePath: newFile.path,
            fileSize: FileDetails.getSize(),
            date: FileDetails.getDate(),
            bytes: FileDetails.getBytes(),
          isHistory: oldData.isHistory,
          isBookmarked: oldData.isBookmarked
        );
        Navigator.pop(context);
        widget.onChanged!(await Read.updateFiles(widget.data,newData: newData,typeOfUpdate: TypeOfUpdate.RENAME,),newData: newData);
      }
    } catch (exception, track) {
      print('${exception.toString()} : ${track.toString()}');
    }
  }

  void _listenTextChanges() {
    if (_controller.text.isEmpty) {
      _clearButtonVisibility = false;
    } else {
      _clearButtonVisibility = true;
    }
    if (_controller.text
        .contains(RegExp(r"^[a-zA-Z0-9_\-\.\s\(\)',]+(\.[a-zA-Z]{1,4}$)"))) {
      _isOkIconButtonEnable = true;
    } else {
      _isOkIconButtonEnable = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
