import 'package:apevolo_flutter/app2/network/apevolo_com/models/auth/token.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart' as web;

/// TokenService
/// 负责安全地存储、读取和清理 accessToken/refreshToken 等认证信息，
/// Web端用 sessionStorage，其他端用 Hive
class TokenService {
  static const _boxName = 'tokenBox';
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  /// 保存 token 信息
  Future<void> saveToken(Token token) async {
    if (kIsWeb) {
      if (token.accessToken != null) {
        web.window.sessionStorage.setItem(_accessTokenKey, token.accessToken!);
      }
      if (token.refreshToken != null) {
        web.window.sessionStorage
            .setItem(_refreshTokenKey, token.refreshToken!);
      }
    } else {
      final box = await Hive.openBox(_boxName);
      if (token.accessToken != null) {
        await box.put(_accessTokenKey, token.accessToken);
      }
      await box.put(_refreshTokenKey, token.refreshToken);
    }
  }

  /// 读取 accessToken
  Future<String?> getAccessToken() async {
    if (kIsWeb) {
      return web.window.sessionStorage.getItem(_accessTokenKey);
    } else {
      final box = await Hive.openBox(_boxName);
      return box.get(_accessTokenKey);
    }
  }

  /// 读取 refreshToken
  Future<String?> getRefreshToken() async {
    if (kIsWeb) {
      return web.window.sessionStorage.getItem(_refreshTokenKey);
    } else {
      final box = await Hive.openBox(_boxName);
      return box.get(_refreshTokenKey);
    }
  }

  /// 清除所有 token 信息
  Future<void> clearToken() async {
    if (kIsWeb) {
      web.window.sessionStorage.removeItem(_accessTokenKey);
      web.window.sessionStorage.removeItem(_refreshTokenKey);
    } else {
      final box = await Hive.openBox(_boxName);
      await box.delete(_accessTokenKey);
      await box.delete(_refreshTokenKey);
    }
  }
}
