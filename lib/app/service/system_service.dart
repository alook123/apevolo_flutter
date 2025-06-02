import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:apevolo_flutter/app/service/storage/hive_storage_service.dart';

class SystemService extends GetxService {
  final HiveStorageService _storage;
  final String _settingsBoxName = 'settings';
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  SystemService(this._storage);

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final themeModeString =
        _storage.read<String>(_settingsBoxName, 'themeMode') ?? 'system';
    _applyThemeMode(themeModeString);

    // 设置监听
    themeMode.listen((mode) {
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
      _storage.write(_settingsBoxName, 'themeMode', modeString);
    });
  }

  void _applyThemeMode(String themeModeString) {
    switch (themeModeString) {
      case 'light':
        themeMode.value = ThemeMode.light;
        Get.changeThemeMode(ThemeMode.light);
        break;
      case 'dark':
        themeMode.value = ThemeMode.dark;
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case 'system':
      default:
        themeMode.value = ThemeMode.system;
        Get.changeThemeMode(ThemeMode.system);
        break;
    }
  }
}
