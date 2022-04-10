
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'scan_file.g.dart';

enum STATUS {
  RUNNING,
  DONE,
  NONE
}



@JsonSerializable()
class ScanFile {
  final String name;
  final String type;

  final STATUS transcription;
  final STATUS cloud;

  final List<String> files;



  ScanFile({required this.name, required this.type, required this.transcription, required this.cloud, this.files = const []});

  factory ScanFile.fromJson(Map<String, dynamic> json) => _$ScanFileFromJson(json);
  Map<String, dynamic> toJson() => _$ScanFileToJson(this);
}