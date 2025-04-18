// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthLogin _$AuthLoginFromJson(Map<String, dynamic> json) => AuthLogin(
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      token: Token.fromJson(json['token'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthLoginToJson(AuthLogin instance) => <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
    };

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => AuthUser(
      user: UserDetail.fromJson(json['user'] as Map<String, dynamic>),
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      dataScopes: (json['dataScopes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AuthUserToJson(AuthUser instance) => <String, dynamic>{
      'user': instance.user,
      'roles': instance.roles,
      'dataScopes': instance.dataScopes,
    };

UserDetail _$UserDetailFromJson(Map<String, dynamic> json) => UserDetail(
      username: json['username'] as String,
      nickName: json['nickName'] as String,
      email: json['email'] as String,
      isAdmin: json['isAdmin'] as bool,
      enabled: json['enabled'] as bool,
      password: json['password'] as String,
      deptId: (json['deptId'] as num).toInt(),
      phone: json['phone'] as String,
      avatarPath: json['avatarPath'] as String,
      gender: json['gender'] as String,
      passwordReSetTime: json['passwordReSetTime'] as String?,
      roles: (json['roles'] as List<dynamic>)
          .map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
      dept: Dept.fromJson(json['dept'] as Map<String, dynamic>),
      jobs: (json['jobs'] as List<dynamic>)
          .map((e) => Job.fromJson(e as Map<String, dynamic>))
          .toList(),
      tenantId: (json['tenantId'] as num).toInt(),
      tenant: json['tenant'] as String?,
      id: (json['id'] as num).toInt(),
      createBy: json['createBy'] as String,
      createTime: json['createTime'] as String,
      updateBy: json['updateBy'] as String?,
      updateTime: json['updateTime'] as String?,
    );

Map<String, dynamic> _$UserDetailToJson(UserDetail instance) =>
    <String, dynamic>{
      'username': instance.username,
      'nickName': instance.nickName,
      'email': instance.email,
      'isAdmin': instance.isAdmin,
      'enabled': instance.enabled,
      'password': instance.password,
      'deptId': instance.deptId,
      'phone': instance.phone,
      'avatarPath': instance.avatarPath,
      'gender': instance.gender,
      'passwordReSetTime': instance.passwordReSetTime,
      'roles': instance.roles,
      'dept': instance.dept,
      'jobs': instance.jobs,
      'tenantId': instance.tenantId,
      'tenant': instance.tenant,
      'id': instance.id,
      'createBy': instance.createBy,
      'createTime': instance.createTime,
      'updateBy': instance.updateBy,
      'updateTime': instance.updateTime,
    };

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      permission: json['permission'] as String,
      level: (json['level'] as num).toInt(),
      dataScopeType: (json['dataScopeType'] as num).toInt(),
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'permission': instance.permission,
      'level': instance.level,
      'dataScopeType': instance.dataScopeType,
    };

Dept _$DeptFromJson(Map<String, dynamic> json) => Dept(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$DeptToJson(Dept instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Job _$JobFromJson(Map<String, dynamic> json) => Job(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      accessToken: json['access_token'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
      tokenType: json['token_type'] as String,
      refreshToken: json['refresh_token'] as String,
      refreshTokenExpiresIn: (json['refresh_token_expires_in'] as num).toInt(),
    );

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'token_type': instance.tokenType,
      'refresh_token': instance.refreshToken,
      'refresh_token_expires_in': instance.refreshTokenExpiresIn,
    };
