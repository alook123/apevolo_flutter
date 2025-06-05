import 'package:apevolo_flutter/shared/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 单纯切换明亮/深色主题的按钮（不弹菜单，点击即切换）
class ThemeToggleIconButton extends ConsumerWidget {
  const ThemeToggleIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);
    final isDark = themeMode == ThemeMode.dark;
    return IconButton(
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      tooltip: isDark ? '切换为明亮主题' : '切换为深色主题',
      onPressed: () {
        notifier.setTheme(isDark ? ThemeMode.light : ThemeMode.dark);
      },
    );
  }
}
