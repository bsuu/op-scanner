import 'dart:async';
import 'dart:isolate';

import 'package:skan_edge/skan_edge.dart';

class EdgeDetector {
  static Future<void> startEdgeDetectionIsolate(EdgeDetectionInput edgeDetectionInput) async {
    EdgeDetectionResult result = await SkanEdge.detectEdges(edgeDetectionInput.inputPath);
    edgeDetectionInput.sendPort.send(result);
  }

  static Future<void> processImageIsolate(ProcessImageInput processImageInput) async {
    SkanEdge.processImage(processImageInput.inputPath, processImageInput.edgeDetectionResult, processImageInput.blockSize, processImageInput.c);
    processImageInput.sendPort.send(true);
  }

  Future<EdgeDetectionResult> detectEdges(String filePath) async {
    final port = ReceivePort();

    _spawnIsolate<EdgeDetectionInput>(
        startEdgeDetectionIsolate,
        EdgeDetectionInput(
            inputPath: filePath,
            sendPort: port.sendPort
        ),
        port
    );

    return await _subscribeToPort<EdgeDetectionResult>(port);
  }

  Future<bool> processImage(String filePath, EdgeDetectionResult edgeDetectionResult, double blockSize, double c) async {
    final port = ReceivePort();

    _spawnIsolate<ProcessImageInput>(
        processImageIsolate,
        ProcessImageInput(
            inputPath: filePath,
            edgeDetectionResult: edgeDetectionResult,
            blockSize: blockSize,
            c: c,
            sendPort: port.sendPort
        ),
        port
    );

    return await _subscribeToPort<bool>(port);
  }

  void _spawnIsolate<T>(void Function(T) function, dynamic input, ReceivePort port) {
    Isolate.spawn<T>(
        function,
        input,
        onError: port.sendPort,
        onExit: port.sendPort
    );
  }

  Future<T> _subscribeToPort<T>(ReceivePort port) async {
    var completer = new Completer<T>();
    var sub;

    sub = port.listen((result) async {
      await sub?.cancel();
      completer.complete(await result);
    });

    return completer.future;
  }
}

class EdgeDetectionInput {
  EdgeDetectionInput({
    required this.inputPath,
    required this.sendPort
  });

  String inputPath;
  SendPort sendPort;
}

class ProcessImageInput {
  ProcessImageInput({
    required this.inputPath,
    required this.edgeDetectionResult,
    required this.blockSize,
    required this.c,
    required this.sendPort
  });

  String inputPath;
  EdgeDetectionResult edgeDetectionResult;
  double blockSize;
  double c;
  SendPort sendPort;
}