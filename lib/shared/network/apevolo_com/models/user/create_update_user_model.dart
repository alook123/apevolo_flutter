import 'package:json_annotation/json_annotation.dart';

part 'create_update_user_model.g.dart';

/// 创建或更新用户的数据传输对象
/// 用于向服务器发送创建或更新用户的请求数据
@JsonSerializable()
class CreateUpdateUserModel {
  /// 用户ID，创建时为空，更新时必填
  int? id;

  /// 创建者
  String? createBy;

  /// 创建时间
  DateTime? createTime;

  /// 更新者
  String? updateBy;

  /// 更新时间
  DateTime? updateTime;

  /// 是否已删除
  bool? isDeleted;

  /// 用户名，必填
  @JsonKey(required: true)
  String username;

  /// 用户昵称，必填
  @JsonKey(required: true)
  String nickName;

  /// 用户邮箱，必填
  @JsonKey(required: true)
  String email;

  /// 账户是否启用
  bool? enabled;

  /// 手机号码，必填
  @JsonKey(required: true)
  String phone;

  /// 性别，必填
  @JsonKey(required: true)
  String gender;

  /// 用户所属部门，必填
  @JsonKey(required: true)
  UserDeptModel dept;

  /// 用户角色列表，必填
  @JsonKey(required: true)
  List<UserRoleModel> roles;

  /// 用户岗位列表，必填
  @JsonKey(required: true)
  List<UserJobModel> jobs;

  /// 租户ID
  int? tenantId;

  CreateUpdateUserModel({
    this.id,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.isDeleted,
    required this.username,
    required this.nickName,
    required this.email,
    this.enabled,
    required this.phone,
    required this.gender,
    required this.dept,
    required this.roles,
    required this.jobs,
    this.tenantId,
  });

  /// 从JSON创建CreateUpdateUserModel实例
  /// 用于将JSON数据转换为CreateUpdateUserModel对象
  factory CreateUpdateUserModel.fromJson(Map<String, dynamic> json) =>
      _$CreateUpdateUserModelFromJson(json);

  /// 将CreateUpdateUserModel实例转换为JSON
  /// 用于API请求时序列化对象
  Map<String, dynamic> toJson() => _$CreateUpdateUserModelToJson(this);
}

/// 用户部门数据传输对象
/// 用于表示用户所属的部门信息
@JsonSerializable()
class UserDeptModel {
  /// 部门ID，必填
  @JsonKey(required: true)
  int id;

  UserDeptModel({required this.id});

  /// 从JSON创建UserDeptModel实例
  /// 用于将JSON数据转换为UserDeptModel对象
  factory UserDeptModel.fromJson(Map<String, dynamic> json) =>
      _$UserDeptModelFromJson(json);

  /// 将UserDeptModel实例转换为JSON
  /// 用于API请求时序列化对象
  Map<String, dynamic> toJson() => _$UserDeptModelToJson(this);
}

/// 用户角色数据传输对象
/// 用于表示用户拥有的角色信息
@JsonSerializable()
class UserRoleModel {
  /// 角色ID，创建时可为空，更新时必填
  int? id;

  /// 角色名称，必填
  @JsonKey(required: true)
  String name;

  UserRoleModel({
    this.id,
    required this.name,
  });

  /// 从JSON创建UserRoleModel实例
  /// 用于将JSON数据转换为UserRoleModel对象
  factory UserRoleModel.fromJson(Map<String, dynamic> json) =>
      _$UserRoleModelFromJson(json);

  /// 将UserRoleModel实例转换为JSON
  /// 用于API请求时序列化对象
  Map<String, dynamic> toJson() => _$UserRoleModelToJson(this);
}

/// 用户岗位数据传输对象
/// 用于表示用户担任的岗位信息
@JsonSerializable()
class UserJobModel {
  /// 岗位ID，创建时可为空，更新时必填
  int? id;

  /// 岗位名称，必填
  @JsonKey(required: true)
  String name;

  UserJobModel({
    this.id,
    required this.name,
  });

  /// 从JSON创建UserJobModel实例
  /// 用于将JSON数据转换为UserJobModel对象
  factory UserJobModel.fromJson(Map<String, dynamic> json) =>
      _$UserJobModelFromJson(json);

  /// 将UserJobModel实例转换为JSON
  /// 用于API请求时序列化对象
  Map<String, dynamic> toJson() => _$UserJobModelToJson(this);
}
