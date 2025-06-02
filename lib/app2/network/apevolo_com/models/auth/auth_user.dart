import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// 认证用户类
/// 表示一个已认证的用户及其权限信息
@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    /// 用户详细信息
    required UserDetail user,

    /// 用户角色列表
    required List<String> roles,

    /// 用户数据权限范围
    required List<String> dataScopes,
  }) = _AuthUser;

  /// 从JSON创建AuthUser实例
  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}

/// 用户详细信息类
/// 包含用户的所有详细属性和关联信息
@freezed
abstract class UserDetail with _$UserDetail {
  const factory UserDetail({
    /// 用户名
    required String username,

    /// 用户昵称
    required String nickName,

    /// 用户邮箱
    required String email,

    /// 是否为管理员
    required bool isAdmin,

    /// 账户是否启用
    required bool enabled,

    /// 用户密码
    required String password,

    /// 部门ID
    required int deptId,

    /// 手机号码
    required String phone,

    /// 头像路径
    required String avatarPath,

    /// 性别
    required String gender,

    /// 密码重置时间
    String? passwordReSetTime,

    /// 用户拥有的角色列表
    required List<Role> roles,

    /// 用户所属部门
    required Dept dept,

    /// 用户担任的职位列表
    required List<Job> jobs,

    /// 租户ID
    required int tenantId,

    /// 租户名称
    String? tenant,

    /// 用户ID
    required int id,

    /// 创建者
    required String createBy,

    /// 创建时间
    required String createTime,

    /// 更新者
    String? updateBy,

    /// 更新时间
    String? updateTime,
  }) = _UserDetail;

  factory UserDetail.fromJson(Map<String, dynamic> json) =>
      _$UserDetailFromJson(json);
}

/// 角色类
/// 定义系统中的用户角色及其权限
@freezed
abstract class Role with _$Role {
  const factory Role({
    /// 角色ID
    required int id,

    /// 角色名称
    required String name,

    /// 角色权限标识
    required String permission,

    /// 角色等级
    required int level,

    /// 数据权限类型
    required int dataScopeType,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}

/// 部门类
/// 表示组织结构中的部门信息
@freezed
abstract class Dept with _$Dept {
  const factory Dept({
    /// 部门ID
    required int id,

    /// 部门名称
    required String name,
  }) = _Dept;

  factory Dept.fromJson(Map<String, dynamic> json) => _$DeptFromJson(json);
}

/// 职位类
/// 表示用户在组织中担任的职位
@freezed
abstract class Job with _$Job {
  const factory Job({
    /// 职位ID
    required int id,

    /// 职位名称
    required String name,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}
