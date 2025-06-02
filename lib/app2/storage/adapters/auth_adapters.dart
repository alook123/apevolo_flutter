import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/auth_login.dart';
import 'package:hive/hive.dart';

/// 认证相关适配器
/// 包含与认证、登录相关的Hive类型适配器
class AuthLoginAdapter extends TypeAdapter<AuthLogin> {
  @override
  final int typeId = 1; // 每个类型需要唯一的ID

  @override
  AuthLogin read(BinaryReader reader) {
    final map = reader.readMap();
    return AuthLogin.fromJson(Map<String, dynamic>.from(map));
  }

  @override
  void write(BinaryWriter writer, AuthLogin obj) {
    writer.writeMap(obj.toJson());
  }
}
