import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/file_view_handler.dart';
import 'package:pdf_reader/widgets/custom_bottomsheet.dart';

import '../../../external_storage/read_storage.dart';
import '../../../model/data.dart';
import '../../../utilities/color.dart';
import '../../../widgets/custom_list_tile.dart';

class DocFileTab extends StatefulWidget {
  final String trailing;

  DocFileTab({
    this.trailing = 'assets/icons/three_dots_icon.png',
  });

  @override
  State<DocFileTab> createState() => _DocFileTabState();
}

class _DocFileTabState extends State<DocFileTab> {
  late Future<List<Data>> futureData;
  @override
  void initState() {
    super.initState();
    futureData = Read(context).getDocFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
        future: futureData,
        builder: (BuildContext context, AsyncSnapshot<List<Data>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return CustomListTile(
                    title: snapshot.data![index].fileName,
                    subTitle: snapshot.data![index].details,
                    trailing: widget.trailing,
                    onOptionClick: () {
                      customBottomSheet(
                          home_context: context,
                          data: snapshot.data![index],
                          onRenamed: (data) {
                            setState(() {
                              snapshot.data![index] = data;
                            });
                          });
                    },
                    onTap: () {
                      print('Clicked:  $index');
                      // Navigator.push(context,MaterialPageRoute(builder: (context)=>FileViewer(filePath: snapshot.data![index].filePath,)));
                      fileViewHandler(context, snapshot.data![index]);
                    },
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorTheme.RED,
              ),
            );
          }
        },
      )),
    );
  }
}
