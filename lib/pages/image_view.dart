import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:skan/data/scan_file.dart';

import '../data/text_recognision_block.dart';

class ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    String lines = "";

    for (TextRecognisionBlock trb in widget.scanFile.trb[widget.index]) {
      for (String line in trb.lines) {
        lines += line + '\n';
      }
    }

    print(lines);

    return PageView(
      children: [
        Container(
          decoration: BoxDecoration(
              color: AdaptiveTheme.of(context).theme.backgroundColor),
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top, left: 8, right: 8, bottom: 8),
          child: Image.file(File(widget.scanFile.files[widget.index])),
        ),
        Container(
            decoration: BoxDecoration(
                color: AdaptiveTheme.of(context).theme.backgroundColor),
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top, left: 8, right: 8, bottom: 8),
            child: ListView(
              children: (lines != "")
                  ? [
                      Text(lines,
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .bodyText1)
                    ]
                  : [
                      Center(
                        child: Text(
                          "Brak tekstu :(",
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .bodyText1,
                        ),
                      ),
                    ],
            ))
      ],
    );
  }
}

class ImageView extends StatefulWidget {
  final int index;
  final ScanFile scanFile;

  const ImageView({Key? key, required this.index, required this.scanFile})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ImageViewState();
}
