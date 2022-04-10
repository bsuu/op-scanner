
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skan/data/scan_file.dart';

class ScanFileStorage {
  static final _storage = FlutterSecureStorage();

  static const _files_key = 'files';
  static const _temp_image_location = 'temp_image_location';

  static Future setTempImageLocation(List<String> images) async {
    await _storage.write(key: _temp_image_location, value: json.encode(images));
  }

  static Future addTempImageLocation(String image) async {
    List<String> currentTemp = await getTempImageLocation() ?? [];
    currentTemp.add(image);
    await setTempImageLocation(currentTemp);
  }

  static Future<List<String>?> getTempImageLocation() async {
    final value = await _storage.read(key: _temp_image_location);
    if (value == null) {
      return [];
    }
    return List<String>.from(json.decode(value));
  }

  static Future setFiles(List<ScanFile> files) async {
    await _storage.write(key: _files_key, value: json.encode(files));
  }

  static Future addTFiles(ScanFile sf) async {
    List<ScanFile> currentTemp = await getFiles() ?? [];
    currentTemp.add(sf);
    await setFiles(currentTemp);
  }

  static Future<List<ScanFile>?> getFiles() async {
    final value = await _storage.read(key: _files_key);
    if (value == null) {
      return [];
    }
    return List<ScanFile>.from(json.decode(value));
  }


}