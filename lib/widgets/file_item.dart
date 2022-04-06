import 'package:flag/flag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skan/widgets/file_item_slider.dart';

import '../data/scan_file.dart';
import '../octicons_icons.dart';
import '../skan_colors.dart';

class FileItemState extends State<FileItem> {

  FileItemSliderType state = FileItemSliderType.HIDDEN;

  void _infoTab() {
    setState(() {
      if (state != FileItemSliderType.INFO) {
        state = FileItemSliderType.INFO;
      } else {
        state = FileItemSliderType.HIDDEN;
      }
    });
  }

  void _progressTab() {
    setState(() {
      if (state != FileItemSliderType.PROGRESS) {
        state = FileItemSliderType.PROGRESS;
      } else {
        state = FileItemSliderType.HIDDEN;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Stack(
        children: [
          FileItemSlider(state: state),
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
                      GestureDetector(
                        child: Icon(Octicons.beaker_16,
                            color: getIconColor(widget.transcription)),
                        onTap: _progressTab,
                      ),
                      GestureDetector(
                        child: Icon(Octicons.paper_airplane_16,
                            color: getIconColor(widget.upload)),
                        onTap: _progressTab,
                      )
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
