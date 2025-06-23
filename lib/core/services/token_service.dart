import 'package:apevolo_flutter/shared/network/apevolo_com/models/auth/token.dart';
import 'package:apevolo_flutter/shared/storage/shared_prefs_storage_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart' as web;

/// TokenService
/// 负责安全地存储、读取和清理 accessToken/refreshToken 等认证信息，
/// Web端用 sessionStorage，其他端用 SharedPreferences
class TokenService {
  static SharedPrefsStorageService? _storage;
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  /// 初始化存储服务
  static Future<void> init(SharedPrefsStorageService storage) async {
    _storage = storage;
  }

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
      if (_storage == null) throw Exception('TokenService not initialized');
      if (token.accessToken != null) {
        await _storage!.setString(_accessTokenKey, token.accessToken!);
      }
      if (token.refreshToken != null) {
        await _storage!.setString(_refreshTokenKey, token.refreshToken!);
      }
    }
  }

  /// 读取 accessToken
  Future<String?> getAccessToken() async {
    if (kIsWeb) {
      return web.window.sessionStorage.getItem(_accessTokenKey);
    } else {
      if (_storage == null) throw Exception('TokenService not initialized');
      return _storage!.getString(_accessTokenKey);
    }
  }

  /// 读取 refreshToken
  Future<String?> getRefreshToken() async {
    if (kIsWeb) {
      return web.window.sessionStorage.getItem(_refreshTokenKey);
    } else {
      if (_storage == null) throw Exception('TokenService not initialized');
      return _storage!.getString(_refreshTokenKey);
    }
  }

  /// 清除所有 token 信息
  Future<void> clearToken() async {
    if (kIsWeb) {
      web.window.sessionStorage.removeItem(_accessTokenKey);
      web.window.sessionStorage.removeItem(_refreshTokenKey);
    } else {
      if (_storage == null) throw Exception('TokenService not initialized');
      await _storage!.remove(_accessTokenKey);
      await _storage!.remove(_refreshTokenKey);
    }
  }
}
