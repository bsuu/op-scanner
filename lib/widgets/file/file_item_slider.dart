import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skan/octicons_icons.dart';

enum FileItemSliderType {
  HIDDEN,
  PROGRESS,
  INFO,
}

class FileItemSliderState extends State<FileItemSlider> {
  var sizes = {
    FileItemSliderType.HIDDEN: 0.0,
    FileItemSliderType.PROGRESS: 5.0,
    FileItemSliderType.INFO: 80.0,
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInQuad,
      height: 75.0 + sizes[widget.state]! ,
      width: double.infinity,
      padding: EdgeInsets.only(
          left: 10, right: 40, bottom: 10, top: sizes[widget.state]!),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AdaptiveTheme.of(context).theme.primaryColor,
              AdaptiveTheme.of(context).theme.primaryColor
            ]),
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: Row(children: (widget.state == FileItemSliderType.INFO) ? [
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
          Row(
            children: [
              Icon(Octicons.clock_16, size: 18),
              Text("  22.02.2001", style: TextStyle(fontSize: 16)),
            ],
          ),
                  Row(
                    children: [
                      Icon(Octicons.clock_16, size: 18),
                      Text("  22.02.2001", style: TextStyle(fontSize: 16)),
                    ],
                  ),
          Row(
            children: [
              Icon(Octicons.clock_16, size: 18),
              Text("  22.02.2001", style: TextStyle(fontSize: 16)),
            ],
          ),
        ])),
        Icon(
          Octicons.trash_16,
          size: 30,
        )
      ] : []),
      // child: Center(
      //   heightFactor: 10,
      //     child: ListView(
      //   padding: EdgeInsets.only(left: 10, top: sizes[widget.state]!),
      //   shrinkWrap: true,
      //   physics: BouncingScrollPhysics(),
      //   children: [
      //     Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: [
      //         Icon(Octicons.clock_16, size: 18),
      //         Text("  22.02.2001", style: TextStyle(
      //           fontSize: 16,
      //         ),)
      //       ],
      //     ),
      //     SizedBox(
      //       height: 4,
      //     ),
      //     Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: [
      //         Icon(Octicons.database_16, size: 18),
      //         Text("  10kB", style: TextStyle(
      //           fontSize: 16,
      //         ))
      //       ],
      //     ),
      //     SizedBox(
      //       height: 4,
      //     ),
      //     Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: [
      //         Icon(Octicons.database_16, size: 18),
      //         Text("  10kB", style: TextStyle(
      //           fontSize: 16,
      //         ))
      //       ],
      //     )
      //   ],
      // )),
    );
  }
}

class FileItemSlider extends StatefulWidget {
  FileItemSliderType state;

  FileItemSlider({Key? key, required this.state}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FileItemSliderState();
}
