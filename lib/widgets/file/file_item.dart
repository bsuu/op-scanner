import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:skan/data/text_recognision_block.dart';
import 'package:skan/themes.dart';
import 'package:skan/widgets/file/file_item_slider.dart';

import '../../data/scan_file.dart';
import '../../octicons_icons.dart';

class FileItemState extends State<FileItem> {
  FileItemSliderType state = FileItemSliderType.hidden;
  int progress = -1;

  Future<void> _runTextRecognision(ScanFile sf) async {
    double step = 100 / sf.files.length;
    setState(() {
      sf.transcription = STATUS.RUNNING;
      progress = 0;
    });
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    List<List<TextRecognisionBlock>> trb = [];
    for (String file in sf.files) {
      final InputImage image = InputImage.fromFilePath(file);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(image);
      List<TextRecognisionBlock> trbList = [];
      for (TextBlock block in recognizedText.blocks) {
        final String lang = block.recognizedLanguages.first;
        List<String> lines = [];
        for (TextLine element in block.lines) {
          lines.add(element.text);
        }
        List<Tuple> points = [];
        for (Offset element in block.cornerPoints) {
          points.add(Tuple(element.dx, element.dy));
        }
        trbList.add(TextRecognisionBlock(lang, lines, points));
      }
      trb.add(trbList);
      setState(() {
        if (trb.length == sf.files.length) {
          progress = 100;
        } else {
          progress += step.ceil();
        }
      });
    }
    sf.trb = trb;
    textRecognizer.close();
    sf.transcription = STATUS.DONE;
    widget.onSave();
    Future.delayed(const Duration(milliseconds: 500), () {
      _progressTab();
      setState(() {
        progress = -1;
      });
    });
  }

  void _progressTab() {
    if (state == FileItemSliderType.info) {
      return;
    }
    setState(() {
      if (state != FileItemSliderType.hidden) {
        state = FileItemSliderType.hidden;
      } else {
        state = FileItemSliderType.progress;
      }
    });
  }

  void _infoTab() {
    if (state == FileItemSliderType.progress) {
      return;
    }
    setState(() {
      if (state != FileItemSliderType.hidden) {
        state = FileItemSliderType.hidden;
      } else {
        state = FileItemSliderType.info;
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
            date: widget.scanFile.created,
            progress: progress,
            onRemove: (index) {
              widget.onRemove(index);
            },
          ),
          Container(
              constraints: const BoxConstraints(maxHeight: 75),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
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
                          ]),
                    ],
                  ),
                  Expanded(
                      child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 20,
                    children: [
                      GestureDetector(
                        child: FaIcon(FontAwesomeIcons.circleInfo,
                            color: AdaptiveTheme.of(context)
                                .theme
                                .iconTheme
                                .color),
                        onTap: _infoTab,
                      ),
                      GestureDetector(
                        child: FaIcon(FontAwesomeIcons.flask,
                            color: getIconColor(widget.scanFile.transcription)
                                .color),
                        onTap: () {
                          if (progress < 0) {
                            _progressTab();
                            _runTextRecognision(widget.scanFile);
                          }
                        },
                      ),
                      GestureDetector(
                        child: FaIcon(FontAwesomeIcons.solidPaperPlane,
                            color: getIconColor(widget.scanFile.cloud).color),
                        //onTap: _progressTab,
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
  const FileItem(
      {Key? key,
      required this.scanFile,
      this.index = 0,
      required this.onRemove,
      required this.onSave})
      : super(key: key);

  final ScanFile scanFile;
  final int index;
  final Future<void> Function(int index) onRemove;
  final Future<void> Function() onSave;

  @override
  State<StatefulWidget> createState() => FileItemState();
}
