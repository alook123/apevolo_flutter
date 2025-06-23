library setting_provider;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apevolo_flutter/shared/providers/theme_provider.dart';

/// 设置状态数据类
class SettingState {
  final String themeModeText;
  final ThemeMode themeMode;
  final String language;

  const SettingState({
    required this.themeModeText,
    required this.themeMode,
    this.language = '中文',
  });

  SettingState copyWith({
    String? themeModeText,
    ThemeMode? themeMode,
    String? language,
  }) {
    return SettingState(
      themeModeText: themeModeText ?? this.themeModeText,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
    );
  }
}

/// 设置状态管理 Provider
class SettingNotifier extends StateNotifier<SettingState> {
  final Ref ref;

  SettingNotifier(this.ref) : super(_initialState(ref));

  static SettingState _initialState(Ref ref) {
    final themeMode = ref.read(themeProvider);

    String themeModeText;
    switch (themeMode) {
      case ThemeMode.light:
        themeModeText = '明亮';
        break;
      case ThemeMode.dark:
        themeModeText = '深色';
        break;
      default:
        themeModeText = '跟随系统';
    }

    return SettingState(
      themeModeText: themeModeText,
      themeMode: themeMode,
    );
  }

  /// 切换主题模式
  Future<void> changeTheme() async {
    final themeNotifier = ref.read(themeProvider.notifier);
    final currentMode = state.themeMode;

    ThemeMode nextMode;
    if (currentMode == ThemeMode.system) {
      nextMode = ThemeMode.light;
    } else if (currentMode == ThemeMode.light) {
      nextMode = ThemeMode.dark;
    } else {
      nextMode = ThemeMode.system;
    }

    await themeNotifier.setTheme(nextMode);

    // 更新状态
    String themeModeText;
    switch (nextMode) {
      case ThemeMode.light:
        themeModeText = '明亮';
        break;
      case ThemeMode.dark:
        themeModeText = '深色';
        break;
      default:
        themeModeText = '跟随系统';
    }

    state = state.copyWith(
      themeModeText: themeModeText,
      themeMode: nextMode,
    );
  }

  /// 切换语言（暂未实现）
  void changeLanguage(String language) {
    // TODO: 实现语言切换逻辑
    state = state.copyWith(language: language);
  }
}

/// 设置状态 Provider
final settingProvider = StateNotifierProvider<SettingNotifier, SettingState>(
  (ref) => SettingNotifier(ref),
);
