import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:skan/data/scan_file.dart';

import '../data/text_recognision_block.dart';

class ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    String lines = "";

    if (widget.scanFile.transcription == STATUS.DONE) {
      for (TextRecognisionBlock trb in widget.scanFile.trb[widget.index]) {
        for (String line in trb.lines) {
          lines += line + '\n';
        }
      }
    }

    return PageView(
      children: [
        Container(
          decoration: BoxDecoration(
              color: AdaptiveTheme.of(context).theme.backgroundColor),
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top,
              left: 8,
              right: 8,
              bottom: 8),
          child: FutureBuilder(
            future: widget.scanFile.getScanLocation(),
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.done) {

                print("${snapshot.data}/${widget.scanFile.files[widget.index]}");
                return Image.file(File("${snapshot.data}/${widget.scanFile.files[widget.index]}"));
              }
              return const Text("Czekam");
            },
          ),
        ),
        if (widget.scanFile.transcription == STATUS.DONE)
          Container(
              decoration: BoxDecoration(
                  color: AdaptiveTheme.of(context).theme.backgroundColor),
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).viewPadding.top,
                  left: 8,
                  right: 8,
                  bottom: 8),
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
