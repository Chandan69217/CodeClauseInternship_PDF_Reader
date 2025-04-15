import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/widgets/custom_bottomsheets/custom_bottomsheet.dart';
import 'package:pdf_reader/widgets/custom_listview/custom_list_tile.dart';
import '../external_storage/read_storage.dart';
import '../utilities/file_view_handler.dart';



class SearchScreen extends StatefulWidget {
  SearchScreen();
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with WidgetsBindingObserver {
  List<Data> _searchedItem = [];
  bool _isAvailable = false;
  bool _iconVisibility = false;
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchedFocusNode = FocusNode();
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
          padding: EdgeInsets.only(left: 8, right: 8, top: 10),
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
                  child: _isAvailable
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: _searchedItem.length,
                          itemBuilder: (context, index) {
                            return CustomListTile(
                              data: _searchedItem[index],
                              onOptionClick: () {
                                _searchedFocusNode.unfocus();
                                customBottomSheet(
                                    home_context: context,
                                    data: _searchedItem[index],
                                  onChanged: _onChanged
                                );
                              },
                              onTap: () {
                                fileViewHandler(context, _searchedItem[index],);
                              },
                            );
                          })
                      : Center(
                          child: Text('No results'),
                        ),
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
        _searchedItem = Read.instance.AllFiles.where((data) => data.fileName
            .toLowerCase().trim()
            .contains(searchedQuery.toLowerCase().trim())).toList();
        _searchedItem.isNotEmpty ? _isAvailable = true : _isAvailable = false;
        _iconVisibility = true;
      });
    } else {
      setState(() {
        _searchedItem = [];
        _iconVisibility = false;
        _isAvailable = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void _onChanged(status,{newData}) {
   if(status){
     _search();
   }
  }

}
