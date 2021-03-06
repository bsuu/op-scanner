import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skan/data/text_recognision_block.dart';
import 'package:skan/themes.dart';
import 'package:skan/widgets/file/file_item_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/scan_file.dart';

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
    String p = await sf.getScanLocation();
    for (String file in sf.files) {
      final InputImage image = InputImage.fromFilePath("$p/$file");
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
        for (Point<int> element in block.cornerPoints) {
          points.add(Tuple(element.x, element.y));
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

  Future<void> _sendToDatabase(ScanFile scan) async {
    setState(() {
      scan.cloud = STATUS.RUNNING;
      progress = 0;
    });
    final user = FirebaseAuth.instance.currentUser!;
    final userMail = user.email;
    if (userMail != null) {
      ScanFile scanFile = widget.scanFile;
      scanFile.cloud = STATUS.DONE;
      final storage = FirebaseStorage.instance.ref();
      final fileName = scanFile.uuid;
      final files = storage.child("$userMail/$fileName.zip");
      final encoder = ZipFileEncoder();
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      final File file = File('$tempPath/fileData.json');
      file.writeAsStringSync(json.encoder.convert(scanFile));
      encoder.create('$tempPath/$fileName');
      encoder.addFile(file);
      String scanDir = await scanFile.getScanLocation();
      for (int i = 0; i < scanFile.files.length; i++) {
        encoder.addFile(File("$scanDir/${scanFile.files[i]}"));
      }
      encoder.close();
      final task = files.putFile(File('$tempPath/$fileName'));
      task.snapshotEvents.listen((event) {
        setState(() {
          progress = (event.bytesTransferred.toDouble() /
                  event.totalBytes.toDouble() *
                  100)
              .toInt();
        });
      });
    }
    scan.cloud = STATUS.DONE;
    widget.onSave();
    Future.delayed(const Duration(milliseconds: 500), () {
      _progressTab();
      setState(() {
        progress = -1;
      });
    });
  }


  Future<void> _removeFromDatabase(ScanFile scanFile) async {
    final user = FirebaseAuth.instance.currentUser!;
    final String? userMail = user.email;
    final String name = scanFile.uuid;
    Reference fbs = FirebaseStorage.instance.ref();
    Reference fbsf = fbs.child("$userMail/$name.zip");
    await fbsf.delete();
  }

  Future<void> _updateFile(ScanFile scanFile) async {
    await _runTextRecognision(scanFile);
    await _removeFromDatabase(scanFile);
    await _sendToDatabase(scanFile);
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
              if (widget.scanFile.cloud == STATUS.DONE) {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    backgroundColor:
                        AdaptiveTheme.of(context).theme.backgroundColor,
                    elevation: 0,
                    child: Container(
                        margin:
                            const EdgeInsets.only(right: 14, left: 14, top: 16),
                        padding: const EdgeInsets.all(6),
                        child: Wrap(
                          alignment: WrapAlignment.spaceAround,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              child: Text(
                                  'Usun???? "' + widget.scanFile.name + '"?',
                                  style: AdaptiveTheme.of(context)
                                      .theme
                                      .textTheme
                                      .headline1),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              child: Text(
                                  'Usuni??cie pliku spowoduje r??wnie?? usuni??cie pilku w chmurze. Usuni??cie jest trwa??e i nieodwracalne. Czy na pewno usun?????',
                                  style: AdaptiveTheme.of(context)
                                      .theme
                                      .textTheme
                                      .bodyText1),
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                TextButton(
                                  child: Text('Nie',
                                      style: AdaptiveTheme.of(context)
                                          .theme
                                          .textTheme
                                          .headline1),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: Text('Tak',
                                      style: AdaptiveTheme.of(context)
                                          .theme
                                          .textTheme
                                          .headline1),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _removeFromDatabase(widget.scanFile);
                                    widget.onRemove(index);
                                  },
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                );
              } else {
                widget.onRemove(index);
              }
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
                          if (progress < 0 && widget.scanFile.cloud == STATUS.DONE) {
                            _progressTab();
                            _updateFile(widget.scanFile);
                          } else if (progress < 0 && widget.scanFile.cloud != STATUS.DONE) {
                            _progressTab();
                            _runTextRecognision(widget.scanFile);
                          }
                        },
                      ),
                      GestureDetector(
                          child: FaIcon(FontAwesomeIcons.solidPaperPlane,
                              color: (FirebaseAuth.instance.currentUser != null) ? getIconColor(widget.scanFile.cloud).color : AdaptiveTheme.of(context).theme.iconTheme.color),
                          onTap: () {
                            if (progress < 0 &&
                                widget.scanFile.cloud != STATUS.DONE) {
                              _progressTab();
                              _sendToDatabase(widget.scanFile);
                            }
                          })
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
