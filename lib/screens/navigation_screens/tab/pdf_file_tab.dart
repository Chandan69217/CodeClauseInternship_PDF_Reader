import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/external_storage/read_storage.dart';
import 'package:pdf_reader/utilities/color.dart';
import 'package:pdf_reader/utilities/file_view_handler.dart';

import '../../../model/data.dart';
import '../../../widgets/custom_bottomsheet.dart';
import '../../../widgets/custom_list_tile.dart';

class PdfFileTab extends StatefulWidget {
  final String trailing;

  PdfFileTab({this.trailing = 'assets/icons/three_dots_icon.png'});

  @override
  State<PdfFileTab> createState() => _PdfFileTabState();
}

class _PdfFileTabState extends State<PdfFileTab> {
  late Future<List<Data>> futureData;
  @override
  void initState() {
    super.initState();
    futureData = Read(context).getPdfFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
        future: futureData,
        builder: (BuildContext context, AsyncSnapshot<List<Data>> snapshot) {
          print(snapshot.hasData);
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
