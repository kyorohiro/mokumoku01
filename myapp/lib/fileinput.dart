abstract class FileInputData{
  Future<List<int>> getBinaryData(); 
}

abstract class FileInput {
  Future<List<FileInputData>> getFiles();
}

abstract class FileInputBuilder {
  FileInput create();
}
