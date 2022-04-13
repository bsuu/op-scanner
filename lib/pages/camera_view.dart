import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skan/provider/scan_file_storage.dart';
import 'package:skan/main.dart';
import 'package:skan/octicons_icons.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CameraViewState extends State<CameraView> {
  CameraController? cameraController;
  Future<void>? _initController;

  late final ScanFileStorage _provider;

  Future<void> _loadCamera() async {
    cameraController = CameraController(camera, ResolutionPreset.ultraHigh);
    _initController = cameraController!.initialize();
    await _initController;
  }


  @override
  void initState() {
    super.initState();
    _provider = Provider.of<ScanFileStorage>(context, listen: false);
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
      _provider.addTempImageLocation(image.path);

      Navigator.of(context).pop();
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
          ToggleSwitch(
            totalSwitches: 2,
            minWidth: 55,
            minHeight: 25,
            onToggle: (index) {
              if (index == 0) {
                cameraController?.setFlashMode(FlashMode.off);
              } else {
                cameraController?.setFlashMode(FlashMode.always);
              }
            },
            customIcons: [
              Icon(Octicons.moon_16, color: Colors.black, size: 16,),
              Icon(Octicons.light_bulb_16, color: Colors.orange, size: 16,)
            ],
          ),
          FutureBuilder(
              future: _loadCamera(),
              builder: (context, snapshot) {
                print(snapshot);
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
