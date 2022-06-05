
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skan/data/scan_file.dart';

class ScanFileStorage extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();

  static const _filesKey = 'files';
  static const _tempImageLocationKey = 'temp_image_location';

  Future setTempImageLocation(List<String> images) async {
    await _storage.write(key: _tempImageLocationKey, value: json.encode(images));
    notifyListeners();
  }

  Future addTempImageLocation(String image) async {
    List<String> currentTemp = await getTempImageLocation() ?? [];
    currentTemp.add(image);
    await setTempImageLocation(currentTemp);
  }

  Future<List<String>?> getTempImageLocation() async {
    final value = await _storage.read(key: _tempImageLocationKey);
    if (value == null) {
      return [];
    }
    return List<String>.from(json.decode(value));
  }

  Future setFiles(List<ScanFile> files) async {
    await _storage.write(key: _filesKey, value: json.encode(files));
    notifyListeners();
  }

  Future addFiles(ScanFile sf) async {
    List<ScanFile> currentTemp = await getFiles() ?? [];
    currentTemp.add(sf);
    await setFiles(currentTemp);
  }

  Future changeFile(ScanFile toChange, int index) async {
    List<ScanFile> currentTemp = await getFiles() ?? [];
    currentTemp[index] = toChange;
    await setFiles(currentTemp);
  }

  Future<List<ScanFile>?> getFiles() async {
    final value = await _storage.read(key: _filesKey);
    if (value == null) {
      return [];
    }
    List<dynamic> elements = json.decode(value);
    List<ScanFile> files = [];
    for (var ele in elements) {
      files.add(ScanFile.fromJson(ele));
    }
    return files;
  }


}