import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/tools_functions.dart';
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
  List<Data> _ItemsToSelect = Read.instance.AllFiles;
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
          padding: const EdgeInsets.only(top: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _topSearchDesign(),
                Divider(
                  height: 0,
                  color: Theme.of(context).brightness == Brightness.dark? ColorTheme.WHITE.withValues(alpha: 0.2) :ColorTheme.BLACK.withValues(alpha: 0.1),
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _ItemsToSelect.length,
                      itemBuilder: (context, index) {
                        _isSelected = _selectedIndex == index;
                        return ListTile(
                          selected: _isSelected,
                          contentPadding:
                              EdgeInsets.only(left: 18, right: 6),
                          onTap: () async {
                            setState(() {
                              _selectedIndex = index;
                            });
                            ToolsFunction.printPDF(_ItemsToSelect[index].file);
                          },
                          leading: Image.asset(
                            getIconPath(_ItemsToSelect[index].fileType),
                            width: 45,
                            height: 45,
                          ),
                          title: Text(
                            _ItemsToSelect[index].fileName,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            _ItemsToSelect[index].details,
                            maxLines: 1,
                          ),
                          trailing: Visibility(
                            visible: _isSelected,
                            child: Checkbox(
                                value: _isSelected,
                                activeColor: ColorTheme.RED,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedIndex = value! ? index : null;
                                  });
                                }),
                          ),
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
          data: Theme.of(context).textSelectionTheme,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.62,
                maxHeight: 40),
            child: TextField(
              focusNode: _searchedFocusNode,
              controller: _searchController,
              cursorColor: ColorTheme.RED,
              maxLines: 1,
              autofocus: true,
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.bodyMedium,
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
                      icon: Icon(Icons.cancel,),

                    ),
                  ),
                  hintText: 'Search',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).brightness == Brightness.dark? ColorTheme.WHITE.withValues(alpha: 0.5):ColorTheme.BLACK.withValues(alpha: 0.5))
              ),
            ),
          ),
        ),
        SizedBox(
          height: 17,
          child: VerticalDivider(
            color:Theme.of(context).brightness == Brightness.light? ColorTheme.BLACK.withValues(alpha: 0.1):ColorTheme.WHITE.withValues(alpha: 0.5), // Color of the divider
            thickness: 1.5, // Thickness of the divider
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: TextButton(
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
        ),
      ],
    );
  }

  _search() {
    var searchedQuery = _searchController.text;
    if (searchedQuery.isNotEmpty) {
      setState(() {
        _ItemsToSelect = Read.instance.AllFiles.where((data) => data.fileName
            .toLowerCase()
            .contains(searchedQuery.toLowerCase())).toList();
        _iconVisibility = true;
      });
    } else {
      setState(() {
        _ItemsToSelect = Read.instance.AllFiles;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
