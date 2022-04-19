import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skan/provider/scan_file_storage.dart';
import 'package:skan/main.dart';
import 'package:skan/octicons_icons.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:skan/widgets/flash_button.dart';

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
    super.dispose();
    cameraController!.dispose();
  }

  void _takePicture() async {
    try {

      await _initController;

      final image = await cameraController!.takePicture();
      _provider.addTempImageLocation(image.path);
      widget.onPictureTaken(image.path);

      Navigator.of(context).pop();

    } catch (e) { print(e); }
  }

  bool click = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AdaptiveTheme.of(context).theme.backgroundColor),
      padding:
          EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 15),
      child: Column(
        children: [
          Stack(
            children: <Widget> [
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
              // StatefulBuilder(
              //     builder: ,
              //
              // ),
              FlashButton(cameraController: cameraController),
            ],
          ),
          Expanded(
              child: GestureDetector(
                child: Icon(
                  Octicons.circle_16,
                  size: 48,
                  color: AdaptiveTheme.of(context).theme.highlightColor,
                ),
                onTap: _takePicture,
              )
          ),
        ],
      ),
    );
  }
}

class CameraView extends StatefulWidget {

  Function onPictureTaken;

  CameraView({Key? key, required this.onPictureTaken}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CameraViewState();
}
