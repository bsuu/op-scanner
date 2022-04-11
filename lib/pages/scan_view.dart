import 'dart:io';

import 'package:camera/camera.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reorderables/reorderables.dart';
import 'package:skan/data/scan_file.dart';
import 'package:skan/data/scan_file_storage.dart';
import 'package:skan/octicons_icons.dart';
import 'package:skan/pages/camera_view.dart';
import 'package:skan/widgets/scan_image_widget.dart';

class ScanViewState extends State<ScanView> {
  List<String> tempImages = [];

  void _reoder(int oldIndex, int newIndex) {
    setState(() {
      String tmp = tempImages.removeAt(oldIndex);
      tempImages.insert(newIndex, tmp);
      ScanFileStorage.setTempImageLocation(tempImages);
    });
  }

  @override
  void initState() {
    super.initState();
    loadTempImages();
  }

  Future loadTempImages() async {
    tempImages = await ScanFileStorage?.getTempImageLocation() ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AdaptiveTheme.of(context).theme.backgroundColor),
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top, left: 8, right: 8),
        child: SingleChildScrollView( child: Column(children: [
          ReorderableWrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (String img in tempImages)
                  ScanImageWidget(
                    child: Image.file(
                      File(img),
                      fit: BoxFit.fill,
                    ),
                  ),
                ReorderableWidget(
                    child: ScanImageWidget(
                      border: true,
                      child: GestureDetector(
                        child: Icon(
                          Octicons.plus_16,
                          size: 48,
                        ),
                        onTap: () {
                          print("next page");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CameraView()));
                        },
                      ),
                    ),
                    reorderable: false,
                    key: ValueKey('Enable drag'))
              ],
              onReorder: _reoder),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AdaptiveTheme.of(context).theme.highlightColor),
                  borderRadius: BorderRadius.circular(16),
                ),
                hintText: 'Nazwa pliku',
              ),
            ), 
            
          ),
          GestureDetector(
              onTap: () {
                ScanFile sf = ScanFile(name: "test", type: "test", cloud:  STATUS.NONE, transcription:  STATUS.NONE, files:  tempImages);
                ScanFileStorage.addTFiles(sf);
                tempImages = [];
                ScanFileStorage.setTempImageLocation(tempImages);
                setState(() {

                });
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 14 + 65, top: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: AdaptiveTheme.of(context).theme.primaryColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 15,
                      children: [
                        Icon(Octicons.file_16,
                            size: 24,
                            color: AdaptiveTheme.of(context)
                                .theme
                                .iconTheme
                                .color),
                        Text(
                          "Zapisz plik",
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .headline1,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ))
                  ],
                ),
              ))
        ])));
  }
}

class ScanView extends StatefulWidget {
  const ScanView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScanViewState();
}
