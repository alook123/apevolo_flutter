import 'package:json_annotation/json_annotation.dart';
part 'auth_login.g.dart';

@JsonSerializable()
class AuthLogin {
  final AuthUser user;
  final Token token;

  AuthLogin({required this.user, required this.token});
  factory AuthLogin.fromJson(Map<String, dynamic> json) =>
      _$AuthLoginFromJson(json);
  Map<String, dynamic> toJson() => _$AuthLoginToJson(this);
}

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

@JsonSerializable()
class Token {
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  @JsonKey(name: 'token_type')
  final String tokenType;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'refresh_token_expires_in')
  final int refreshTokenExpiresIn;

  Token({
    required this.accessToken,
    required this.expiresIn,
    required this.tokenType,
    required this.refreshToken,
    required this.refreshTokenExpiresIn,
  });
  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}

extension AuthLoginCopy on AuthLogin {
  AuthLogin copyWith({
    AuthUser? user,
    Token? token,
  }) {
    return AuthLogin(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}
