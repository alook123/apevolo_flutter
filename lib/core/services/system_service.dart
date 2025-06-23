import 'package:apevolo_flutter/shared/storage/shared_prefs_storage_service.dart';
import 'package:flutter/material.dart';

/// SystemService
///
/// 负责管理系统级设置（如主题模式）的本地存储与切换。
/// 主要功能：
///   - 读取/保存主题模式到本地存储
///   - 将字符串与 ThemeMode 枚举互转
class SystemService {
  /// 存储服务（已迁移到 SharedPreferences + JSON）
  final SharedPrefsStorageService _storage;

  SystemService(this._storage);

  /// 加载本地存储的主题模式
  ///
  /// 返回 ThemeMode（默认为 system）
  Future<ThemeMode> loadThemeMode() async {
    final themeModeString =
        _storage.getString('settings.themeMode') ?? 'system';
    return _stringToThemeMode(themeModeString);
  }

  /// 保存主题模式到本地
  ///
  /// [mode] 需要保存的主题模式
  Future<void> saveThemeMode(ThemeMode mode) async {
    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      default:
        modeString = 'system';
        break;
    }
    await _storage.setString('settings.themeMode', modeString);
  }

  /// 字符串转 ThemeMode 枚举
  ///
  /// [themeModeString] 字符串（'light'/'dark'/'system'）
  /// 返回 ThemeMode 枚举
  ThemeMode _stringToThemeMode(String themeModeString) {
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
