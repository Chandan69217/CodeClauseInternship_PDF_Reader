import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';


import '../utilities/color_theme.dart';

void showFileDetails({required BuildContext home_context, required Data data}) {
  showModalBottomSheet(
      context: home_context,
      constraints: BoxConstraints(minWidth: MediaQuery.of(home_context).size.width),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Details',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        RichText(
                            text: TextSpan(
                                text: 'Name:',
                                style: Theme.of(home_context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: ColorTheme.BLACK.withOpacity(0.5)),
                                children: [
                                  TextSpan(text: '\n'),
                                  TextSpan(
                                      text: data.fileName,
                                      style: Theme.of(home_context).textTheme.bodySmall)
                                ])),
                        SizedBox(
                          height: 20,
                        ),
                        RichText(
                            text: TextSpan(
                                text: 'Date:',
                                style: Theme.of(home_context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: ColorTheme.BLACK.withOpacity(0.5)),
                                children: [
                                  TextSpan(text: '\n'),
                                  TextSpan(
                                      text: data.date,
                                      style: Theme.of(home_context).textTheme.bodySmall)
                                ])),
                        SizedBox(
                          height: 20,
                        ),
                        RichText(
                            text: TextSpan(
                                text: 'Size:',
                                style: Theme.of(home_context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: ColorTheme.BLACK.withOpacity(0.5)),
                                children: [
                                  TextSpan(text: '\n'),
                                  TextSpan(
                                      text: data.fileSize,
                                      style: Theme.of(home_context).textTheme.bodySmall)
                                ])),
                        SizedBox(
                          height: 20,
                        ),
                        RichText(
                          text: TextSpan(
                              text: 'Path:',
                              style: Theme.of(home_context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: ColorTheme.BLACK.withOpacity(0.5),),
                              children: [
                                TextSpan(text: '\n'),
                                TextSpan(
                                    text: data.filePath,
                                    style: Theme.of(home_context).textTheme.bodySmall)
                              ]),)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
