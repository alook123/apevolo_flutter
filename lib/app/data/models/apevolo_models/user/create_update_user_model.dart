import 'package:json_annotation/json_annotation.dart';

part 'create_update_user_model.g.dart';

/// 创建或更新用户的数据传输对象
@JsonSerializable()
class CreateUpdateUserModel {
  int? id;
  String? createBy;
  DateTime? createTime;
  String? updateBy;
  DateTime? updateTime;
  bool? isDeleted;

  @JsonKey(required: true)
  String username;

  @JsonKey(required: true)
  String nickName;

  @JsonKey(required: true)
  String email;

  bool? enabled;

  @JsonKey(required: true)
  String phone;

  @JsonKey(required: true)
  String gender;

  @JsonKey(required: true)
  UserDeptModel dept;

  @JsonKey(required: true)
  List<UserRoleModel> roles;

  @JsonKey(required: true)
  List<UserJobModel> jobs;

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

  factory CreateUpdateUserModel.fromJson(Map<String, dynamic> json) =>
      _$CreateUpdateUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUpdateUserModelToJson(this);
}

/// 用户部门数据传输对象
@JsonSerializable()
class UserDeptModel {
  @JsonKey(required: true)
  int id;

  UserDeptModel({required this.id});

  factory UserDeptModel.fromJson(Map<String, dynamic> json) =>
      _$UserDeptModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDeptModelToJson(this);
}

/// 用户角色数据传输对象
@JsonSerializable()
class UserRoleModel {
  int? id;

  @JsonKey(required: true)
  String name;

  UserRoleModel({
    this.id,
    required this.name,
  });

  factory UserRoleModel.fromJson(Map<String, dynamic> json) =>
      _$UserRoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserRoleModelToJson(this);
}

/// 用户岗位数据传输对象
@JsonSerializable()
class UserJobModel {
  int? id;

  @JsonKey(required: true)
  String name;

  UserJobModel({
    this.id,
    required this.name,
  });

  factory UserJobModel.fromJson(Map<String, dynamic> json) =>
      _$UserJobModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserJobModelToJson(this);
}
