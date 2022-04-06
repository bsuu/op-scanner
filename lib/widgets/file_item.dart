import 'package:flag/flag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/scan_file.dart';
import '../octicons_icons.dart';
import '../skan_colors.dart';

class FileItemState extends State<FileItem> {

  bool          infoTabHidden   = true;
  double        infoTabSize     = 3;
  List<Color>   infoTabColor    = [Colors.red];

  void _infoTab() {
    setState(() {
      infoTabHidden = !infoTabHidden;
      print(infoTabHidden);
    });
  }

  double _infoTabSize() {
    return (infoTabHidden) ? 0 : 3;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.bounceInOut,
            height: 75 + _infoTabSize(),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.red,
                  Colors.green
                ]
              ),
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(18))
            )
          ),
          Container(
              constraints: const BoxConstraints(maxHeight: 75),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: file_item_background,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.file_name,
                        style: const TextStyle(
                            fontSize: 18, color: first_font_color),
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(widget.file_type,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: second_font_color,
                                    height: 1.8)),
                            if (widget.file_lang != null)
                              Flag.fromString(widget.file_lang,
                                  height: 14,
                                  width: 20,
                                  fit: BoxFit.fill,
                                  borderRadius: 2),
                          ]),
                    ],
                  ),
                  Expanded(
                      child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 20,
                    children: [
                      GestureDetector(
                        child: const Icon(Octicons.info_16,
                            color: base_icon_color),
                        onTap: _infoTab,
                      ),
                      Icon(Octicons.beaker_16,
                          color: getIconColor(widget.transcription)),
                      Icon(Octicons.paper_airplane_16,
                          color: getIconColor(widget.upload)),
                    ],
                  ))
                ],
              )),
        ],
      ),
    );
  }

  Color getIconColor(STATUS status) {
    if (status == STATUS.RUNNING) {
      return transcription_icon_color;
    }
    if (status == STATUS.DONE) {
      return done_icon_color;
    }
    return base_icon_color;
  }
}

class FileItem extends StatefulWidget {
  FileItem({
    Key? key,
    required this.file_name,
    required this.file_type,
    required this.transcription,
    required this.upload,
    this.file_lang,
  }) : super(key: key);

  final String file_name;
  final String file_type;

  STATUS upload;
  STATUS transcription;

  var file_lang;

  @override
  State<StatefulWidget> createState() => FileItemState();
}
