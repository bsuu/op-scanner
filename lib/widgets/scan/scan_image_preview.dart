
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reorderables/reorderables.dart';
import 'package:skan/widgets/scan/scan_image_widget.dart';

import '../../pages/camera_view.dart';

class ScanImagePreviewState extends State<ScanImagePreview> {

  void _pictureTake(String path) {
    setState(() {
      widget.files.add(path);
    });
    widget.add(path);
  }

  void viewReorder(int newIndex, int oldIndex) {
    setState(() {
      widget.files.insert(newIndex, widget.files.removeAt(oldIndex));
    });
    widget.reorder(newIndex, oldIndex);
  }

  void removeObject(int index) {
    setState(() {
      widget.files.removeAt(index);
    });
    widget.remove(index);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableWrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (int i = 0; i < widget.files.length; i++)
            ScanImageWidget(
                index: i,
                child: Image.file(
                  File(widget.files[i]),
                  fit: BoxFit.fill,
                ),
                onRemove: removeObject
            ),
          ReorderableWidget(
              child: ScanImageWidget(
                border: true,
                reactive: false,
                child: GestureDetector(
                  child: const Icon(FontAwesomeIcons.plus, size: 48),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (
                                context) => CameraView(
                              onPictureTaken: _pictureTake,
                            )));
                  },
                ),
                onRemove: () {},
              ),
              reorderable: false,
              key: const ValueKey('Enable drag'))
        ],
        onReorder: viewReorder,);

  }

}

class ScanImagePreview extends StatefulWidget {

  List<String> files;

  var reorder;
  var reload;
  var remove;
  var add;

  ScanImagePreview({Key? key, this.files = const [], required this.reorder, required this.reload, required this.remove, required this.add}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScanImagePreviewState();

}