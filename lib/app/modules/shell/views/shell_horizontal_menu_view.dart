import 'package:apevolo_flutter/app/components/views/svg_picture_view.dart';
import 'package:apevolo_flutter/app/modules/shell/views/shell_menu_buttons_view.dart';
import 'package:apevolo_flutter/app/modules/shell/views/shell_navigation_menu_view.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShellHorizontalMenuView extends GetView {
  ShellHorizontalMenuView({
    super.key,
    String? title,
    String? subTitle,
    String? svgIconPath,
    bool visible = true,
    Function()? onPressed,
  }) {
    _title = title ?? '';
    _subTitle = subTitle ?? '';
    _svgIconPath = svgIconPath;
    _visible = visible;
    _onPressed = onPressed;
  }

  late final String _title, _subTitle;
  late final String? _svgIconPath;
  late final bool _visible;

  /// 点击汉堡菜单按钮事件
  late final Function()? _onPressed;
  @override
  Widget build(BuildContext context) {
    // 打印当前菜单的标题和子标题、icon路径
    if (_visible) {
      debugPrint('当前菜单标题: $_title');
      debugPrint('当前菜单子标题: $_subTitle');
      debugPrint('当前菜单icon路径: $_svgIconPath');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Visibility(
                visible: _visible,
                child: IconButton(
                  onPressed: _onPressed,
                  icon: const Icon(FluentIcons.panel_left_16_filled),
                )),
            const SizedBox(width: 8),
            ShellNavigationMenuView(visible: _visible),
            // Image.asset('assets/image/logo.png', width: 20, height: 20),
            Row(
              children: [
                const SizedBox(width: 16),
                Visibility(
                    visible: _svgIconPath != null,
                    child: SvgPictureView(_svgIconPath, width: 20, height: 20)),
                const SizedBox(width: 8),
                Visibility(
                  visible: _title.isNotEmpty || _subTitle.isNotEmpty,
                  child: Text('$_title / $_subTitle'),
                ),
              ],
            ),
          ],
        ),
        ShellMenuButtonsView(visible: _visible),
      ],
    );
  }
}
