
import './colorcode_clustring.dart' as _clust;
import 'dart:async';
import 'dart:html' as html;



class ColorCodeClustringForWeb extends _clust.ColorCodeClustring {
  
  Future<List<int>> compute10ColorCodes(List<int> colorCodes) {
    Completer completer = Completer<List<int>>();
    if(!html.Worker.supported) {
      throw UnsupportedError("html.Worker.supported");
    }
    var myWorker = new html.Worker("color_code_clustring.dart.js");

    myWorker.onMessage.listen((event) {
      try {
        List<dynamic> colorsSrc = event.data["o"];
        print("main:receive: ${event.data["o"]}");
        completer.complete(colorsSrc.map((e) => e as int).toList());
      } catch(e) {
        completer.completeError(e);
      }
    });

    myWorker.postMessage(colorCodes);  
    return completer.future;
  }
}