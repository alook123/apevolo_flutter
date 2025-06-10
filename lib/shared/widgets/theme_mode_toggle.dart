import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

/// 主题模式切换组件
/// 支持在明亮、黑暗和系统主题之间切换
class ThemeModeToggle extends ConsumerWidget {
  const ThemeModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return PopupMenuButton<ThemeMode>(
      icon: Icon(_getThemeIcon(themeMode)),
      tooltip: '主题设置',
      onSelected: (ThemeMode selectedMode) {
        ref.read(themeProvider.notifier).setTheme(selectedMode);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: ThemeMode.system,
          child: ListTile(
            leading: const Icon(Icons.brightness_auto),
            title: const Text('跟随系统'),
            trailing:
                themeMode == ThemeMode.system ? const Icon(Icons.check) : null,
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.light,
          child: ListTile(
            leading: const Icon(Icons.light_mode),
            title: const Text('明亮模式'),
            trailing:
                themeMode == ThemeMode.light ? const Icon(Icons.check) : null,
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.dark,
          child: ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('黑暗模式'),
            trailing:
                themeMode == ThemeMode.dark ? const Icon(Icons.check) : null,
          ),
        ),
      ],
    );
  }

  /// 根据主题模式获取对应图标
  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
      default:
        return Icons.brightness_auto;
    }
  }
}
