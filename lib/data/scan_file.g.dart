// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanFile _$ScanFileFromJson(Map<String, dynamic> json) => ScanFile(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      transcription: $enumDecode(_$STATUSEnumMap, json['transcription']),
      cloud: $enumDecode(_$STATUSEnumMap, json['cloud']),
      created: DateTime.parse(json['created'] as String),
      files:
          (json['files'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      trb: (json['trb'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>)
                  .map((e) =>
                      TextRecognisionBlock.fromJson(e as Map<String, dynamic>))
                  .toList())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ScanFileToJson(ScanFile instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'type': instance.type,
      'transcription': _$STATUSEnumMap[instance.transcription],
      'cloud': _$STATUSEnumMap[instance.cloud],
      'created': instance.created.toIso8601String(),
      'files': instance.files,
      'trb': instance.trb,
    };

const _$STATUSEnumMap = {
  STATUS.RUNNING: 1,
  STATUS.DONE: 2,
  STATUS.NONE: 3,
};
