import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
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
    final List<String> images =
        await ScanFileStorage?.getTempImageLocation() ?? [];
    setState(() {
      this.tempImages = images;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.red),
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: ListView(
          children: [
            ReorderableWrap(
                padding: const EdgeInsets.all(15),
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (String img in tempImages)
                      ScanImageWidget(
                        child: Image.file(File(img), fit: BoxFit.fill,),
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
          ],
        ));
  }
}

class ScanView extends StatefulWidget {
  const ScanView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScanViewState();
}
