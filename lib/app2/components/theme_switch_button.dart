import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/theme_provider.dart';

/// 主题切换按钮（通用组件，建议放在 AppBar、设置页等位置复用）
class ThemeSwitchButton extends ConsumerWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);
    return PopupMenuButton<ThemeMode>(
      icon: const Icon(Icons.color_lens),
      tooltip: '切换主题',
      onSelected: (mode) => notifier.setTheme(mode),
      itemBuilder: (context) => [
        CheckedPopupMenuItem(
          value: ThemeMode.system,
          checked: themeMode == ThemeMode.system,
          child: const Text('跟随系统'),
        ),
        CheckedPopupMenuItem(
          value: ThemeMode.light,
          checked: themeMode == ThemeMode.light,
          child: const Text('明亮'),
        ),
        CheckedPopupMenuItem(
          value: ThemeMode.dark,
          checked: themeMode == ThemeMode.dark,
          child: const Text('深色'),
        ),
      ],
    );
  }
}
