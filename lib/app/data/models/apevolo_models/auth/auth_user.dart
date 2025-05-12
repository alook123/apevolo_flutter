import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required UserDetail user,
    required List<String> roles,
    required List<String> dataScopes,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}

@freezed
abstract class UserDetail with _$UserDetail {
  const factory UserDetail({
    required String username,
    required String nickName,
    required String email,
    required bool isAdmin,
    required bool enabled,
    required String password,
    required int deptId,
    required String phone,
    required String avatarPath,
    required String gender,
    String? passwordReSetTime,
    required List<Role> roles,
    required Dept dept,
    required List<Job> jobs,
    required int tenantId,
    String? tenant,
    required int id,
    required String createBy,
    required String createTime,
    String? updateBy,
    String? updateTime,
  }) = _UserDetail;

  factory UserDetail.fromJson(Map<String, dynamic> json) =>
      _$UserDetailFromJson(json);
}

@freezed
abstract class Role with _$Role {
  const factory Role({
    required int id,
    required String name,
    required String permission,
    required int level,
    required int dataScopeType,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}

@freezed
abstract class Dept with _$Dept {
  const factory Dept({
    required int id,
    required String name,
  }) = _Dept;

  factory Dept.fromJson(Map<String, dynamic> json) => _$DeptFromJson(json);
}

@freezed
abstract class Job with _$Job {
  const factory Job({
    required int id,
    required String name,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}
