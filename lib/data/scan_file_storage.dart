
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skan/data/scan_file.dart';

class ScanFileStorage {
  static final _storage = FlutterSecureStorage();

  static const _files_key = 'files';

  static Future setFiles(List<ScanFile> files) async {
    await _storage.write(key: _files_key, value: json.encode(files));
  }

  static Future<List<ScanFile>?> getFiles() async {
    final value = await _storage.read(key: _files_key);
    return List<ScanFile>.from(json.decode(value!));
  }
}