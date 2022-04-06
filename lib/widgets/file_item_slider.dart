

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skan/skan_colors.dart';

enum FileItemSliderType {

  HIDDEN(0),
  PROGRESS(3),
  INFO(55);

  const FileItemSliderType(this.size);
  final double size;
}

class FileItemSliderState extends State<FileItemSlider> {



  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInQuad,
        height: 75 + widget.state.size,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: widget.colors,
            ),
            borderRadius: BorderRadius.all(Radius.circular(18))
        )
    );
  }

}

class FileItemSlider extends StatefulWidget {

  FileItemSliderType state;
  List<Color> colors;

  FileItemSlider({Key? key, required this.state, this.colors = const [file_item_background, file_item_background]}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FileItemSliderState();
}