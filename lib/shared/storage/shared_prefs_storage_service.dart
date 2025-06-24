import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service_interface.dart';

/// 存储异常类
class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}

/// SharedPreferences 存储服务
///
/// 使用 JSON 序列化，支持所有 Freezed 模型的存储和读取
class SharedPrefsStorageService implements StorageServiceInterface {
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  /// 初始化存储服务
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  /// 确保存储服务已初始化
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StorageException(
          'SharedPrefsStorageService not initialized. Call init() first.');
    }
  }

  /// 保存具有 toJson() 方法的对象
  ///
  /// 支持所有 Freezed 生成的模型类
  ///
  /// 使用示例：
  /// ```dart
  /// await storage.saveObject('user', userModel);
  /// await storage.saveObject('settings', settingsModel);
  /// ```
  @override
  Future<void> saveObject<T>(String key, T object) async {
    _ensureInitialized();
    try {
      final json = jsonEncode((object as dynamic).toJson());
      await _prefs.setString(key, json);
    } catch (e) {
      throw StorageException('Failed to save object with key "$key": $e');
    }
  }

  /// 获取对象
  ///
  /// 需要提供对应的 fromJson 构造函数
  ///
  /// 使用示例：
  /// ```dart
  /// final user = storage.getObject('user', UserModel.fromJson);
  /// final settings = storage.getObject('settings', SettingsModel.fromJson);
  /// ```
  @override
  T? getObject<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    _ensureInitialized();
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(json);
    } catch (e) {
      throw StorageException('Failed to get object with key "$key": $e');
    }
  }

  /// 保存列表
  ///
  /// 支持任何具有 toJson() 方法的对象列表
  ///
  /// 使用示例：
  /// ```dart
  /// await storage.saveList('users', userList);
  /// await storage.saveList('settings', settingsList);
  /// ```
  @override
  Future<void> saveList<T>(String key, List<T> list) async {
    _ensureInitialized();
    try {
      final jsonList = list.map((item) => (item as dynamic).toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await _prefs.setString(key, jsonString);
    } catch (e) {
      throw StorageException('Failed to save list with key "$key": $e');
    }
  }

  /// 获取列表
  ///
  /// 需要提供对应的 fromJson 构造函数
  ///
  /// 使用示例：
  /// ```dart
  /// final users = storage.getList('users', UserModel.fromJson);
  /// final settings = storage.getList('settings', SettingsModel.fromJson);
  /// ```
  @override
  List<T>? getList<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    _ensureInitialized();
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw StorageException('Failed to get list with key "$key": $e');
    }
  }

  /// 基础类型存储方法
  @override
  Future<void> setString(String key, String value) async {
    _ensureInitialized();
    await _prefs.setString(key, value);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    _ensureInitialized();
    await _prefs.setBool(key, value);
  }

  @override
  Future<void> setInt(String key, int value) async {
    _ensureInitialized();
    await _prefs.setInt(key, value);
  }

  Future<void> setStringList(String key, List<String> value) async {
    _ensureInitialized();
    await _prefs.setStringList(key, value);
  }

  /// 基础类型获取方法
  @override
  String? getString(String key) {
    _ensureInitialized();
    return _prefs.getString(key);
  }

  @override
  bool getBool(String key) {
    _ensureInitialized();
    return _prefs.getBool(key) ?? false;
  }

  @override
  int getInt(String key) {
    _ensureInitialized();
    return _prefs.getInt(key) ?? 0;
  }

  List<String>? getStringList(String key) {
    _ensureInitialized();
    return _prefs.getStringList(key);
  }

  /// 删除指定键的数据
  @override
  Future<void> remove(String key) async {
    _ensureInitialized();
    await _prefs.remove(key);
  }

  /// 清空所有数据
  @override
  Future<void> clear() async {
    _ensureInitialized();
    await _prefs.clear();
  }

  /// 检查是否包含指定键
  @override
  bool containsKey(String key) {
    _ensureInitialized();
    return _prefs.containsKey(key);
  }
}

/// Riverpod Provider
final sharedPrefsStorageServiceProvider =
    Provider<SharedPrefsStorageService>((ref) {
  return SharedPrefsStorageService()
    ..init().then((_) {
      // 初始化完成后可以执行其他操作
    }).catchError((error) {
      throw StorageException(
          'Failed to initialize SharedPrefsStorageService: $error');
    });
});
