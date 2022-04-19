import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skan/octicons_icons.dart';

enum FileItemSliderType {
  hidden,
  progress,
  info,
}

class FileItemSliderState extends State<FileItemSlider> {
  var sizes = {
    FileItemSliderType.hidden: 0.0,
    FileItemSliderType.progress: 5.0,
    FileItemSliderType.info: 80.0,
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInQuad,
      height: 75.0 + sizes[widget.state]!,
      width: double.infinity,
      padding: EdgeInsets.only(
          left: 10, right: 40, bottom: 10, top: sizes[widget.state]!),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AdaptiveTheme.of(context).theme.primaryColor,
              AdaptiveTheme.of(context).theme.primaryColor
            ]),
        borderRadius: const BorderRadius.all(Radius.circular(18)),
      ),
      child: Row(
          children: (widget.state == FileItemSliderType.info)
              ? [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        Row(
                          children: [
                            const Icon(Octicons.calendar_16, size: 18),
                            Text("  ${widget.date}",
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Octicons.database_16, size: 18),
                            Text("  ${widget.size}",
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Octicons.file_diff_16, size: 18),
                            Text("  ${widget.amount}",
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ])),
                  GestureDetector(
                    onTap: () {
                      widget.onRemove(widget.index);
                      print("Removeed");
                    },
                    child: const Icon(
                      Octicons.trash_16,
                      size: 30,
                    ),
                  ),
                ]
              : []),
    );
  }
}

class FileItemSlider extends StatefulWidget {
  FileItemSliderType state;

  String date;
  String size;
  int amount;
  int index;

  var onRemove;

  FileItemSlider(
      {Key? key,
      required this.state,
      this.date = "",
      this.size = "",
      this.amount = 0,
      this.index = 0,
      this.onRemove})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FileItemSliderState();
}
