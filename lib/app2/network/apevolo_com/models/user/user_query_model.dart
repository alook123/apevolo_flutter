import 'package:json_annotation/json_annotation.dart';

part 'user_query_model.g.dart';

/// 用户查询结果模型
/// 用于表示分页查询用户列表的响应数据
@JsonSerializable()
class UserQuery {
  /// 用户列表内容
  List<Content>? content;

  /// 总元素数量
  int? totalElements;

  /// 总页数
  int? totalPages;

  UserQuery({this.content, this.totalElements, this.totalPages});

  /// 从JSON创建UserQuery实例
  /// 用于将服务器响应数据转换为UserQuery对象
  factory UserQuery.fromJson(Map<String, dynamic> json) =>
      _$UserQueryFromJson(json);

  /// 将UserQuery实例转换为JSON
  @override
  Map<String, dynamic> toJson() => _$UserQueryToJson(this);
}

/// 用户内容模型
/// 表示查询结果中的单个用户信息
@JsonSerializable()
class Content {
  /// 用户名
  String? username;

  /// 用户昵称
  String? nickName;

  /// 用户邮箱
  String? email;

  /// 是否为管理员
  bool? isAdmin;

  /// 账户是否启用
  bool? enabled;

  /// 用户密码
  String? password;

  /// 部门ID
  int? deptId;

  /// 手机号码
  String? phone;

  /// 头像路径
  String? avatarPath;

  /// 性别
  String? gender;

  /// 密码重置时间
  String? passwordReSetTime;

  /// 用户角色列表
  List<Roles>? roles;

  /// 用户所属部门
  Dept? dept;

  /// 用户担任的职位列表
  List<Job>? jobs;

  /// 租户ID
  int? tenantId;

  /// 租户信息
  Tenant? tenant;

  /// 用户ID
  int? id;

  /// 创建者
  String? createBy;

  /// 创建时间
  DateTime? createTime;

  /// 更新者
  String? updateBy;

  /// 更新时间
  DateTime? updateTime;

  Content({
    this.username,
    this.nickName,
    this.email,
    this.isAdmin,
    this.enabled,
    this.password,
    this.deptId,
    this.phone,
    this.avatarPath,
    this.gender,
    this.passwordReSetTime,
    this.roles,
    this.dept,
    this.jobs,
    this.tenantId,
    this.tenant,
    this.id,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
  });

  /// 从JSON创建Content实例
  /// 用于将JSON数据转换为Content对象
  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  /// 将Content实例转换为JSON
  Map<String, dynamic> toJson() => _$ContentToJson(this);
}

/// 角色模型
/// 表示用户拥有的角色信息
@JsonSerializable()
class Roles {
  /// 角色ID
  int? id;

  /// 角色名称
  String? name;

  /// 角色权限标识
  String? permission;

  /// 角色等级
  int? level;

  /// 数据权限类型
  int? dataScopeType;

  Roles({this.id, this.name, this.permission, this.level, this.dataScopeType});

  /// 从JSON创建Roles实例
  factory Roles.fromJson(Map<String, dynamic> json) => _$RolesFromJson(json);

  /// 将Roles实例转换为JSON
  Map<String, dynamic> toJson() => _$RolesToJson(this);
}

/// 部门模型
/// 表示用户所属的部门信息
@JsonSerializable()
class Dept {
  /// 部门ID
  int? id;

  /// 部门名称
  String? name;

  Dept({this.id, this.name});

  /// 从JSON创建Dept实例
  factory Dept.fromJson(Map<String, dynamic> json) => _$DeptFromJson(json);

  /// 将Dept实例转换为JSON
  Map<String, dynamic> toJson() => _$DeptToJson(this);
}

/// 职位模型
/// 表示用户担任的职位信息
@JsonSerializable()
class Job {
  /// 职位ID
  int? id;

  /// 职位名称
  String? name;

  Job({this.id, this.name});

  /// 从JSON创建Job实例
  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

  /// 将Job实例转换为JSON
  Map<String, dynamic> toJson() => _$JobToJson(this);
}

/// 租户模型
/// 表示用户所属的租户信息
@JsonSerializable()
class Tenant {
  /// 租户ID
  int? tenantId;

  /// 租户名称
  String? name;

  /// 租户描述
  String? description;

  /// 租户类型
  int? tenantType;

  /// 配置ID
  String? configId;

  /// 数据库类型
  int? dbType;

  /// 数据库连接字符串
  String? connectionString;

  /// ID
  int? id;

  /// 创建者
  String? createBy;

  /// 创建时间
  String? createTime;

  /// 更新者
  String? updateBy;

  /// 更新时间
  String? updateTime;

  Tenant(
      {this.tenantId,
      this.name,
      this.description,
      this.tenantType,
      this.configId,
      this.dbType,
      this.connectionString,
      this.id,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime});

  /// 从JSON创建Tenant实例
  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);

  /// 将Tenant实例转换为JSON
  Map<String, dynamic> toJson() => _$TenantToJson(this);
}
