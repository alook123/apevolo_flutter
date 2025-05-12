import 'package:json_annotation/json_annotation.dart';

part 'user_response_model.g.dart';

/// 用户操作响应模型
@JsonSerializable()
class UserResponseModel {
  int? id;
  String? username;
  String? nickName;
  String? email;
  bool? enabled;
  String? phone;
  String? avatarPath;
  String? gender;

  UserResponseModel({
    this.id,
    this.username,
    this.nickName,
    this.email,
    this.enabled,
    this.phone,
    this.avatarPath,
    this.gender,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseModelToJson(this);
}

/// 更新用户密码参数模型
@JsonSerializable()
class UpdatePasswordModel {
  @JsonKey(required: true)
  String oldPassword;

  @JsonKey(required: true)
  String newPassword;

  @JsonKey(required: true)
  String confirmPassword;

  UpdatePasswordModel({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  factory UpdatePasswordModel.fromJson(Map<String, dynamic> json) =>
      _$UpdatePasswordModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePasswordModelToJson(this);
}

/// 更新用户邮箱参数模型
@JsonSerializable()
class UpdateEmailModel {
  @JsonKey(required: true)
  String password;

  @JsonKey(required: true)
  String email;

  @JsonKey(required: true)
  String code;

  UpdateEmailModel({
    required this.password,
    required this.email,
    required this.code,
  });

  factory UpdateEmailModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateEmailModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateEmailModelToJson(this);
}

/// 更新用户个人中心参数模型
@JsonSerializable()
class UpdateUserCenterModel {
  @JsonKey(required: true)
  String nickName;

  @JsonKey(required: true)
  String gender;

  @JsonKey(required: true)
  String phone;

  UpdateUserCenterModel({
    required this.nickName,
    required this.gender,
    required this.phone,
  });

  factory UpdateUserCenterModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserCenterModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserCenterModelToJson(this);
}
