
import 'package:json_annotation/json_annotation.dart';
import 'package:skan/data/text_recognision_block.dart';

part 'scan_file.g.dart';

enum STATUS {
  @JsonValue(1)
  RUNNING,
  @JsonValue(2)
  DONE,
  @JsonValue(3)
  NONE
}



@JsonSerializable()
class ScanFile {
  final String name;
  final String type;

  STATUS transcription;
  STATUS cloud;

  final DateTime created;

  final List<String> files;
  List<List<TextRecognisionBlock>> trb;



  ScanFile({required this.name, required this.type, required this.transcription, required this.cloud, required this.created, this.files = const [], this.trb = const []});

  factory ScanFile.fromJson(Map<String, dynamic> json) => _$ScanFileFromJson(json);
  Map<String, dynamic> toJson() => _$ScanFileToJson(this);
}