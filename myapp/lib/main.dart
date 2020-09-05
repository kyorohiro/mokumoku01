import 'dart:async';

import 'package:flutter/material.dart';

import './fileinput_web.dart' as _fileinput_web;
import './fileinput.dart' as _fileinput;
import 'package:image/image.dart' as img;

import 'dart:html' as html;
import 'dart:math' as math;


const int MODE_DISPLAY_FIND_COLORS = 0;
const int MODE_DISPLAY_SUMMARIZE_COLORS_ONLY = 1;
int currentAppMode  = MODE_DISPLAY_SUMMARIZE_COLORS_ONLY;

abstract class ColorCodeClustring {
  Future<List<int>> compute10ColorCodes(List<int> colorCodes);
}

class ColorCodeClustringForWeb extends ColorCodeClustring {
  
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

_fileinput.FileInputBuilder builder = _fileinput_web.FileInputBuilderWeb();
var fileInput = builder.create(); 

var colorCodeCluster = ColorCodeClustringForWeb();


void main() {
  runApp(MaterialApp(
    theme: ThemeData.light().copyWith(primaryColor: Colors.yellow[700]),
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Codes'),
      ),
      body: Center(child: btn(context)));
  }
}

Widget btn(BuildContext context) {
  return RaisedButton(
    onPressed: () async {
        var files = await fileInput.getFiles();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyImage(files.first))
        );

      //print("pressed button1");
      //var files = await fileInput.getFiles();
      //print("pressed button2 ${files}");

      //dat.first.getBinaryData();
      //print("pressed button3");

    },
    child: Text("File Input"),
  );
}

class MyImage extends StatefulWidget {

  _fileinput.FileInputData data;

  MyImage(this.data) {
  }

  @override
  _MyImageState createState() => _MyImageState();
}

class _MyImageState extends State<MyImage> {
  bool extracting = false;
  bool extractedData = false;
  List<int> colors = [];

  @override
  Widget build(BuildContext context) {
    //this.widget.data
    if(!extracting) {
      extracting = true;

      new Future(()async {
        // todo isolate ...
        Map<int,bool> colorsSet = {};

        // 
        print("extract binary");
        var binary = await this.widget.data.getBinaryData();

        //
        print("extract color codes");
        img.Image image = img.decodeImage(binary);
        int w = image.width;
        int h = image.height;
        for(int x = 0; x<w;x++) {
          for(int y=0;y<h;y++) {
            var pixel = image.getPixel(x, y);
            colorsSet[pixel.ceil()] = true;
          }
        }
        print("....2 ${colorsSet.keys}");
        colors = colorsSet.keys.toList();
        colors.sort();
        if(currentAppMode == MODE_DISPLAY_SUMMARIZE_COLORS_ONLY) {
          colors = await colorCodeCluster.compute10ColorCodes (colors);
        }
        //xx(colorsRGB);
        setState(() {
          extractedData = true;
        });
      });
    }

    if(!extractedData) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Your Color Codes'),
          ),
          body: Center(
            child: Text("Now Extracting"),
          ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Your Color Codes'),
          ),
          body: Center(
            child: ListView(
              children: colors.map((e) {
                  var c = Color(e);
                  return Container(child: Text("rgba : ${c.red} ${c.green} ${c.blue} ${c.alpha}"),color: c,);
                }
              ).toList(),
            )
          ),
      );
    }

  }
}





