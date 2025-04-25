import 'package:json_annotation/json_annotation.dart';

part 'search_filter_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class SearchFilterModel<T> {
  ///用于记录搜索条件查询的key
  String? key;

  ///查询条件的名称
  String? name;

  ///查询条件的值
  T? value;

  SearchFilterModel({this.key, this.name, this.value});

  factory SearchFilterModel.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$SearchFilterModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$SearchFilterModelToJson(this, toJsonT);
}
