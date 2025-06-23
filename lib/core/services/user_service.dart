import 'dart:convert';
import 'package:apevolo_flutter/shared/network/apevolo_com/models/auth/auth_login.dart';
import 'package:apevolo_flutter/shared/network/apevolo_com/models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/shared/storage/shared_prefs_storage_service.dart';

/// 用户服务，负责用户相关数据的本地存储与读取
///
/// 主要功能：
/// - 读取/保存用户登录信息
/// - 读取/保存已打开的菜单
/// - 读取/保存已打开的标签
/// - 清除所有用户相关本地数据
class UserService {
  /// 存储服务（已迁移到 SharedPreferences + JSON）
  final SharedPrefsStorageService _storage;

  UserService(this._storage);

  /// 加载本地存储的用户登录信息
  Future<AuthLogin?> loadUserInfo() async {
    return _storage.getObject('userData.loginInfo', AuthLogin.fromJson);
  }

  /// 保存用户登录信息到本地
  Future<void> saveUserInfo(AuthLogin loginInfo) async {
    await _storage.saveObject('userData.loginInfo', loginInfo);
  }

  /// 加载本地存储的已打开菜单
  Future<Map<String, ChildrenMenu>> loadOpenMenu() async {
    final jsonString = _storage.getString('userData.openMenus');
    if (jsonString != null) {
      try {
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        final Map<String, ChildrenMenu> menuMap = {};
        data.forEach((key, value) {
          menuMap[key] = ChildrenMenu.fromJson(value);
        });
        return menuMap;
      } catch (e) {
        return {};
      }
    }
    return {};
  }

  /// 保存已打开菜单到本地
  Future<void> saveOpenMenus(Map<String, ChildrenMenu> openMenus) async {
    final Map<String, dynamic> serialized = {};
    openMenus.forEach((key, menu) {
      serialized[key] = menu.toJson();
    });
    await _storage.setString('userData.openMenus', jsonEncode(serialized));
  }

  /// 加载本地存储的已打开标签
  Future<String?> loadOpenTag() async {
    return _storage.getString('userData.openTag');
  }

  /// 保存已打开标签到本地
  Future<void> saveOpenTag(String? tag) async {
    if (tag != null) {
      await _storage.setString('userData.openTag', tag);
    } else {
      await _storage.remove('userData.openTag');
    }
  }

  /// 读取用户名历史记录
  List<String> getUsernameHistory() {
    final history = _storage.getStringList('settings.username_history');
    return history ?? [];
  }

  /// 保存用户名历史记录
  Future<void> saveUsernameHistory(List<String> history) async {
    await _storage.setStringList('settings.username_history', history);
  }

  /// 记住密码：保存或移除指定用户名的密码
  /// 设置是否记住密码
  Future<void> setRememberPassword(
      bool remember, String username, String password) async {
    final jsonString = _storage.getString('remember_passwords.data');
    Map<String, String> map = {};

    if (jsonString != null) {
      try {
        final raw = jsonDecode(jsonString) as Map<String, dynamic>;
        map = Map<String, String>.from(raw);
      } catch (e) {
        // 如果解析失败，使用空 map
      }
    }

    if (remember) {
      map[username] = password;
    } else {
      map.remove(username);
    }

    await _storage.setString('remember_passwords.data', jsonEncode(map));
  }

  /// 获取记住的密码
  String? getRememberedPassword(String username) {
    final jsonString = _storage.getString('remember_passwords.data');
    if (jsonString != null) {
      try {
        final raw = jsonDecode(jsonString) as Map<String, dynamic>;
        final map = Map<String, String>.from(raw);
        return map[username];
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// 清除所有用户相关本地数据
  Future<void> clearUserInfo() async {
    await _storage.remove('userData.loginInfo');
    await _storage.remove('userData.openMenus');
    await _storage.remove('userData.openTag');
  }
}
