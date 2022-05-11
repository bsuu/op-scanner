import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:skan/octicons_icons.dart';
import 'package:skan/themes.dart';

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
            stops: (widget.state == FileItemSliderType.progress)
                ? [0, widget.progress / 100]
                : [0, 0],
            colors: [
              (widget.progress > 0)
                  ? CustomThemes().getFileSliderColor(widget.state, context)
                  : AdaptiveTheme.of(context).theme.primaryColor,
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
                            const FaIcon(FontAwesomeIcons.calendar, size: 18),
                            Text(
                                "  ${DateFormat("yyyy-MM-dd HH:mm").format(widget.date)}",
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.fileZipper, size: 18),
                            Text("  ${widget.amount}",
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ])),
                  GestureDetector(
                    onTap: () {
                      widget.onRemove(widget.index);
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.trashCan,
                      size: 24,
                      color: Colors.red,
                    ),
                  ),
                ]
              : []),
    );
  }
}

class FileItemSlider extends StatefulWidget {
  final FileItemSliderType state;

  final DateTime date;
  final int amount;
  final int index;
  final int progress;

  final void Function(int index) onRemove;

  FileItemSlider({
    Key? key,
    required this.state,
    this.amount = 0,
    this.index = 0,
    this.progress = 100,
    required this.onRemove,
    DateTime? date,
  })  : date = date ?? DateTime.now(),
        super(key: key);

  @override
  State<StatefulWidget> createState() => FileItemSliderState();
}
