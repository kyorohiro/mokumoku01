import 'dart:html' as html;
import 'dart:typed_data';
import './fileinput.dart';
import 'dart:async';

class FileInputDataWeb extends FileInputData {
  html.File file;
  FileInputDataWeb(this.file);
  Future<List<int>> getBinaryData() async {
    Completer completer = new Completer<List<int>>();
    html.FileReader reader = new html.FileReader();
    reader.onLoad.listen((event) {
      completer.complete(reader.result);
    });
    reader.onError.listen((event) {
      completer.completeError(event);
    });
    reader.readAsArrayBuffer(this.file);
    return completer.future;
  }
}

class FileInputBuilderWeb extends FileInputBuilder{  
  FileInput create() {
    return FileInputWeb();
  }
}

class FileInputWeb implements FileInput { 
  @override
  Future<List<FileInputData>> getFiles(){
    print("..");
    var completr = Completer<List<FileInputData>>();
    try {
      html.InputElement elm =  html.document.createElement('input');
      elm.type = 'file';
      elm.onChange.listen((event) {
        print("onchange");
        var data = <FileInputData>[];
        for(var f in elm.files){
          // todo
          data.add(FileInputDataWeb(f));
        }
        completr.complete(data);
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
