import 'package:apevolo_flutter/app/data/models/apevolo_models/query_request_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_query_request_model.g.dart';

@JsonSerializable()
class UserQueryRequest extends QueryRequestBase {
  int? id;
  List<int>? deptIds;
  String? keyWords;
  bool? enabled;
  int? deptId;

  UserQueryRequest({
    super.createTime,
    super.pageIndex,
    super.pageSize,
    super.sortFields,
    super.totalElements,
    this.id,
    this.deptIds,
    this.keyWords,
    this.enabled,
    this.deptId,
  });

  factory UserQueryRequest.fromJson(Map<String, dynamic> json) =>
      _$UserQueryRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserQueryRequestToJson(this);
}
