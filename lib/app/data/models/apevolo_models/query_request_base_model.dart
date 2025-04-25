import 'package:json_annotation/json_annotation.dart';

part 'query_request_base_model.g.dart';

@JsonSerializable()
class QueryRequestBase {
  List<DateTime>? createTime;
  int? pageIndex;
  int? pageSize;
  List<String>? sortFields;
  int? totalElements;

  QueryRequestBase({
    this.createTime,
    this.pageIndex,
    this.pageSize,
    this.sortFields,
    this.totalElements,
  });

  factory QueryRequestBase.fromJson(Map<String, dynamic> json) =>
      _$QueryRequestBaseFromJson(json);
  Map<String, dynamic> toJson() => _$QueryRequestBaseToJson(this);
}
