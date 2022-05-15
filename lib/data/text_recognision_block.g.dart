// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_recognision_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tuple _$TupleFromJson(Map<String, dynamic> json) => Tuple(
      (json['t1'] as num).toInt(),
      (json['t2'] as num).toInt(),
    );

Map<String, dynamic> _$TupleToJson(Tuple instance) => <String, dynamic>{
      't1': instance.t1,
      't2': instance.t2,
    };

TextRecognisionBlock _$TextRecognisionBlockFromJson(
        Map<String, dynamic> json) =>
    TextRecognisionBlock(
      json['lang'] as String,
      (json['lines'] as List<dynamic>).map((e) => e as String).toList(),
      (json['points'] as List<dynamic>)
          .map((e) => Tuple.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TextRecognisionBlockToJson(
        TextRecognisionBlock instance) =>
    <String, dynamic>{
      'lang': instance.lang,
      'lines': instance.lines,
      'points': instance.points,
    };
