import 'package:flutter/material.dart';
import 'package:skan/octicons_icons.dart';
import 'package:skan/skan_colors.dart';

class ScanImageWidgetState extends State<ScanImageWidget> {
  bool _isShowed = false;

  void showHide() {
    setState(() {
      _isShowed = !_isShowed;
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthSize = (MediaQuery.of(context).size.width - 48) / 3;
    double heightSize = (widthSize / 9) * 14;

    return Stack(
      children: [
        GestureDetector(
          onTap: showHide,
          child: Container(
              height: heightSize,
              width: widthSize,
              child: ClipRRect(
                child: widget.child,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: file_item_background,
                border: (widget.border)
                    ? Border.all(width: 4, color: Colors.green)
                    : null,
              )),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _isShowed ? heightSize : 0,
          width: widthSize,
          color: Colors.red,
          curve: Curves.easeInOut,
          child: _isShowed ? Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            direction: Axis.vertical,
            children: [
              IconButton(
                  onPressed: () {
                    print("śmietnik");
                  },
                  icon: Icon(Octicons.trash_16)),
              IconButton(
                  onPressed: showHide,
                  icon: Icon(Octicons.x_16))
            ],
          ) : null,
        )
      ],
    );
  }
}

class ScanImageWidget extends StatefulWidget {
  Widget child;
  bool border;

  ScanImageWidget({Key? key, required this.child, this.border = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ScanImageWidgetState();
}
