import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/hive_storage_service.dart';
import '../../app/data/models/apevolo_models/auth/auth_login.dart';
import '../../app/data/models/apevolo_models/menu/menu_build_model.dart';

/// 用户服务，负责用户相关数据的本地存储与读取
///
/// 主要功能：
/// - 读取/保存用户登录信息
/// - 读取/保存已打开的菜单
/// - 读取/保存已打开的标签
/// - 清除所有用户相关本地数据
class UserService {
  /// Hive 存储服务
  final HiveStorageService _storage;

  /// 用户数据存储的 box 名称
  final String _userBoxName = 'userData';

  UserService(this._storage);

  /// 加载本地存储的用户登录信息
  Future<AuthLogin?> loadUserInfo() async {
    final data = _storage.read<Map<String, dynamic>>(_userBoxName, 'loginInfo');
    if (data != null) {
      return AuthLogin.fromJson(data);
    }
    return null;
  }

  /// 保存用户登录信息到本地
  Future<void> saveUserInfo(AuthLogin loginInfo) async {
    await _storage.write(_userBoxName, 'loginInfo', loginInfo.toJson());
  }

  /// 加载本地存储的已打开菜单
  Future<Map<String, ChildrenMenu>> loadOpenMenu() async {
    final data = _storage.read<Map<String, dynamic>>(_userBoxName, 'openMenus');
    if (data != null) {
      final Map<String, ChildrenMenu> menuMap = {};
      data.forEach((key, value) {
        menuMap[key] = ChildrenMenu.fromJson(value);
      });
      return menuMap;
    }
    return {};
  }

  /// 保存已打开菜单到本地
  Future<void> saveOpenMenus(Map<String, ChildrenMenu> openMenus) async {
    final Map<String, dynamic> serialized = {};
    openMenus.forEach((key, menu) {
      serialized[key] = menu.toJson();
    });
    await _storage.write(_userBoxName, 'openMenus', serialized);
  }

  /// 加载本地存储的已打开标签
  Future<String?> loadOpenTag() async {
    return _storage.read<String>(_userBoxName, 'openTag');
  }

  /// 保存已打开标签到本地
  Future<void> saveOpenTag(String? tag) async {
    if (tag != null) {
      await _storage.write(_userBoxName, 'openTag', tag);
    } else {
      await _storage.delete(_userBoxName, 'openTag');
    }
  }

  /// 读取用户名历史记录
  List<String> getUsernameHistory() {
    final history =
        _storage.read<List<dynamic>>('settings', 'username_history');
    if (history != null) {
      return history.map((e) => e.toString()).toList();
    }
    return [];
  }

  /// 保存用户名历史记录
  Future<void> saveUsernameHistory(List<String> history) async {
    await _storage.write('settings', 'username_history', history);
  }

  /// 记住密码：保存或移除指定用户名的密码
  Future<void> setRememberPassword(
      bool remember, String username, String password) async {
    final boxKey = 'remember_passwords';
    Map<String, String> map = {};
    final raw = _storage.read<Map>(boxKey, 'data');
    if (raw != null) {
      map = Map<String, String>.from(raw);
    }
    if (remember) {
      map[username] = password;
    } else {
      map.remove(username);
    }
    await _storage.write(boxKey, 'data', map);
  }

  /// 获取记住的密码
  String? getRememberedPassword(String username) {
    final boxKey = 'remember_passwords';
    final raw = _storage.read<Map>(boxKey, 'data');
    if (raw != null) {
      final map = Map<String, String>.from(raw);
      return map[username];
    }
    return null;
  }

  /// 清除所有用户相关本地数据
  Future<void> clearUserInfo() async {
    await _storage.delete(_userBoxName, 'loginInfo');
    await _storage.delete(_userBoxName, 'openMenus');
    await _storage.delete(_userBoxName, 'openTag');
  }
}
