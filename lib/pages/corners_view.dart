import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:skan/widgets/dragable_bouble.dart';
import 'dart:ui' as ui;

import 'package:skan_edge/skan_edge.dart';

class CornerViewState extends State<CornerView> {
  late ui.Image image;
  late List<Offset> points;
  late Uint8List data;
  bool imageLoaded = false;

  Future<ui.Image> loadImage(String path) async {
    Uri uri = Uri.parse(path);
    File file = File.fromUri(uri);
    data = file.readAsBytesSync();

    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      setState(() {
        imageLoaded = true;
      });
      return completer.complete(img);
    });
    return await completer.future;
  }

  void _init() async {
    image = await loadImage(widget.imagePath);
  }

  @override
  void initState() {
    super.initState();
    _init();
    points = [
      widget.edgeDetectionResult.topLeft,
      widget.edgeDetectionResult.topRight,
      widget.edgeDetectionResult.bottomRight,
      widget.edgeDetectionResult.bottomLeft
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: imageLoaded
          ? Stack(
        children: [
          SizedBox(
              width: image.width.toDouble(),
              height: image.height.toDouble(),
              child: CustomPaint(
                  painter: CornerPainter(
                    image: image,
                    corners: points,
                  ))),
          Positioned(
            child: DragableBouble(
              size: 20,
              onDrag: (position) {
                setState(() {
                  var currentDragPosition = Offset(
                      position.dx * image.width.toDouble(),
                      position.dy * image.height.toDouble());
                  widget.edgeDetectionResult.topLeft +=
                      currentDragPosition;
                  points[0] += currentDragPosition;
                });
              },
              onDragFinished: () {},
            ),
            left: points[0].dx * image.width.toDouble(),
            top: points[0].dy * image.height.toDouble(),
          ),
          Positioned(
            child: DragableBouble(
              size: 20,
              onDrag: (position) {
                setState(() {
                  var currentDragPosition = Offset(
                      position.dx * image.width.toDouble(),
                      position.dy * image.height.toDouble());
                  widget.edgeDetectionResult.topRight +=
                      currentDragPosition;
                  points[1] += currentDragPosition;
                });
              },
              onDragFinished: () {},
            ),
            left: points[1].dx * image.width.toDouble(),
            top: points[1].dy * image.height.toDouble(),
          ),
          Positioned(
            child: DragableBouble(
              size: 20,
              onDrag: (position) {
                setState(() {
                  var currentDragPosition = Offset(
                      position.dx * image.width.toDouble(),
                      position.dy * image.height.toDouble());
                  widget.edgeDetectionResult.bottomRight +=
                      currentDragPosition;
                  points[2] += currentDragPosition;
                });
              },
              onDragFinished: () {},
            ),
            left: points[2].dx * image.width.toDouble(),
            top: points[2].dy * image.height.toDouble(),
          ),
          Positioned(
            child: DragableBouble(
              size: 20,
              onDrag: (position) {
                setState(() {
                  var currentDragPosition = Offset(
                      position.dx / image.width.toDouble(),
                      position.dy / image.height.toDouble());
                  widget.edgeDetectionResult.bottomLeft +=
                      currentDragPosition;
                  points[3] += currentDragPosition;
                });
              },
              onDragFinished: () {},
            ),
            left: points[3].dx * image.width.toDouble(),
            top: points[3].dy * image.height.toDouble(),
          ),
        ],
      )
          : Text("Loading"),
    );
  }
}

class CornerView extends StatefulWidget {
  final String imagePath;
  final EdgeDetectionResult edgeDetectionResult;

  const CornerView(
      {Key? key, required this.imagePath, required this.edgeDetectionResult})
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

    canvas.drawImage(image, Offset.zero, Paint());

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
    return corners[0] != oldDelegate.corners[0] ||
        corners[1] != oldDelegate.corners[1] ||
        corners[2] != oldDelegate.corners[2] ||
        corners[3] != oldDelegate.corners[3];
  }
}
