import 'package:json_annotation/json_annotation.dart';
part 'auth_user.g.dart';

@JsonSerializable()
class AuthUser {
  final UserDetail user;
  final List<String> roles;
  final List<String> dataScopes;

  AuthUser({
    required this.user,
    required this.roles,
    required this.dataScopes,
  });
  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
  Map<String, dynamic> toJson() => _$AuthUserToJson(this);
}

@JsonSerializable()
class UserDetail {
  final String username;
  final String nickName;
  final String email;
  final bool isAdmin;
  final bool enabled;
  final String password;
  final int deptId;
  final String phone;
  final String avatarPath;
  final String gender;
  final String? passwordReSetTime;
  final List<Role> roles;
  final Dept dept;
  final List<Job> jobs;
  final int tenantId;
  final String? tenant;
  final int id;
  final String createBy;
  final String createTime;
  final String? updateBy;
  final String? updateTime;

  UserDetail({
    required this.username,
    required this.nickName,
    required this.email,
    required this.isAdmin,
    required this.enabled,
    required this.password,
    required this.deptId,
    required this.phone,
    required this.avatarPath,
    required this.gender,
    required this.passwordReSetTime,
    required this.roles,
    required this.dept,
    required this.jobs,
    required this.tenantId,
    required this.tenant,
    required this.id,
    required this.createBy,
    required this.createTime,
    required this.updateBy,
    required this.updateTime,
  });
  factory UserDetail.fromJson(Map<String, dynamic> json) =>
      _$UserDetailFromJson(json);
  Map<String, dynamic> toJson() => _$UserDetailToJson(this);
}

@JsonSerializable()
class Role {
  final int id;
  final String name;
  final String permission;
  final int level;
  final int dataScopeType;

  Role({
    required this.id,
    required this.name,
    required this.permission,
    required this.level,
    required this.dataScopeType,
  });
  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
  Map<String, dynamic> toJson() => _$RoleToJson(this);
}

@JsonSerializable()
class Dept {
  final int id;
  final String name;

  Dept({required this.id, required this.name});
  factory Dept.fromJson(Map<String, dynamic> json) => _$DeptFromJson(json);
  Map<String, dynamic> toJson() => _$DeptToJson(this);
}

@JsonSerializable()
class Job {
  final int id;
  final String name;

  Job({required this.id, required this.name});
  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  Map<String, dynamic> toJson() => _$JobToJson(this);
}
