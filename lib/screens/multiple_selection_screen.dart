import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/external_storage/database_helper.dart';
import 'package:pdf_reader/external_storage/read_storage.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/utilities/get_icon_path.dart';
import 'package:pdf_reader/utilities/screen_type.dart';
import 'package:pdf_reader/widgets/confirm_bottomsheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizing/sizing.dart';
import '../model/data.dart';

class SelectionScreen extends StatefulWidget {
  final List<Data> snapshot;
  final VoidCallback refresh;
  final ScreenType screenType;
  final double scrollOffset;
  final int selectedIndex;

  SelectionScreen(
      {Key? key,
      required this.snapshot,
      required this.refresh,
      required this.screenType,
      this.scrollOffset = 0,
      this.selectedIndex = 0
      }):super(key: key);
  @override
  State<StatefulWidget> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> with WidgetsBindingObserver {
  final ScrollController _controller = ScrollController();
  bool _isSelectAll = false;
  FocusNode _searchedFocusNode = FocusNode();
  bool _iconVisibility = false;
  TextEditingController _searchController = TextEditingController();
  Set<int> _selectedItems = {};
  List<Data> _filterItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
  }


  Future<void> init() async {
    _filterItems = widget.snapshot;
    _searchController.addListener(_search);
    _toggleSelection(widget.selectedIndex);
    _isSelectAll = _selectedItems.length == widget.snapshot.length;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        final maxScroll = _controller.position.maxScrollExtent;
        _controller.jumpTo(widget.scrollOffset.clamp(0, maxScroll));
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: ColorTheme.PRIMARY,
      //   actions: <Widget>[
      //     const Text('All'),
      //     Checkbox(
      //       value: _isSelectAll,
      //       onChanged: selectAll,
      //       activeColor: ColorTheme.RED,
      //       materialTapTargetSize: MaterialTapTargetSize.padded,
      //     ),
      //     SizedBox(
      //       width: 5.ss,
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: Padding(padding: EdgeInsets.only(top: 10.ss),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _topSearchDesign(),
            InkWell(
              onTap: ()=> selectAll(!_isSelectAll),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Select All'),
                SizedBox(width: MediaQuery.of(context).size.width*0.29,),
                Checkbox(
                  value: _isSelectAll,
                  onChanged: selectAll,
                  activeColor: ColorTheme.RED,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
                SizedBox(
                  width: 5.ss,
                ),
                ],),
            ),
            Divider(
              height: 0,
              color: ColorTheme.BLACK.withOpacity(0.1),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filterItems.length,
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  final item = _filterItems[index];
                  final originalIndex = widget.snapshot.indexOf(item);
                  return ListTile(
                      style: ListTileStyle.list,
                      contentPadding: EdgeInsets.only(left: 18.ss, right: 6.ss),
                      onTap: () => _toggleSelection(originalIndex),
                      onLongPress: () => _longPressHandler(originalIndex),
                      leading: Image.asset(
                        getIconPath(item.fileType),
                        width: 45.ss,
                        height: 45.ss,
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
                      trailing: Checkbox(
                        value: _selectedItems.contains(originalIndex),
                        onChanged: (value) {
                          _toggleSelection(originalIndex);
                        },
                        activeColor: ColorTheme.RED,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                      )
                  );
                },
              ),
            ),
          ],
        ),
        )


      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _textButton(
              icon: const Icon(Icons.delete_outline_outlined),
              onPressed: _multipleDelete,
              label: 'Delete'),
          if (widget.screenType == ScreenType.BOOKMARKS || widget.screenType == ScreenType.HISTORY)
            _textButton(
                icon: const Icon(Icons.remove_circle_outline_outlined),
                onPressed: _remove,
                label: 'Remove'),
          _textButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: _shareMultipleFiles,
              label: 'Share'),
        ],
      ),
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedItems.contains(index)) {
        _selectedItems.remove(index);
      } else {
        _selectedItems.add(index);
      }
      _isSelectAll = _selectedItems.length == widget.snapshot.length;
    });
  }


  void _longPressHandler(int index) {
    setState(() {
      _toggleSelection(index);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    widget.refresh();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      if (View.of(context).viewInsets.bottom == 0) {
        _searchedFocusNode.unfocus();
      }
    }
  }

  _unSelectAll() {
    setState(() {
      _selectedItems.clear();
    });
  }

  void selectAll(bool? value) {
    setState(() {
      if (value == true) {
        _selectedItems = Set<int>.from(Iterable.generate(widget.snapshot.length));
        _isSelectAll = true;
      } else {
        _selectedItems.clear();
        _isSelectAll = false;
      }
    });
  }

  Future<void> _shareMultipleFiles() async {
    List<XFile> xfiles = [];
    const MAX_FILES_TO_SHARE = 30;
    if(_selectedItems.isNotEmpty){
      for(var index in _selectedItems){
          final filePath = widget.snapshot[index].filePath;
          final file = File(filePath);
          if (await file.exists()) {
            xfiles.add(XFile(filePath));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: ColorTheme.PRIMARY,
              content: Center(
                  child: Text('File not found: $filePath',
                      style: TextStyle(color: ColorTheme.BLACK))),
            ));
          }
      }

      if (xfiles.isNotEmpty) {
        if (xfiles.length > MAX_FILES_TO_SHARE) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorTheme.PRIMARY,
            content: Center(
                child: Text(
                    'You can only share up to $MAX_FILES_TO_SHARE files at a time.',
                    style: TextStyle(color: ColorTheme.BLACK))),
          ));
          return;
        }
        try {
          final sharedResult = await Share.shareXFiles(xfiles);
          if (sharedResult.status == ShareResultStatus.success) {
            _unSelectAll();
          }
        } catch (e) {
          // Handle sharing error
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorTheme.PRIMARY,
            content: Center(
                child: Text('Error sharing files: $e',
                    style: TextStyle(color: ColorTheme.BLACK))),
          ));
        }
      }
    }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorTheme.PRIMARY,
        content: Center(
            child: Text('Select files to share',
                style: TextStyle(color: ColorTheme.BLACK))),
      ));
    }
  }

  Future<void> _multipleDelete() async {
    var confirmed = await showConfirmWidget(
        home_context: context,
        label: 'Delete',
        message: 'Delete all selection');
    if(confirmed){
      if (_selectedItems.isNotEmpty) {
        for (var index in _selectedItems) {
          var item = widget.snapshot[index];
            try {
              Read.removeFiles(item);
              _refreshData(item);
            } catch (exception) {
              print('Error deleting file: ${item.filePath}, Error: $exception');
            }
        }
       widget.refresh();
        _unSelectAll();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: ColorTheme.PRIMARY,
          content: Center(
              child: Text('No selected files to delete',
                  style: TextStyle(color: ColorTheme.BLACK))),
        ));
      }
    }
  }


  Future<void> _remove()async{
    var database = await DatabaseHelper.getInstance();
    if(_selectedItems.isNotEmpty){
      var comfirmed = await showConfirmWidget(home_context: context, label: 'Remove',message: 'Remove selected bookmarks');
      if(comfirmed){
        for(var index in _selectedItems){
          var item = widget.snapshot[index];
          if(widget.screenType == ScreenType.BOOKMARKS){
            database.deleteFrom(table_name:DatabaseHelper.BOOKMARK_TABLE_NAME, filePath: item.filePath);
            Read.updateFiles(item,typeOfUpdate: TypeOfUpdate.BOOKMARK);
          }else{
            database.deleteFrom(table_name: widget.screenType == ScreenType.BOOKMARKS ? DatabaseHelper.BOOKMARK_TABLE_NAME : DatabaseHelper.HISTORY_TABLE_NAME, filePath: item.filePath);
            Read.updateFiles(item,typeOfUpdate: TypeOfUpdate.HISTORY);
          }
          _refreshData(item);
        }
       widget.refresh();
        _unSelectAll();
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorTheme.PRIMARY,
        content: Center(
            child: Text('No selected files to remove',
                style: TextStyle(color: ColorTheme.BLACK))),
      ));
    }
  }

  Widget _textButton(
      {String label = '',
      required Icon icon,
      required VoidCallback onPressed}) {
    return Expanded(
      child: TextButton(
          style: ButtonStyle(
              overlayColor: WidgetStatePropertyAll(ColorTheme.PRIMARY),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
              foregroundColor: WidgetStatePropertyAll(ColorTheme.BLACK)),
          onPressed: onPressed,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [icon, Text(label)],
          )),
    );
  }

  void _refreshData(Data item)async {
    setState(() {
      widget.snapshot.removeAt(widget.snapshot.indexOf(item));
      if(widget.snapshot.isEmpty){
        Navigator.of(context).pop();
      }
    });
  }

  _search() {
    var searchedQuery = _searchController.text;
    if (searchedQuery.isNotEmpty) {
      setState(() {
        _filterItems = widget.snapshot.where((data) => data.fileName
            .toLowerCase()
            .contains(searchedQuery.toLowerCase())).toList();
        _iconVisibility = true;
      });
    } else {
      setState(() {
       _filterItems = widget.snapshot;
      });
    }
  }

  _topSearchDesign() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextSelectionTheme(
          data: TextSelectionThemeData(
              selectionHandleColor: ColorTheme.RED,
              selectionColor: ColorTheme.PRIMARY),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.62,
                maxHeight: 40.ss),
            child: TextField(
              focusNode: _searchedFocusNode,
              controller: _searchController,
              cursorColor: ColorTheme.RED,
              maxLines: 1,
              keyboardType: TextInputType.text,
              style: TextStyle(color: ColorTheme.BLACK),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Visibility(
                    visible: _iconVisibility,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.text = '';
                          _iconVisibility = false;
                        });
                      },
                      icon: Icon(Icons.cancel,
                          color: ColorTheme.BLACK.withOpacity(0.3)),
                      style: ButtonStyle(
                          overlayColor:
                          WidgetStatePropertyAll(ColorTheme.PRIMARY),
                          iconSize: WidgetStatePropertyAll(20.ss)),
                    ),
                  ),
                  hintText: 'Search',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: ColorTheme.BLACK.withOpacity(0.5))),
            ),
          ),
        ),
        SizedBox(
          height: 17,
          child: VerticalDivider(
            color: ColorTheme.BLACK.withOpacity(0.1), // Color of the divider
            thickness: 1.5, // Thickness of the divider
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
          ),
          style: ButtonStyle(
              overlayColor: WidgetStatePropertyAll(ColorTheme.PRIMARY),
              foregroundColor: WidgetStatePropertyAll(ColorTheme.BLACK),
              textStyle: WidgetStatePropertyAll(Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }

}
