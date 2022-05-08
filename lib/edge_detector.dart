import 'dart:async';
import 'dart:isolate';

import 'package:skan_edge/skan_edge.dart';

class EdgeDetector {
  static Future<void> startEdgeDetectionIsolate(EdgeDetectionInput edgeDetectionInput) async {
    EdgeDetectionResult result = await SkanEdge.detectEdges(edgeDetectionInput.inputPath);
    edgeDetectionInput.sendPort.send(result);
  }

  Future<EdgeDetectionResult> detectEdges(String filePath) async {
    // Creating a port for communication with isolate and arguments for entry point
    final port = ReceivePort();

    // Spawning an isolate
    Isolate.spawn<EdgeDetectionInput>(
        startEdgeDetectionIsolate,
        EdgeDetectionInput(
            inputPath: filePath,
            sendPort: port.sendPort
        ),
        onError: port.sendPort,
        onExit: port.sendPort
    );

    // Making a variable to store a subscription in
    // Listening for messages on port

    var completer = Completer<EdgeDetectionResult>();
    var sub;

    sub = port.listen((result) async {
      // Cancel a subscription after message received called
      await sub.cancel();
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