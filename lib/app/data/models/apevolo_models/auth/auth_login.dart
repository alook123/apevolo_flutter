import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/auth_user.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/token.dart';
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
