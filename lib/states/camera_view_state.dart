import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skan/pages/camera_view.dart';

import '../skan_colors.dart';

class CameraViewState extends State<CameraView> {

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.red),
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            Text("Tu będzie kamera i skaner"),
          ],
        )
    );
  }

}