import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:apevolo_flutter/shared/storage/shared_prefs_storage_service.dart';

class SystemService extends GetxService {
  final SharedPrefsStorageService _storage;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  SystemService(this._storage);

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final themeModeString =
        _storage.getString('settings.themeMode') ?? 'system';
    _applyThemeMode(themeModeString);

    // 设置监听
    themeMode.listen((mode) async {
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
