import 'package:apevolo_flutter/app/data/models/apevolo_models/model_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'query_base_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class QueryBase<T extends ModelBase> {
  List<T>? content;
  int? totalElements;

  QueryBase({
    this.content,
    this.totalElements,
  });

  factory QueryBase.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$QueryBaseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$QueryBaseToJson(this, toJsonT);
}
