import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skan/themes.dart';
import 'package:skan/widgets/file/file_item_slider.dart';

import '../../data/scan_file.dart';
import '../../octicons_icons.dart';

class FileItemState extends State<FileItem> {
  FileItemSliderType state = FileItemSliderType.hidden;

  void _infoTab() {
    setState(() {
      if (state != FileItemSliderType.info) {
        state = FileItemSliderType.info;
      } else {
        state = FileItemSliderType.hidden;
      }
    });
  }

  void _progressTab() {
    setState(() {
      if (state != FileItemSliderType.progress) {
        state = FileItemSliderType.progress;
      } else {
        state = FileItemSliderType.hidden;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Stack(
        children: [
          FileItemSlider(
            state: state,
            index: widget.index,
            amount: widget.scanFile.files.length,
            date: widget.scanFile.created.toString(),
            onRemove: (index) {
              widget.onRemove(index);
            },
          ),
          Container(
              constraints: const BoxConstraints(maxHeight: 75),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: AdaptiveTheme.of(context).theme.primaryColorDark,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.scanFile.name,
                        style:
                            AdaptiveTheme.of(context).theme.textTheme.headline1,
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(widget.scanFile.type,
                                style: AdaptiveTheme.of(context)
                                    .theme
                                    .textTheme
                                    .bodyText1),
                            // if (widget.scanFile. != null)
                            //   Flag.fromString(widget.file_lang,
                            //       height: 14,
                            //       width: 20,
                            //       fit: BoxFit.fill,
                            //       borderRadius: 2),
                          ]),
                    ],
                  ),
                  Expanded(
                      child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 20,
                    children: [
                      GestureDetector(
                        child: Icon(Octicons.info_16,
                            color: AdaptiveTheme.of(context)
                                .theme
                                .iconTheme
                                .color),
                        onTap: _infoTab,
                      ),
                      GestureDetector(
                        child: Icon(Octicons.beaker_16,
                            color: getIconColor(widget.scanFile.transcription)
                                .color),
                        onTap: _progressTab,
                      ),
                      GestureDetector(
                        child: Icon(Octicons.paper_airplane_16,
                            color: getIconColor(widget.scanFile.cloud).color),
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

  IconThemeData getIconColor(STATUS status) {
    if (status == STATUS.RUNNING) {
      return CustomThemes().getIconColor(status, context);
    }
    if (status == STATUS.DONE) {
      return CustomThemes().getIconColor(status, context);
    }
    return CustomThemes().getIconColor(status, context);
  }
}

class FileItem extends StatefulWidget {
  FileItem(
      {Key? key,
      required this.scanFile,
      this.index = 0,
      required this.onRemove})
      : super(key: key);

  final ScanFile scanFile;
  int index;
  var onRemove;

  @override
  State<StatefulWidget> createState() => FileItemState();
}
