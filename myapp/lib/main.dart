import 'dart:async';

import 'package:flutter/material.dart';

import './fileinput_web.dart' as _fileinput_web;
import './fileinput.dart' as _fileinput;
import 'package:image/image.dart' as img;
import 'package:simple_cluster/simple_cluster.dart';
//import 'dart:isolate' as iso;

_fileinput.FileInputBuilder builder = _fileinput_web.FileInputBuilderWeb();
var fileInput = builder.create(); 

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
        List<List<double>> colorsRGB = colors.map((code) {
            int alpha = (0xff000000 & code) >> 24;
            int red = (0x00ff0000 & code) >> 16;
            int green = (0x0000ff00 & code) >> 8;
            int blue = (0x000000ff & code) >> 0;
            return [red.toDouble(), green.toDouble(), blue.toDouble()];
        }).toList();
        xx(colorsRGB);
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





xx(List<List<double>> colors){
  print("Hello, World!! ${colors.length}");
  
/*
  Hierarchical hierarchical = Hierarchical(
    minCluster: 10, //stop at 2 cluster
    linkage: LINKAGE.SINGLE
  );
  print("Hello, World!!");

  List<List<int>> clusterList = hierarchical.run(colors);
  print("===== 1 =====");
  print("Clusters output");
  print(clusterList);//or hierarchical.cluster
  print("Noise");
  print(hierarchical.noise);
  print("Cluster label for points");
  print(hierarchical.label);
*/
}