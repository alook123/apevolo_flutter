import 'package:json_annotation/json_annotation.dart';

part 'user_response_model.g.dart';

/// 用户操作响应模型
/// 用于表示用户操作后的响应数据
@JsonSerializable()
class UserResponseModel {
  /// 用户ID
  int? id;

  /// 用户名
  String? username;

  /// 用户昵称
  String? nickName;

  /// 用户邮箱
  String? email;

  /// 账户是否启用
  bool? enabled;

  /// 手机号码
  String? phone;

  /// 头像路径
  String? avatarPath;

  /// 性别
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

  /// 从JSON创建UserResponseModel实例
  /// 用于将JSON数据转换为UserResponseModel对象
  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserResponseModelFromJson(json);

  /// 将UserResponseModel实例转换为JSON
  Map<String, dynamic> toJson() => _$UserResponseModelToJson(this);
}

/// 更新用户密码参数模型
/// 用于修改用户密码的请求参数
@JsonSerializable()
class UpdatePasswordModel {
  /// 旧密码，用于验证身份
  @JsonKey(required: true)
  String oldPassword;

  /// 新密码
  @JsonKey(required: true)
  String newPassword;

  /// 确认新密码，用于确保输入正确
  @JsonKey(required: true)
  String confirmPassword;

  UpdatePasswordModel({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  /// 从JSON创建UpdatePasswordModel实例
  /// 用于将JSON数据转换为UpdatePasswordModel对象
  factory UpdatePasswordModel.fromJson(Map<String, dynamic> json) =>
      _$UpdatePasswordModelFromJson(json);

  /// 将UpdatePasswordModel实例转换为JSON
  /// 用于API请求时序列化对象
  Map<String, dynamic> toJson() => _$UpdatePasswordModelToJson(this);
}

/// 更新用户邮箱参数模型
/// 用于修改用户邮箱的请求参数
@JsonSerializable()
class UpdateEmailModel {
  /// 当前密码，用于验证身份
  @JsonKey(required: true)
  String password;

  /// 新邮箱地址
  @JsonKey(required: true)
  String email;

  /// 验证码，用于验证邮箱归属
  @JsonKey(required: true)
  String code;

  UpdateEmailModel({
    required this.password,
    required this.email,
    required this.code,
  });

  /// 从JSON创建UpdateEmailModel实例
  /// 用于将JSON数据转换为UpdateEmailModel对象
  factory UpdateEmailModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateEmailModelFromJson(json);

  /// 将UpdateEmailModel实例转换为JSON
  /// 用于API请求时序列化对象
  Map<String, dynamic> toJson() => _$UpdateEmailModelToJson(this);
}

/// 更新用户个人中心参数模型
/// 用于修改用户个人信息的请求参数
@JsonSerializable()
class UpdateUserCenterModel {
  /// 用户昵称
  @JsonKey(required: true)
  String nickName;

  /// 性别
  @JsonKey(required: true)
  String gender;

  /// 手机号码
  @JsonKey(required: true)
  String phone;

  UpdateUserCenterModel({
    required this.nickName,
    required this.gender,
    required this.phone,
  });

  /// 从JSON创建UpdateUserCenterModel实例
  /// 用于将JSON数据转换为UpdateUserCenterModel对象
  factory UpdateUserCenterModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserCenterModelFromJson(json);

  /// 将UpdateUserCenterModel实例转换为JSON
  /// 用于API请求时序列化对象
  Map<String, dynamic> toJson() => _$UpdateUserCenterModelToJson(this);
}
