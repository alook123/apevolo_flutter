import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'shell_navigation_menu.dart';
import 'shell_menu_buttons.dart';
import '../../../shared/widgets/svg_picture_view.dart';

/// Shell水平菜单组件
/// 应用顶部的水平菜单栏，包含菜单切换、导航、标题和操作按钮
class ShellHorizontalMenu extends ConsumerWidget {
  const ShellHorizontalMenu({
    super.key,
    this.title,
    this.subTitle,
    this.svgIconPath,
    this.visible = true,
    this.onPressed,
  });

  final String? title;
  final String? subTitle;
  final String? svgIconPath;
  final bool visible;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 左侧区域：菜单按钮、导航和标题
        Row(
          children: [
            // 菜单切换按钮
            if (visible)
              IconButton(
                onPressed: onPressed,
                icon: const Icon(FluentIcons.panel_left_16_filled),
                tooltip: '切换菜单',
              ),

            const SizedBox(width: 8),

            // 导航菜单
            ShellNavigationMenu(visible: visible),

            // 标题区域
            Row(
              children: [
                const SizedBox(width: 16),

                // 图标
                if (svgIconPath != null)
                  SvgPictureView(
                    svgIconPath,
                    width: 20,
                    height: 20,
                  ),

                const SizedBox(width: 8),

                // 标题文本
                if (title?.isNotEmpty == true || subTitle?.isNotEmpty == true)
                  Text(
                    '${title ?? ""} ${subTitle != null ? "/ $subTitle" : ""}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
              ],
            ),
          ],
        ),

        // 右侧区域：操作按钮
        ShellMenuButtons(visible: visible),
      ],
    );
  }
}
