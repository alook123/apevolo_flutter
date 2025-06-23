import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apevolo_flutter/shared/storage/shared_prefs_storage_service.dart';

const _themeKey = 'themeMode';

/// 主题色管理 StateNotifier
class ThemeNotifier extends StateNotifier<ThemeMode> {
  late final SharedPrefsStorageService _storageService;

  ThemeNotifier() : super(ThemeMode.system) {
    _storageService = SharedPrefsStorageService();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final mode = _storageService.getString(_themeKey) ?? 'system';
    switch (mode) {
      case 'light':
        state = ThemeMode.light;
        break;
      case 'dark':
        state = ThemeMode.dark;
        break;
      default:
        state = ThemeMode.system;
        break;
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    String value = 'system';
    if (mode == ThemeMode.light) value = 'light';
    if (mode == ThemeMode.dark) value = 'dark';
    await _storageService.setString(_themeKey, value);
  }
}

final StateNotifierProvider<ThemeNotifier, ThemeMode> themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());
