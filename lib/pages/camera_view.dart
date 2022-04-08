import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skan/data/scan_file_storage.dart';
import 'package:skan/main.dart';
import 'package:skan/octicons_icons.dart';
import 'package:adaptive_theme/adaptive_theme.dart';


class CameraViewState extends State<CameraView> {
  CameraController? cameraController;
  late Future<void> _initController;

  @override
  void initState() {
    super.initState();

    cameraController = CameraController(camera, ResolutionPreset.high);

    _initController = cameraController!.initialize();
  }

  @override
  void dispose() {
    cameraController!.dispose();
    super.dispose();
  }

  void _takePicture() async {
    try {

      await _initController;

      final image = await cameraController!.takePicture();
      ScanFileStorage.addTempImageLocation(image.path);

    } catch (e) { print(e); }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AdaptiveTheme.of(context).theme.backgroundColor),
      padding:
          EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 15),
      child: Column(
        children: [
          FutureBuilder(
              future: _initController,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: CameraPreview(cameraController!),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
          Expanded(
              child: GestureDetector(
                child: Icon(
                  Octicons.circle_16,
                  size: 48,
                  color: AdaptiveTheme.of(context).theme.highlightColor,
                ),
                onTap: _takePicture,
              ))
        ],
      ),
    );
  }
}

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CameraViewState();
}
