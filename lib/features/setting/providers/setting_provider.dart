/// 设置状态管理（Riverpod 2.0+ 新写法实现）
/// 负责管理设置相关的状态和业务逻辑
library setting_provider;

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:apevolo_flutter/shared/providers/theme_provider.dart';

part 'setting_provider.g.dart';

/// 设置状态数据类
/// 包含设置相关的所有状态信息，采用不可变数据结构
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

/// 设置状态管理器
/// 负责设置相关的业务逻辑（主题切换、语言切换等）
@riverpod
class SettingNotifier extends _$SettingNotifier {
  @override
  SettingState build() {
    // 监听主题变化
    final themeMode = ref.watch(themeProvider);

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

    // 状态会通过 build() 方法自动重建，因为我们监听了 themeProvider
  }

  /// 切换语言（暂未实现）
  void changeLanguage(String language) {
    // TODO: 实现语言切换逻辑
    state = state.copyWith(language: language);
  }
}
