
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skan/data/scan_file.dart';

class ScanFileStorage extends ChangeNotifier {
  static final _storage = FlutterSecureStorage();

  static const _files_key = 'files';
  static const _temp_image_location = 'temp_image_location';

  Future setTempImageLocation(List<String> images) async {
    await _storage.write(key: _temp_image_location, value: json.encode(images));
    notifyListeners();
  }

  Future addTempImageLocation(String image) async {
    List<String> currentTemp = await getTempImageLocation() ?? [];
    currentTemp.add(image);
    await setTempImageLocation(currentTemp);
  }

  Future<List<String>?> getTempImageLocation() async {
    final value = await _storage.read(key: _temp_image_location);
    if (value == null) {
      return [];
    }
    return List<String>.from(json.decode(value));
  }

  Future setFiles(List<ScanFile> files) async {
    await _storage.write(key: _files_key, value: json.encode(files));
    notifyListeners();
  }

  Future addFiles(ScanFile sf) async {
    List<ScanFile> currentTemp = await getFiles() ?? [];
    currentTemp.add(sf);
    await setFiles(currentTemp);
  }

  Future<List<ScanFile>?> getFiles() async {
    final value = await _storage.read(key: _files_key);
    if (value == null) {
      return [];
    }
    List<dynamic> elementy = json.decode(value);
    List<ScanFile> files = [];
    for (var ele in elementy)
      files.add(ScanFile.fromJson(ele));
    return files;
  }


}