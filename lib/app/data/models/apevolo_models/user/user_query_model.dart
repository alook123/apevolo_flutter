import 'package:apevolo_flutter/app/data/models/apevolo_models/model_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_query_model.g.dart';

@JsonSerializable()
class UserQuery extends ModelBase {
  List<Content>? content;
  int? totalElements;
  int? totalPages;

  UserQuery({this.content, this.totalElements, this.totalPages});

  factory UserQuery.fromJson(Map<String, dynamic> json) =>
      _$UserQueryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserQueryToJson(this);
}

@JsonSerializable()
class Content {
  String? username;
  String? nickName;
  String? email;
  bool? isAdmin;
  bool? enabled;
  String? password;
  int? deptId;
  String? phone;
  String? avatarPath;
  String? gender;
  String? passwordReSetTime;
  List<Roles>? roles;
  Dept? dept;
  List<Job>? jobs;
  int? tenantId;
  Tenant? tenant;
  int? id;
  String? createBy;
  DateTime? createTime;
  String? updateBy;
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

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}

@JsonSerializable()
class Roles {
  int? id;
  String? name;
  String? permission;
  int? level;
  int? dataScopeType;

  Roles({this.id, this.name, this.permission, this.level, this.dataScopeType});

  factory Roles.fromJson(Map<String, dynamic> json) => _$RolesFromJson(json);

  Map<String, dynamic> toJson() => _$RolesToJson(this);
}

@JsonSerializable()
class Dept {
  int? id;
  String? name;

  Dept({this.id, this.name});

  factory Dept.fromJson(Map<String, dynamic> json) => _$DeptFromJson(json);

  Map<String, dynamic> toJson() => _$DeptToJson(this);
}

@JsonSerializable()
class Job {
  int? id;
  String? name;

  Job({this.id, this.name});

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

  Map<String, dynamic> toJson() => _$JobToJson(this);
}

@JsonSerializable()
class Tenant {
  int? tenantId;
  String? name;
  String? description;
  int? tenantType;
  String? configId;
  int? dbType;
  String? connectionString;
  int? id;
  String? createBy;
  String? createTime;
  String? updateBy;
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

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);

  Map<String, dynamic> toJson() => _$TenantToJson(this);
}
