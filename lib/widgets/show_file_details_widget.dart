import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:sizing/sizing.dart';

import '../utilities/color.dart';

void showFileDetails({required BuildContext home_context, required Data data}) {
  showModalBottomSheet(
      context: home_context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 30.ss, horizontal: 30.ss),
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
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18.fss),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 30.ss,
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
                height: 20.ss,
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
                height: 20.ss,
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
                height: 20.ss,
              ),
              RichText(
                  text: TextSpan(
                      text: 'Path:',
                      style: Theme.of(home_context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: ColorTheme.BLACK.withOpacity(0.5)),
                      children: [
                    TextSpan(text: '\n'),
                    TextSpan(
                        text: data.filePath,
                        style: Theme.of(home_context).textTheme.bodySmall)
                  ])),
            ],
          ),
        );
      });
}
