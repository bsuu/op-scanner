import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum FileItemSliderType {
  HIDDEN,
  PROGRESS,
  INFO,
}

class FileItemSliderState extends State<FileItemSlider> {

  var sizes = {
    FileItemSliderType.HIDDEN: 0,
    FileItemSliderType.PROGRESS: 5,
    FileItemSliderType.INFO: 75,
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInQuad,
        height: 75.0 + sizes[widget.state]!,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [AdaptiveTheme.of(context).theme.primaryColor, AdaptiveTheme.of(context).theme.primaryColor]
            ),
            borderRadius: BorderRadius.all(Radius.circular(18))
        )
    );
  }

}

class FileItemSlider extends StatefulWidget {

  FileItemSliderType state;

  FileItemSlider({Key? key, required this.state}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FileItemSliderState();
}