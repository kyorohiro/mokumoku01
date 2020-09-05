import 'dart:html' as html;
import './fileinput.dart';
import 'dart:async';

class FileInputDataWeb extends FileInputData {
  List<html.File> files;
}

class FileInputBuilderWeb extends FileInputBuilder{  
  FileInput create() {
    return FileInputWeb();
  }
}

class FileInputWeb implements FileInput { 
  @override
  Future<FileInputData> getFile() {
    print("..");
    var completr = Completer<FileInputData>();
    try {
      html.InputElement elm =  html.document.createElement('input');
      elm.type = 'file';
      elm.onChange.listen((event) {
        print("onchange");
        FileInputDataWeb inputData = FileInputDataWeb();
        inputData.files = [];
        for(var f in elm.files){
          // todo
          inputData.files.add(f);
        }
        completr.complete(inputData);
      });
      elm.click();
    } catch(e) {
      print("anything wrong ${3}");
      completr.completeError(e);
    }
    return completr.future;
  }
}


var inputFile = FileInputBuilderWeb().create();
