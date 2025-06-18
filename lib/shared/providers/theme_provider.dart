import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

const _themeBox = 'themeBox';
const _themeKey = 'themeMode';

/// 主题色管理 StateNotifier
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final box = await Hive.openBox(_themeBox);
    final mode = box.get(_themeKey, defaultValue: 'system');
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
    final box = await Hive.openBox(_themeBox);
    String value = 'system';
    if (mode == ThemeMode.light) value = 'light';
    if (mode == ThemeMode.dark) value = 'dark';
    await box.put(_themeKey, value);
  }
}

final StateNotifierProvider<ThemeNotifier, ThemeMode> themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());
