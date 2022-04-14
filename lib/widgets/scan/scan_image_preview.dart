
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:skan/widgets/scan/scan_image_widget.dart';

import '../../octicons_icons.dart';
import '../../pages/camera_view.dart';

class ScanImagePreviewState extends State<ScanImagePreview> {

  void _picture_take(String path) {
    print("siema");
    setState(() {
      widget.files.add(path);
    });
  }

  void viewReorder(int newIndex, int oldIndex) {
    setState(() {
      widget.files.insert(newIndex, widget.files.removeAt(oldIndex));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableWrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (String img in widget.files)
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
                  child: const Icon(Octicons.plus_16, size: 48),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (
                                context) => CameraView(
                              onPictureTaken: _picture_take,
                            )));
                  },
                ),
              ),
              reorderable: false,
              key: const ValueKey('Enable drag'))
        ],
        onReorder: (int newIndex, int oldIndex) {
          viewReorder(newIndex, oldIndex);
          widget.reorder(newIndex, oldIndex);
        },);

  }

}

class ScanImagePreview extends StatefulWidget {

  List<String> files;

  var reorder;
  var reload;

  ScanImagePreview({Key? key, this.files = const [], required this.reorder, required this.reload}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScanImagePreviewState();

}