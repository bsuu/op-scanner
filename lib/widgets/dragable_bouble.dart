import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DragableBoubleState extends State<DragableBouble> {
  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: _startDragging,
        onPanUpdate: _drag,
        onPanCancel: _cancelDragging,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(widget.size / 2)),
        ));
  }

  void _startDragging(DragStartDetails data) {
    setState(() {
      dragging = true;
    });
    widget
        .onDrag(data.localPosition - Offset(widget.size / 2, widget.size / 2));
  }

  void _cancelDragging() {
    setState(() {
      dragging = false;
    });
    widget.onDragFinished();
  }

  void _drag(DragUpdateDetails data) {
    if (!dragging) {
      return;
    }

    widget.onDrag(data.delta);
  }
}

class DragableBouble extends StatefulWidget {
  const DragableBouble({
    required this.size,
    required this.onDrag,
    required this.onDragFinished,
  });

  final double size;
  final Function onDrag;
  final Function onDragFinished;

  @override
  State<StatefulWidget> createState() => DragableBoubleState();
}
