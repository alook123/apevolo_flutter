import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/theme_mode_toggle.dart';

/// Shell菜单按钮组件
/// 包含个人中心、消息、主题切换、设置等按钮
class ShellMenuButtons extends ConsumerWidget {
  const ShellMenuButtons({
    super.key,
    this.visible = true,
  });

  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!visible) return const SizedBox.shrink();

    return OverflowBar(
      children: [
        // 个人中心菜单
        IconButton(
          onPressed: () {
            if (kDebugMode) {
              print('个人中心按钮点击');
            }
          },
          tooltip: '个人中心',
          padding: EdgeInsets.zero,
          icon: PopupMenuButton(
            padding: EdgeInsets.zero,
            tooltip: '个人中心',
            icon: const Icon(Icons.person),
            onSelected: (value) {
              if (kDebugMode) {
                print('Selected: $value');
              }
            },
            offset: const Offset(0, 40),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: const Icon(Icons.account_box),
                  title: const Text('个人资料'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: 导航到个人资料页面
                  },
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('注销'),
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutConfirmDialog(context);
                  },
                ),
              ),
            ],
          ),
        ),

        // 消息按钮
        IconButton(
          onPressed: () {
            // TODO: 显示消息列表
          },
          tooltip: '消息',
          icon: const Icon(Icons.message),
        ),

        // 主题切换按钮
        const ThemeModeToggle(),

        // 设置按钮
        IconButton(
          onPressed: () {
            // TODO: 导航到设置页面
          },
          tooltip: '设置',
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  /// 显示注销确认对话框
  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认注销'),
          content: const Text('您确定要注销当前账户吗？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout(context);
              },
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }

  /// 执行注销操作
  void _performLogout(BuildContext context) {
    // 显示注销中的对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                '正在注销...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );

    // 模拟注销延迟
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // 关闭注销中对话框
      // TODO: 清除用户数据并导航到登录页面
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }
}
