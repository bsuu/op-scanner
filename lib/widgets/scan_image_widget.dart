
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skan/skan_colors.dart';

class ScanImageWidgetState extends State<ScanImageWidget> {
  @override
  Widget build(BuildContext context) {

    double widthSize = (MediaQuery.of(context).size.width - 48) / 3;

    return Container(
      height: (widthSize / 9) * 14,
      width: widthSize,
      child: ClipRRect(
        child: widget.child,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: file_item_background,
        border: (widget.border) ? Border.all(width: 4, color: Colors.green) : null,
      ),
    );

  }

}

class ScanImageWidget extends StatefulWidget {

  Widget child;
  bool border;

  ScanImageWidget({Key? key, required this.child, this.border = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScanImageWidgetState();

}