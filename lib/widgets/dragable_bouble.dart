import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DragableBouble extends StatefulWidget {
  const DragableBouble({
    required this.size,
    required this.onDrag,
    required this.position
  });

  final double size;
  final Function onDrag;
  final Offset position;

  @override
  State<StatefulWidget> createState() => DragableBoubleState();
}


class DragableBoubleState extends State<DragableBouble> {
  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - (boubleSize() / 2),
      top: widget.position.dy - (boubleSize() / 2),
      child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: _startDragging,
          onPanUpdate: _drag,
          onPanCancel: _cancelDragging,
          onPanEnd: _endDragging,
          child: AnimatedContainer(
            width: boubleSize(),
            height: boubleSize(),
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(boubleSize() / 2)),
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeInOut,
          )
      ),
    );
  }

  double boubleSize() {
    return dragging ? widget.size * 2 : widget.size;
  }

  void _startDragging(DragStartDetails data) {
    setState(() {
      dragging = true;
    });
    widget
        .onDrag(data.localPosition - Offset(widget.size / 2, widget.size / 2));
  }

  void _endDragging(DragEndDetails data) {
    setState(() {
      dragging = false;
    });
  }

  void _cancelDragging() {
    setState(() {
      dragging = false;
    });
  }

  void _drag(DragUpdateDetails data) {
    if (!dragging) {
      return;
    }

    widget.onDrag(data.delta);
  }
}