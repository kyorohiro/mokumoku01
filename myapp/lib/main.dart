import 'dart:async';

import 'package:flutter/material.dart';

import './fileinput_web.dart' as _fileinput_web;
import './fileinput.dart' as _fileinput;
import 'package:image/image.dart' as img;

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
  Map<int,bool> colors = {};

  @override
  Widget build(BuildContext context) {
    //this.widget.data
    if(!extracting) {
      extracting = true;
      new Future(()async {
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
            colors[pixel.ceil()] = true;
          }
        }
        print("....2 ${colors.keys}");
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
              children: colors.keys.map((e) {
                  return Container(child: Text("${e}"),color: Color(e),);
                }
              ).toList(),
            )
          ),
      );
    }

  }
}

