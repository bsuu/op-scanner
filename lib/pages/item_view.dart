import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:skan/data/scan_file.dart';
import 'package:skan/pages/image_view.dart';

class ItemView extends StatefulWidget {
  final ScanFile scanFile;

  const ItemView({Key? key, required this.scanFile}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ItemViewState();
}

class ItemViewState extends State<ItemView> {
  @override
  Widget build(BuildContext context) {
    double widthSize = (MediaQuery.of(context).size.width - 48) / 3;
    double heightSize = (widthSize / 9) * 14;

    return Container(
      decoration:
          BoxDecoration(color: AdaptiveTheme.of(context).theme.backgroundColor),
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxHeight: 75),
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: AdaptiveTheme.of(context).theme.primaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.scanFile.name,
                  style: AdaptiveTheme.of(context).theme.textTheme.headline1,
                )
              ],
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int i = 0; i < widget.scanFile.files.length; i++)
                GestureDetector(
                  onTap: () {
                    if (widget.scanFile.transcription != STATUS.DONE) {
                      return;
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ImageView(scanFile: widget.scanFile, index: i,)));
                  },
                  child: Container(
                      height: heightSize,
                      width: widthSize,
                      child: ClipRRect(
                        child: Image.file(
                          File(widget.scanFile.files[i]),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        color: AdaptiveTheme.of(context).theme.backgroundColor,
                      )),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
