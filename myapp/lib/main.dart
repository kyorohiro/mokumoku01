import 'dart:async';

import 'package:flutter/material.dart';

import './fileinput_web.dart' as _fileinput_web;
import './fileinput.dart' as _fileinput;
import 'package:image/image.dart' as img;

import './colorcode_clustring.dart' as _clust;
import './colorcode_clustring_web.dart' as _clust_web;

const int MODE_DISPLAY_FIND_COLORS = 0;
const int MODE_DISPLAY_SUMMARIZE_COLORS_ONLY = 1;
int currentAppMode  = MODE_DISPLAY_SUMMARIZE_COLORS_ONLY;

_fileinput.FileInputBuilder builder = _fileinput_web.FileInputBuilderWeb();
var fileInput = builder.create(); 

var colorCodeCluster = _clust_web.ColorCodeClustringForWeb();


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





