import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/auth_user.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/token.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_login.freezed.dart';
part 'auth_login.g.dart';

@freezed
abstract class AuthLogin with _$AuthLogin {
  const factory AuthLogin({
    required AuthUser user,
    required Token token,
  }) = _AuthLogin;

  factory AuthLogin.fromJson(Map<String, dynamic> json) =>
      _$AuthLoginFromJson(json);
}
