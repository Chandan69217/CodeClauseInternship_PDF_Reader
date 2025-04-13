import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/screens/multiple_selection_screen.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/utilities/screen_type.dart';
import '../external_storage/database_helper.dart';
import '../external_storage/read_storage.dart';
import '../model/data.dart';
import '../utilities/file_view_handler.dart';
import '../utilities/get_icon_path.dart';
import 'confirm_bottomsheet.dart';
import 'custom_bottomsheet.dart';

class CustomListView extends StatefulWidget {
  final List<Data> snapshot;
  final ScreenType screenType;
  final VoidCallback refresh;

  CustomListView({
    required this.snapshot,
    required this.screenType,
    required this.refresh,
  });

  @override
  State<StatefulWidget> createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      itemCount: widget.snapshot.length,
      itemBuilder: (BuildContext context, int index) {
        final item = widget.snapshot[index];
        return ListTile(
            contentPadding: EdgeInsets.only(left: 18, right: 6),
            onTap: () => _onTap(item),
            onLongPress: () async => _longPressHandler(index),
            leading: Image.asset(
              getIconPath(item.fileType),
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            ),
            title: Text(
              item.fileName,
              maxLines: 1,
            ),
            subtitle: Text(
              item.details,
              maxLines: 1,
            ),
            trailing: IconButton(
                onPressed: () {
                  if (widget.screenType == ScreenType.BOOKMARKS) {
                    _bookmarkOptionBtn(item, index);
                  } else {
                    _threeDotOptionBtn(item);
                  }
                },
                icon: Image.asset(
                  widget.screenType == ScreenType.ALL_FILES ||
                          widget.screenType == ScreenType.HISTORY
                      ? 'assets/icons/three_dots_icon.webp'
                      : 'assets/icons/bookmark_filled.webp',
                  width: 25,
                  height: 25,
                  fit: BoxFit.cover,
                  color:  widget.screenType == ScreenType.ALL_FILES ||
                      widget.screenType == ScreenType.HISTORY
                      ? Theme.of(context).brightness == Brightness.dark? ColorTheme.WHITE:null:null,
                )));
      },
    );
  }

  _onTap(Data item) {
    fileViewHandler(context, item, onChanged: (status,{Data? newData}){
      if (status) {
        widget.refresh();
      }
    });
  }


  _bookmarkOptionBtn(Data data, int index) async {
    if (await showConfirmWidget(
        home_context: context, data: data, label: 'Remove')) {
      var database = await DatabaseHelper.getInstance();
      var isBookmarked = await database.deleteFrom(
          table_name: DatabaseHelper.BOOKMARK_TABLE_NAME,
          filePath: data.filePath);
      if (isBookmarked) {
        Read.updateFiles(data,typeOfUpdate: TypeOfUpdate.BOOKMARK);
        widget.refresh();
      }
    }
  }

  _threeDotOptionBtn(Data item) async {
    customBottomSheet(
        home_context: context,
        data: item,
        onChanged: (status,{Data? newData}) {
          if(status){
            widget.refresh();
          }
        });
  }

  void _longPressHandler(int index) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectionScreen(
                  snapshot: widget.snapshot,
                  refresh: widget.refresh,
                  scrollOffset: _controller.position.pixels,
                  screenType: widget.screenType,
                  selectedIndex: index,
                )));
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
