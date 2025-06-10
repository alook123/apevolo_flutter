import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shell导航菜单组件
/// 包含首页、后退、前进、刷新等导航按钮
class ShellNavigationMenu extends ConsumerWidget {
  const ShellNavigationMenu({
    super.key,
    this.visible = true,
  });

  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!visible) return const SizedBox.shrink();

    return OverflowBar(
      children: [
        // 首页按钮
        IconButton(
          onPressed: () => _onToHome(context),
          icon: const Icon(Icons.home),
          tooltip: '首页',
          isSelected: _isSelectedHome(),
        ),

        // 后退按钮
        IconButton(
          onPressed: () => _onBack(context),
          icon: const Icon(Icons.arrow_back),
          tooltip: '后退',
        ),

        // 前进按钮
        const IconButton(
          onPressed: null, // TODO: 实现前进功能
          icon: Icon(Icons.arrow_forward),
          tooltip: '前进',
        ),

        // 刷新按钮
        IconButton(
          onPressed: () => _onReload(context),
          icon: const Icon(Icons.refresh),
          tooltip: '刷新',
        ),
      ],
    );
  }

  /// 导航到首页
  void _onToHome(BuildContext context) {
    // TODO: 导航到首页逻辑
    Navigator.of(context).pushReplacementNamed('/shell');
  }

  /// 后退操作
  void _onBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  /// 刷新当前页面
  void _onReload(BuildContext context) {
    // TODO: 实现页面刷新逻辑
    // 可以通过provider来刷新当前页面数据
  }

  /// 检查是否选中首页
  bool _isSelectedHome() {
    // TODO: 根据当前路由判断是否在首页
    return true;
  }
}
