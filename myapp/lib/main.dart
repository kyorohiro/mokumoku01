import 'dart:async';

import 'package:flutter/material.dart';

import './fileinput_web.dart' as _fileinput_web;
import './fileinput.dart' as _fileinput;

_fileinput.FileInputBuilder builder = _fileinput_web.FileInputBuilderWeb();
var fileInput = builder.create(); 

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: btn()));
  }
}

Widget btn() {
  return RaisedButton(
    onPressed: () async {
      print("pressed button1");
      var files = await fileInput.getFiles();
      print("pressed button2 ${files}");

      //dat.first.getBinaryData();
      //print("pressed button3");

    },
    child: Text("File Input"),
  );
}


