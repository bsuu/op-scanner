import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skan/main.dart';
import 'package:skan/octicons_icons.dart';
import 'package:skan/pages/corners_view.dart';
import 'package:skan/provider/scan_file_storage.dart';
import 'package:skan/widgets/flash_button.dart';
import 'package:skan_edge/skan_edge.dart';

import '../edge_detector.dart';

class CameraViewState extends State<CameraView> {
  CameraController? cameraController;
  Future<void>? _initController;

  bool pictureInProgress = false;

  Future<void> _loadCamera() async {
    cameraController = CameraController(camera, ResolutionPreset.ultraHigh);
    _initController = cameraController!.initialize();
    await _initController;
  }

  @override
  void initState() {
    super.initState();
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
      pictureInProgress = false;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CornerView(
                  imagePath: image.path,
                  onPictureTaken: widget.onPictureTaken)));

      //Navigator.of(context).pop();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: AdaptiveTheme.of(context).theme.backgroundColor),
      padding:
          EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 15),
      child: Column(
        children: [
          Stack(
            children: <Widget>[
              FutureBuilder(
                  future: _loadCamera(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Stack(children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: CameraPreview(cameraController!),
                        ),
                        FlashButton(cameraController: cameraController),
                      ]);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          ),
          Expanded(
              child: (!pictureInProgress)
                  ? GestureDetector(
                      child: Icon(
                        FontAwesomeIcons.circle,
                        size: 48,
                        color: AdaptiveTheme.of(context).theme.highlightColor,
                      ),
                      onTap: () {
                        pictureInProgress = true;
                        _takePicture();
                      },
                    )
                  : Icon(
                      FontAwesomeIcons.spinner,
                      size: 48,
                      color: AdaptiveTheme.of(context).theme.highlightColor,
                    )),
        ],
      ),
    );
  }
}

class CameraView extends StatefulWidget {
  final Function onPictureTaken;

  const CameraView({Key? key, required this.onPictureTaken}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CameraViewState();
}
