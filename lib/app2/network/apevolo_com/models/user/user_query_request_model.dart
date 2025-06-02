import 'package:apevolo_flutter/app/data/models/apevolo_models/query_request_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_query_request_model.g.dart';

/// 用户查询请求模型
/// 用于构建用户查询请求参数
@JsonSerializable()
class UserQueryRequest extends QueryRequestBase {
  /// 用户ID
  int? id;

  /// 部门ID列表，用于按部门筛选用户
  List<int>? deptIds;

  /// 关键词，用于模糊搜索用户名、昵称等
  String? keyWords;

  /// 是否启用，用于筛选用户状态
  bool? enabled;

  /// 单个部门ID，用于精确筛选部门
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

  /// 从JSON创建UserQueryRequest实例
  /// 用于将JSON数据转换为UserQueryRequest对象
  factory UserQueryRequest.fromJson(Map<String, dynamic> json) =>
      _$UserQueryRequestFromJson(json);

  /// 将UserQueryRequest实例转换为JSON
  /// 用于API请求时序列化对象
  @override
  Map<String, dynamic> toJson() => _$UserQueryRequestToJson(this);
}
