import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skan/widgets/dragable_bouble.dart';
import 'dart:ui' as ui;

import 'package:skan_edge/skan_edge.dart';

import '../edge_detector.dart';
import '../provider/scan_file_storage.dart';

class CornerViewState extends State<CornerView> {
  late ui.Image image;
  late List<Offset> points;
  late Uint8List data;

  late EdgeDetectionResult edgeDetectionResult;
  late final ScanFileStorage _provider;

  bool imageLoaded = false;
  bool cornersLoaded = false;
  double boubleSize = 100;

  Future<ui.Image> loadImage(String path) async {
    Uri uri = Uri.parse(path);
    File file = File.fromUri(uri);
    data = file.readAsBytesSync();

    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      return completer.complete(img);
    });
    return await completer.future;
  }

  void _initImage() async {
    image = await loadImage(widget.imagePath);
    setState(() {
      imageLoaded = true;
    });
  }

  void _initCorners() async {
    edgeDetectionResult = await EdgeDetector().detectEdges(widget.imagePath);
    List<Offset> test = [
      const Offset(0.0, 0.0),
      const Offset(1.0, 0.0),
      const Offset(1.0, 1.0),
      const Offset(0.0, 1.0)
    ];
    var resultPoints = [
      edgeDetectionResult.topLeft,
      edgeDetectionResult.topRight,
      edgeDetectionResult.bottomRight,
      edgeDetectionResult.bottomLeft
    ];
    if (listEquals(test, resultPoints)) {
      resultPoints = [
        const Offset(0.2, 0.2),
        const Offset(0.8, 0.2),
        const Offset(0.8, 0.8),
        const Offset(0.2, 0.8)
      ];
    }

    setState(() {
      points = resultPoints;
      cornersLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<ScanFileStorage>(context, listen: false);
    _initImage();
    _initCorners();
  }

  void _saveWithCorners(bool nextPhoto) async {

    edgeDetectionResult.topLeft = points[0];
    edgeDetectionResult.topRight = points[1];
    edgeDetectionResult.bottomRight = points[2];
    edgeDetectionResult.bottomLeft = points[3];

    await SkanEdge.processImage(widget.imagePath, edgeDetectionResult, 99, 6);
    _provider.addTempImageLocation(widget.imagePath);
    widget.onPictureTaken(widget.imagePath);

    Navigator.of(context).pop();
    if (!nextPhoto) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonSize = MediaQuery.of(context).size.width / 7;
    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          child: imageLoaded
              ? Stack(
                  children: [
                    SizedBox(
                        width: image.width.toDouble(),
                        height: image.height.toDouble(),
                        child: CustomPaint(
                            painter: CornerPainter(
                          image: image,
                          corners: cornersLoaded ? points : [],
                        ))),
                    if (cornersLoaded)
                      DragableBouble(
                        size: boubleSize,
                        onDrag: (position) {
                          edgeDetectionResult.topLeft += Offset(
                              position.dx / image.width.toDouble(),
                              position.dy / image.height.toDouble());
                          setState(() {
                            points[0] += Offset(
                                position.dx / image.width.toDouble(),
                                position.dy / image.height.toDouble());
                          });
                        },
                        position: Offset(points[0].dx * image.width.toDouble(),
                            points[0].dy * image.height.toDouble()),
                      ),
                    if (cornersLoaded)
                      DragableBouble(
                        size: boubleSize,
                        onDrag: (position) {
                          edgeDetectionResult.topRight += Offset(
                              position.dx / image.width.toDouble(),
                              position.dy / image.height.toDouble());
                          setState(() {
                            points[1] += Offset(
                                position.dx / image.width.toDouble(),
                                position.dy / image.height.toDouble());
                          });
                        },
                        position: Offset(points[1].dx * image.width.toDouble(),
                            points[1].dy * image.height.toDouble()),
                      ),
                    if (cornersLoaded)
                      DragableBouble(
                        size: boubleSize,
                        onDrag: (position) {
                          edgeDetectionResult.bottomRight += Offset(
                              position.dx / image.width.toDouble(),
                              position.dy / image.height.toDouble());
                          setState(() {
                            points[2] += Offset(
                                position.dx / image.width.toDouble(),
                                position.dy / image.height.toDouble());
                          });
                        },
                        position: Offset(points[2].dx * image.width.toDouble(),
                            points[2].dy * image.height.toDouble()),
                      ),
                    if (cornersLoaded)
                      DragableBouble(
                        size: boubleSize,
                        onDrag: (position) {
                          edgeDetectionResult.bottomLeft += Offset(
                              position.dx / image.width.toDouble(),
                              position.dy / image.height.toDouble());
                          setState(() {
                            points[3] += Offset(
                                position.dx / image.width.toDouble(),
                                position.dy / image.height.toDouble());
                          });
                        },
                        position: Offset(points[3].dx * image.width.toDouble(),
                            points[3].dy * image.height.toDouble()),
                      ),
                  ],
                )
              : const CircularProgressIndicator(),
        ),
        if (cornersLoaded)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                  child: Container(
                    child: const Icon(FontAwesomeIcons.floppyDisk),
                    width: buttonSize,
                    height: buttonSize,
                    margin: EdgeInsets.only(
                        right: buttonSize / 2, bottom: buttonSize / 2),
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(buttonSize / 2)),
                  ),
                  onTap: () {
                    _saveWithCorners(false);
                  }),
              GestureDetector(
                  child: Container(
                      child: const Icon(FontAwesomeIcons.plus),
                      width: buttonSize,
                      height: buttonSize,
                      margin: EdgeInsets.only(bottom: buttonSize / 2),
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(buttonSize / 2))),
                  onTap: () {
                    _saveWithCorners(true);
                  })
            ],
          )
      ],
    );
  }
}

