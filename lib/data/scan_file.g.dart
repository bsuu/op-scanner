// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanFile _$ScanFileFromJson(Map<String, dynamic> json) => ScanFile(
      name: json['name'] as String,
      type: json['type'] as String,
      transcription: $enumDecode(_$STATUSEnumMap, json['transcription']),
      cloud: $enumDecode(_$STATUSEnumMap, json['cloud']),
      created: DateTime.parse(json['created'] as String),
      files:
          (json['files'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$ScanFileToJson(ScanFile instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'transcription': _$STATUSEnumMap[instance.transcription],
      'cloud': _$STATUSEnumMap[instance.cloud],
      'created': instance.created.toIso8601String(),
      'files': instance.files,
    };

const _$STATUSEnumMap = {
  STATUS.RUNNING: 1,
  STATUS.DONE: 2,
  STATUS.NONE: 3,
};
