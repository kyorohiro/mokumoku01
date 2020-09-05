import 'dart:async';
import 'dart:html' as html;

import 'dart:js' as js;
import 'package:js/js.dart' as pjs;
import 'package:js/js_util.dart' as js_util;
import 'package:simple_cluster/simple_cluster.dart';

@pjs.JS('self')
external dynamic get globalScopeSelf;


Stream<T> callbackToStream<J, T>(String name, T Function(J jsValue) unwrapValue) {
  var controller = StreamController<T>.broadcast(sync: true);
  js_util.setProperty(js.context['self'], name, js.allowInterop((J event) {
    controller.add(unwrapValue(event));
  }));
  return controller.stream;
}

void jsSendMessage( dynamic object, dynamic m) {
  js.context.callMethod('postMessage',[m]);
}

class ARGB {
  static int alpha(int code) => (0xff000000 & code) >> 24;
  static int red(int code)  => (0x00ff0000 & code) >> 16;
  static int green(int code) => (0x0000ff00 & code) >> 8;
  static int blue(int code) => (0x000000ff & code) >> 0;
  static int argb(int a, int r, int g, int b) {
    return 0x00 |
        ((a << 24) & 0xff000000 )|  
        ((r << 16) & 0x00ff0000 )|  
        ((g << 8) & 0x0000ff00 )| 
        ((b << 0) & 0x000000ff );
  }
}

main() {
    callbackToStream('onmessage', (html.MessageEvent e)  {
      return e;//js_util.getProperty(e, 'data');
    }).listen((message) {
      //print('>>> ${message}');
      List<dynamic> colorsSrc = message.data;
      List<List<double>> colors = [];
      try{
        // List<dynamic> to List<List<double>>
        for(var code in colorsSrc) {
            int alpha = (0xff000000 & code) >> 24;
            int red = (0x00ff0000 & code) >> 16;
            int green = (0x0000ff00 & code) >> 8;
            int blue = (0x000000ff & code) >> 0;
            colors.add([
              red.toDouble(),green.toDouble(),blue.toDouble()
            ]);
        }
        // Clustring
        var clusterList = doClustring(colors);

        // Summarize Cl;ustring Result
        var pickupColors = <int>[];
        for(var cs in clusterList) {
          num r = 0;
          num g = 0;
          num b = 0;
          for(var c in cs) {
            r += colors[c][0];
            g += colors[c][1];
            b += colors[c][2];
          }
          r = r~/cs.length;
          g = g~/cs.length;
          b = b~/cs.length;
          //print(">> ${ARGB.argb(0xff, r, g, b)} ${r} ${g} ${b}");
          pickupColors.add(ARGB.argb(0xff, r, g, b));
        }
        //print(">==>>> ${pickupColors}");
        jsSendMessage(js.context, pickupColors);
      } catch(e) {
        //print("yy:${e}");
        jsSendMessage(js.context, "error");
      }

    });
}



List<List<int>> doClustring(List<List<dynamic>> colors){
  var hierarchical = Hierarchical(
    minCluster: 10, //stop at 2 cluster
    linkage: LINKAGE.SINGLE
  );

  var clusterList = hierarchical.run(colors);
  //print("===== 1 =====");
  //print("Clusters output");
  //print(clusterList);//or hierarchical.cluster
  //print("Noise");
  //print(hierarchical.noise);
  //print("Cluster label for points");
  //print(hierarchical.label);
  return clusterList;
}

