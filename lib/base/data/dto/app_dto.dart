import 'package:json_annotation/json_annotation.dart';

abstract class AppDto {
  const AppDto({this.id});

  final String? id;

  Map<String, dynamic> toJson();

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isEmpty => toJson().isEmpty;

  bool validate() => !isEmpty;

  @override
  String toString() => toJson().toString();
}
