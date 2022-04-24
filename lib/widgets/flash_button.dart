import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../octicons_icons.dart';

class FlashButtonState extends State<FlashButton> {
  bool click = false;

  @override
  Widget build(BuildContext context) {
    double height = (MediaQuery.of(context).size.height);
    return Container(
      height: height - 160,
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
          focusColor: AdaptiveTheme.of(context).theme.highlightColor,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            child: Icon(click ? Octicons.flash_on_outlined : Octicons.flash_off_sharp, color: Colors.orange, size: 20,),
          ),
          onPressed: () {
            setState(() {
              click = !click;
            });
            click ? widget.cameraController?.setFlashMode(FlashMode.always) : widget.cameraController?.setFlashMode(FlashMode.off);
          }),
    );
  }

}

class FlashButton extends StatefulWidget {

  final CameraController? cameraController;

  const FlashButton({
    Key? key,
    required this.cameraController,


  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FlashButtonState();
}