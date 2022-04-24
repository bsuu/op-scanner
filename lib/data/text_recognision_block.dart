
import 'package:json_annotation/json_annotation.dart';

part 'text_recognision_block.g.dart';

@JsonSerializable()
class Tuple {
  final double t1;
  final double t2;

  Tuple(this.t1, this.t2);

  factory Tuple.fromJson(Map<String, dynamic> json) => _$TupleFromJson(json);
  Map<String, dynamic> toJson() => _$TupleToJson(this);
}

@JsonSerializable()
class TextRecognisionBlock {
  final String lang;
  final List<String> lines;
  final List<Tuple> points;

  TextRecognisionBlock(this.lang, this.lines, this.points);

  factory TextRecognisionBlock.fromJson(Map<String, dynamic> json) => _$TextRecognisionBlockFromJson(json);
  Map<String, dynamic> toJson() => _$TextRecognisionBlockToJson(this);
}