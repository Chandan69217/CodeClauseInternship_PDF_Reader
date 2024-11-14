import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/utilities/color.dart';
import 'package:pdf_reader/widgets/custom_list_tile.dart';
import 'package:sizing/sizing.dart';

import '../external_storage/read_storage.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Data> _searchedItem = [];
  bool _isAvailable = false;
  bool _iconVisibility = false;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchController.addListener(_search);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 8.ss, right: 8.ss, top: 10),
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
                  child: _isAvailable ? ListView.builder(shrinkWrap: true,itemCount: _searchedItem.length,itemBuilder: (context,index){
                    return CustomListTile(title: _searchedItem[index].fileName, subTitle: _searchedItem[index].details, trailing: 'assets/icons/three_dots_icon.png');
                  }) : Center(child: Text('No results'),),
                ),
              ]),
        ),
      ),
    );
  }

  _topSearchDesign(){
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
              controller: searchController,
              cursorColor: ColorTheme.RED,
              maxLines: 1,
              autofocus: true,
              keyboardType: TextInputType.text,
              style: TextStyle(color: ColorTheme.BLACK),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Visibility(
                    visible: _iconVisibility,
                    child: IconButton(
                      onPressed: () {setState(() {
                        searchController.text = '';
                        _iconVisibility = false;
                      });},
                      icon: Icon(Icons.cancel,
                          color: ColorTheme.BLACK.withOpacity(0.3)),
                      style: ButtonStyle(
                          overlayColor: WidgetStatePropertyAll(
                              ColorTheme.PRIMARY),
                          iconSize: WidgetStatePropertyAll(20.ss)),
                    ),
                  ),
                  hintText: 'Search',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(
                      color:
                      ColorTheme.BLACK.withOpacity(0.5))),
            ),
          ),
        ),
        SizedBox(
          height: 17,
          child: VerticalDivider(
            color: ColorTheme.BLACK
                .withOpacity(0.1), // Color of the divider
            thickness: 1.5, // Thickness of the divider
          ),
        ),
        TextButton(
          onPressed: () {Navigator.of(context).pop();},
          child: Text(
            'Cancel',
          ),
          style: ButtonStyle(
              overlayColor:
              WidgetStatePropertyAll(ColorTheme.PRIMARY),
              foregroundColor:
              WidgetStatePropertyAll(ColorTheme.BLACK),
              textStyle: WidgetStatePropertyAll(Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }
  _search(){
    var searchedQuery = searchController.text;
    if(searchedQuery.isNotEmpty){
      setState(() {
        _searchedItem = Read.AllFiles.where((data)=> data.fileName.toLowerCase().contains(searchedQuery.toLowerCase())).toList();
        _searchedItem.isNotEmpty ? _isAvailable = true : _isAvailable = false;
        _iconVisibility = true;
      });
    }else{
      setState(() {
        _searchedItem = [];
        _iconVisibility = false;
      });
    }
  }
}
