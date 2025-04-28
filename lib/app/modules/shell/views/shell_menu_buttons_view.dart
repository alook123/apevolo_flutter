import 'package:apevolo_flutter/app/components/theme_mode/views/theme_mode_view.dart';
import 'package:apevolo_flutter/app/constants/about_constants.dart';
import 'package:apevolo_flutter/app/controllers/auth_controller.dart';
import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShellMenuButtonsView extends GetView<AuthController> {
  const ShellMenuButtonsView({super.key, this.visible = false});

  final bool visible;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: OverflowBar(
        children: [
          IconButton(
            onPressed: () {
              if (kDebugMode) {
                print('Selected:');
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
                  child: ListTile(
                    leading: const Icon(Icons.account_box),
                    title: const Text('个人资料'),
                    onTap: () {},
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('注销'),
                    onTap: () {
                      // 关闭弹出菜单
                      Navigator.pop(context);
                      // 显示确认对话框
                      _showLogoutConfirmDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.message),
          ),
          // Obx(() {
          //   return    const ThemeModeView(),;
          // }),
          const ThemeModeView(),
          IconButton(
            onPressed: () => Get.toNamed(Routes.SETTING, id: 1),
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              // 打开about对话框
              showAboutDialog(
                context: context,
                applicationName: AboutConstants.appName,
                applicationVersion: AboutConstants.appVersion,
                applicationIcon: Image.asset(AboutConstants.appIconPath,
                    width: 20, height: 20),
                applicationLegalese: AboutConstants.appLegalese,
                children: [
                  for (final description in AboutConstants.appDescription)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(description),
                    ),
                ],
              );
            },
            icon:
                Image.asset(AboutConstants.appIconPath, width: 20, height: 20),
          ),
        ],
      ),
    );
  }

  // 显示注销确认对话框
  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认注销'),
          content: const Text('您确定要注销当前账号吗？'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleLogout(context);
              },
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }

  // 处理注销操作
  void _handleLogout(BuildContext context) async {
    try {
      // 显示加载指示器
      final loadingDialog = _buildLoadingDialog(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => loadingDialog,
      );

      // 调用AuthController的logout方法执行注销
      await controller.logout();

      // 关闭加载对话框 (如果导航到登录页面，这一步可能不需要)
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    } catch (e) {
      // 关闭加载对话框
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // 显示错误提示
      Get.snackbar(
        '注销失败',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      if (kDebugMode) {
        print('注销过程中发生错误: $e');
      }
    }
  }

  // 构建加载对话框
  Widget _buildLoadingDialog(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              '正在注销...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
