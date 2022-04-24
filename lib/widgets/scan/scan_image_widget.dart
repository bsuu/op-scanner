import 'package:adaptive_theme/adaptive_theme.dart';
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
                    ? Border.all(width: 4, color: AdaptiveTheme.of(context).theme.highlightColor)
                    : null,
              )),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _isShowed ? heightSize : 0,
          width: widthSize,
          color: AdaptiveTheme.of(context).theme.highlightColor,
          curve: Curves.easeInOut,
          child: _isShowed ? Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            direction: Axis.vertical,
            children: [
              IconButton(
                  icon: Icon(Octicons.trash_16, color: AdaptiveTheme.of(context).theme.iconTheme.color,),
              onPressed: () {
                widget.onRemove(widget.index);
                showHide();
              }),

              IconButton(
                  onPressed: showHide,
                  icon: Icon(Octicons.x_16, color: AdaptiveTheme.of(context).theme.iconTheme.color,))
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

  int index;

  Function onRemove;

  ScanImageWidget({Key? key, required this.child, this.border = false, required this.onRemove, this.index = 0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ScanImageWidgetState();
}