class CornerView extends StatefulWidget {
  final String imagePath;
  final Function onPictureTaken;

  const CornerView(
      {Key? key, required this.imagePath, required this.onPictureTaken})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => CornerViewState();
}

class CornerPainter extends CustomPainter {
  CornerPainter({required this.corners, required this.image});

  List<Offset> corners;

  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());

    if (corners.length < 4) {
      return;
    }

    double top = 0.0;
    double left = 0.0;

    double renderedImageHeight = size.height;
    double renderedImageWidth = size.width;

    double widthFactor = size.width / image.width;
    double heightFactor = size.height / image.height;
    double sizeFactor = min(widthFactor, heightFactor);

    renderedImageHeight = image.height * sizeFactor;
    top = ((size.height - renderedImageHeight) / 2);

    renderedImageWidth = image.width * sizeFactor;
    left = ((size.width - renderedImageWidth) / 2);

    final points = [
      Offset(left + corners[0].dx * renderedImageWidth,
          top + corners[0].dy * renderedImageHeight),
      Offset(left + corners[1].dx * renderedImageWidth,
          top + corners[1].dy * renderedImageHeight),
      Offset(left + corners[2].dx * renderedImageWidth,
          top + (corners[2].dy * renderedImageHeight)),
      Offset(left + corners[3].dx * renderedImageWidth,
          top + corners[3].dy * renderedImageHeight),
      Offset(left + corners[0].dx * renderedImageWidth,
          top + corners[0].dy * renderedImageHeight),
    ];

    final paint = Paint()
      ..color = const Color.fromARGB(125, 201, 30, 153)
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawPoints(ui.PointMode.polygon, points, paint);

    for (Offset point in points) {
      canvas.drawCircle(point, 10, paint);
    }
  }

  @override
  bool shouldRepaint(CornerPainter oldDelegate) {
    return corners.length != oldDelegate.corners.length ||
        corners[0] != oldDelegate.corners[0] ||
        corners[1] != oldDelegate.corners[1] ||
        corners[2] != oldDelegate.corners[2] ||
        corners[3] != oldDelegate.corners[3];
  }
}
