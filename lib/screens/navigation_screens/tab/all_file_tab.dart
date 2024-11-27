import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/screen_type.dart';
import 'package:pdf_reader/widgets/custom_listview_widget.dart';
import '../../../external_storage/read_storage.dart';
import '../../../model/data.dart';

class AllFileTab extends StatefulWidget {
  final String trailing;
  final ScreenType screenType;
  AllFileTab(
      {Key? key,
      this.trailing = 'assets/icons/three_dots_icon.png',
      required this.screenType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => AllFilesTabStates();
}

class AllFilesTabStates extends State<AllFileTab> with WidgetsBindingObserver {
  List<Data> _snapshot = [];
  @override
  void initState() {
    super.initState();
    _handleFileData(widget.screenType);
    WidgetsBinding.instance.addObserver(this);
  }

  _handleFileData(ScreenType screenType) {
    switch (screenType) {
      case ScreenType.ALL_FILES:
        _snapshot = Read.AllFiles;
        break;
      case ScreenType.HISTORY:
        _snapshot = _getHistory();
        break;
      case ScreenType.BOOKMARKS:
        _snapshot = _getBookmark();
        break;
      default:
        _snapshot = [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomListView(
              snapshot: _snapshot,
              screenType: widget.screenType,
            refresh: refresh,
          )
          ),
    );
  }

  List<Data> _getBookmark() {
    return Read.AllFiles.where((data) => data.isBookmarked).toList();
  }

  void refresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _handleFileData(widget.screenType);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  List<Data> _getHistory() {
    return Read.AllFiles.where((data) => data.isHistory).toList();
  }
}
