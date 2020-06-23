import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
class RecordCache{

  final String fileName = "recordData.json";

    // get local path of documents directory
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // get file
  Future<File> get _localFile async {
    final path = await _localPath;
    return new File('$path/$fileName');
  }

  // write to file
  Future<void> writeRecordData(Map<String,dynamic> data) async {
    final file = await _localFile;
    file.writeAsStringSync(json.encode(data));
  }

  // read the file contents
  Future<Map> getRecordData() async {
    Map<String,dynamic> contents;

    try {
      final file = await _localFile;

      // read the file
      contents =  jsonDecode(file.readAsStringSync());

    } catch(e) {
      print(e);
    }

    return contents;
  }

  Future<FileSystemEntity> removeRecordDataFile() async {

    final file = await _localFile;
    return file.delete();
  }

  Future<bool> recordDataFileExists() async {

    File settingsFile = await _localFile;

    if(await settingsFile.exists()) {
    return true;
    }

    return false;
  }

}