
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skan/skan_colors.dart';

import '../widgets/file_item.dart';
import '../octicons_icons.dart';

import 'package:flag/flag.dart';

class FileItemState extends State<FileItem> {

  @override
  Widget build(BuildContext context) {
    return
        Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 14),
          decoration: const BoxDecoration(
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
                      style: const TextStyle(fontSize: 18, color: first_font_color),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         Text(
                              widget.file_type,
                              style: const TextStyle(fontSize: 14, color: second_font_color, height: 1.8)
                         ),
                        if (widget.file_lang != null) Flag.fromString(widget.file_lang, height: 14, width: 20, fit: BoxFit.fill, borderRadius: 2),
                      ]),
                ],
              ),
              Expanded(child:
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 20,
                  children: [
                    const Icon(Octicons.info_16, color: base_icon_color),
                    Icon(Octicons.beaker_16, color: getIconColor(widget.transcription)),
                    Icon(Octicons.paper_airplane_16, color: getIconColor(widget.upload)),
                  ],
              ))

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