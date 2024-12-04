import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/external_storage/database_helper.dart';
import 'package:pdf_reader/external_storage/read_storage.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/widgets/show_delete_widget.dart';
import 'package:pdf_reader/widgets/show_file_details_widget.dart';
import 'package:pdf_reader/widgets/show_rename_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizing/sizing.dart';

import '../utilities/callbacks.dart';
import '../utilities/get_icon_path.dart';

void customBottomSheet(
    {required BuildContext home_context,
    required Data data,
    required OnChanged onChanged,}
    ) {
  showModalBottomSheet(
      context: home_context,
      sheetAnimationStyle: AnimationStyle(curve: Curves.linear),
      useSafeArea: true,
      builder: (context) {
        return _SheetDesign(home_context: home_context, data: data, onChanged: onChanged,);
      });
}


class _SheetDesign extends StatefulWidget{
   BuildContext home_context;
   Data data;
   OnChanged onChanged;
  _SheetDesign({required this.home_context ,
    required this.data,
    required this.onChanged,});
  @override
  State<StatefulWidget> createState() => _SheetDesignState();
}

class _SheetDesignState extends State<_SheetDesign>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.ss),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 12.ss),
              child: _topDesign()),
          SizedBox(
            height: 6.ss,
          ),
          Divider(
            height: 1,
            color: ColorTheme.BLACK.withOpacity(0.3),
          ),
          ListTile(
            leading: Icon(Icons.drive_file_rename_outline),
            title: Text(
              'Rename',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            onTap: () {
              Navigator.pop(context);
              showRenameWidget(
                  home_context: widget.home_context,
                  data: widget.data,
                  onChanged: widget.onChanged);
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text(
              'Share',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            onTap: () {
              Navigator.pop(context);
              _shareFile(widget.data);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_rounded),
            title: Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            onTap: () {
              Navigator.pop(context);
              showDeleteWidget(widget.home_context, widget.data, widget.onChanged);
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(
              'Details',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            onTap: () {
              Navigator.pop(context);
              showFileDetails(home_context: widget.home_context, data: widget.data);
            },
          ),
        ],
      ),
    );
  }



  Widget _topDesign() {

    String iconPath = getIconPath(widget.data.fileType);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Image.asset(
            iconPath,
            width: 45.ss,
            height: 45.ss,
          ),
        ),
        Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data.fileName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  widget.data.details,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ],
            )),
        Expanded(
            flex: 1,
            child: IconButton(
                onPressed: !widget.data.isBookmarked ? _addToBookmark : _removeFromBookmark,
                icon: Image.asset(
                  widget.data.isBookmarked ? 'assets/icons/bookmark_filled.png' : 'assets/icons/bookmark_icon.png',
                  width: 25.ss,
                  height: 25.ss,
                )))
      ],
    );
  }

  void _shareFile(Data data) {
    Share.shareXFiles([XFile(data.filePath)]);
  }

  _addToBookmark() async {
    var database = await DatabaseHelper.getInstance();
    var isBookmarked = await database.insertInto(table_name: DatabaseHelper.BOOKMARK_TABLE_NAME, filePath: widget.data.filePath);
    if(isBookmarked) {
      setState(() {
        Read.updateFiles(widget.data,typeOfUpdate: TypeOfUpdate.BOOKMARK);
      });
    }
  }
  _removeFromBookmark() async {
    var database = await DatabaseHelper.getInstance();
    var isBookmarked = await database.deleteFrom(table_name: DatabaseHelper.BOOKMARK_TABLE_NAME, filePath: widget.data.filePath);
    if(isBookmarked) {
      setState(() {
        Read.updateFiles(widget.data,typeOfUpdate: TypeOfUpdate.BOOKMARK);
      });
    }
  }
}

