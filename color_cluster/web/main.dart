import 'dart:html';
import 'dart:html' as html;
import 'dart:math' as math;

import 'dart:typed_data';

main() async {
  List<int> colors = [];
  var rand = math.Random();
  for(int i=0;i<50;i++) {
    colors.add(rand.nextInt(0xFFFFFFFF));
  }
  if(html.Worker.supported) {
      var myWorker = new html.Worker("color_code_clustring.dart.js");

      myWorker.onMessage.listen((event) {
        List<dynamic> colorsSrc = event.data["o"];
        colorsSrc.map((e) => e as int).toList();
        print("main:receive: ${event.data["o"]}");
      });

      myWorker.postMessage(colors);
  } else {
    print('Your browser doesn\'t support web workers.');
  }
}
