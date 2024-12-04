import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/tools_functions.dart';
import 'package:sizing/sizing.dart';
import '../external_storage/read_storage.dart';
import '../model/data.dart';
import '../utilities/color_theme.dart';
import '../utilities/get_icon_path.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});
  @override
  State<StatefulWidget> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen>
    with WidgetsBindingObserver {
  List<Data> _ItemsToSelect = Read.AllFiles;
  bool _iconVisibility = false;
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchedFocusNode = FocusNode();
  bool _isSelected = false;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _searchController.addListener(_search);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _topSearchDesign(),
                Divider(
                  height: 0,
                  color: ColorTheme.BLACK.withOpacity(0.1),
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _ItemsToSelect.length,
                      itemBuilder: (context, index) {
                        _isSelected = _selectedIndex == index;
                        return ListTile(
                          tileColor: _isSelected ? ColorTheme.PRIMARY : null,
                          contentPadding:
                              EdgeInsets.only(left: 18.ss, right: 6.ss),
                          onTap: () async {
                            setState(() {
                              _selectedIndex = index;
                            });
                            ToolsFunction.printPDF(_ItemsToSelect[index].file);
                          },
                          leading: Image.asset(
                            getIconPath(_ItemsToSelect[index].fileType),
                            width: 45.ss,
                            height: 45.ss,
                          ),
                          title: Text(
                            _ItemsToSelect[index].fileName,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            _ItemsToSelect[index].details,
                            maxLines: 1,
                          ),
                          trailing: Checkbox(
                              value: _isSelected,
                              activeColor: ColorTheme.RED,
                              onChanged: (value) {
                                setState(() {
                                  _selectedIndex = value! ? index : null;
                                });
                              }),
                        );
                      }),
                ),
              ]),
        ),
      ),
    );
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

  _search() {
    var searchedQuery = _searchController.text;
    if (searchedQuery.isNotEmpty) {
      setState(() {
        _ItemsToSelect = Read.AllFiles.where((data) => data.fileName
            .toLowerCase()
            .contains(searchedQuery.toLowerCase())).toList();
        _iconVisibility = true;
      });
    } else {
      setState(() {
        _ItemsToSelect = Read.AllFiles;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
