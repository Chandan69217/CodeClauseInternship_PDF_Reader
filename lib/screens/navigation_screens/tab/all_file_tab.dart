import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/utilities/file_view_handler.dart';
import 'package:pdf_reader/widgets/custom_bottomsheet.dart';
import 'package:pdf_reader/widgets/custom_list_tile.dart';

import '../../../external_storage/read_storage.dart';
import '../../../model/data.dart';
import '../../../utilities/color.dart';

class AllFileTab extends StatefulWidget {
  final String trailing;
  AllFileTab({
    this.trailing = 'assets/icons/three_dots_icon.png',
  });

  @override
  State<StatefulWidget> createState() => _States();
}

class _States extends State<AllFileTab> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = Read(context).getAllFiles();
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
                        },
                      );
                    },
                    onTap: () {
                      fileViewHandler(context, snapshot.data![index]);
                    },
                  );
                });
          } else {
            return Center(
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

// class BottomSheetDummyUI extends StatelessWidget {
//   const BottomSheetDummyUI({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Container(
//           padding: EdgeInsets.only(left: 30, right: 30),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(15.0),
//                     child: Container(
//                       color: Colors.black12,
//                       height: 100,
//                       width: 100,
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(15.0),
//                         child: Container(
//                           color: Colors.black12,
//                           height: 20,
//                           width: 240,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(15.0),
//                         child: Container(
//                           color: Colors.black12,
//                           height: 20,
//                           width: 180,
//                         ),
//                       ),
//                       SizedBox(height: 50),
//                     ],
//                   )
//                 ],
//               ),
//               SizedBox(height: 10),
//             ],
//           )),
//     );
//   }
// }
//
// class MyDraggableSheet extends StatefulWidget {
//   final Widget child;
//   const MyDraggableSheet({super.key, required this.child});
//
//   @override
//   State<MyDraggableSheet> createState() => _MyDraggableSheetState();
// }
//
// class _MyDraggableSheetState extends State<MyDraggableSheet> {
//   final sheet = GlobalKey();
//   final controller = DraggableScrollableController();
//
//   @override
//   void initState() {
//     super.initState();
//     controller.addListener(onChanged);
//   }
//
//   void onChanged() {
//     final currentSize = controller.size;
//     if (currentSize <= 0.05) collapse();
//   }
//
//   void collapse() => animateSheet(getSheet.snapSizes!.first);
//
//   void anchor() => animateSheet(getSheet.snapSizes!.last);
//
//   void expand() => animateSheet(getSheet.maxChildSize);
//
//   void hide() => animateSheet(getSheet.minChildSize);
//
//   void animateSheet(double size) {
//     controller.animateTo(
//       size,
//       duration: const Duration(milliseconds: 50),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     controller.dispose();
//   }
//
//   DraggableScrollableSheet get getSheet =>
//       (sheet.currentWidget as DraggableScrollableSheet);
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       return DraggableScrollableSheet(
//         key: sheet,
//         initialChildSize: 0.5,
//         maxChildSize: 0.95,
//         minChildSize: 0,
//         expand: true,
//         snap: true,
//         snapSizes: [
//           60 / constraints.maxHeight,
//           0.5,
//         ],
//         controller: controller,
//         builder: (BuildContext context, ScrollController scrollController) {
//           return DecoratedBox(
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.yellow,
//                   blurRadius: 10,
//                   spreadRadius: 1,
//                   offset: Offset(0, 1),
//                 ),
//               ],
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(22),
//                 topRight: Radius.circular(22),
//               ),
//             ),
//             child: CustomScrollView(
//               controller: scrollController,
//               slivers: [
//                 topButtonIndicator(),
//                 SliverToBoxAdapter(
//                   child: widget.child,
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     });
//   }
//
//   SliverToBoxAdapter topButtonIndicator() {
//     return SliverToBoxAdapter(
//       child: Container(
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 Container(
//                     child: Center(
//                         child: Wrap(children: <Widget>[
//                           Container(
//                               width: 100,
//                               margin: const EdgeInsets.only(top: 10, bottom: 10),
//                               height: 5,
//                               decoration: const BoxDecoration(
//                                 color: Colors.black45,
//                                 shape: BoxShape.rectangle,
//                                 borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                               )),
//                         ]))),
//               ])),
//     );
//   }
// }
