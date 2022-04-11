import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skan/themes.dart';
import 'package:skan/widgets/file_item_slider.dart';

import '../data/scan_file.dart';
import '../octicons_icons.dart';

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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: AdaptiveTheme.of(context).theme.primaryColor,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.file_name,
                        style: AdaptiveTheme.of(context).theme.textTheme.headline1,
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(widget.file_type,
                                style: AdaptiveTheme.of(context).theme.textTheme.bodyText1),
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
                        child: Icon(Octicons.info_16,
                            color: AdaptiveTheme.of(context).theme.iconTheme.color),
                        onTap: _infoTab,
                      ),
                      GestureDetector(
                        child: Icon(Octicons.beaker_16,
                            color: getIconColor(widget.transcription).color),
                        onTap: _progressTab,
                      ),
                      GestureDetector(
                        child: Icon(Octicons.paper_airplane_16,
                            color: getIconColor(widget.upload).color),
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
