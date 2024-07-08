import 'package:apevolo_flutter/app/modules/shell/views/shell_menu_buttons_view.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ShellHorizontalMenuView extends GetView {
  ShellHorizontalMenuView({
    super.key,
    String? title,
    String? subTitle,
    IconData? icon,
    bool visible = true,
    Function()? onPressed,
  }) {
    _title = title ?? '';
    _subTitle = subTitle ?? '';
    _icon = icon;
    _visible = visible;
    _onPressed = onPressed;
  }

  late final String _title, _subTitle;
  late final IconData? _icon;
  late final bool _visible;
  late final Function()? _onPressed;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      // TODO: 关联左侧抽屉
      visible: _visible,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _onPressed,
                icon: const Icon(FluentIcons.panel_left_16_filled),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Image.asset('assets/image/logo.png', width: 20),
                    const SizedBox(width: 16),
                    Icon(_icon, size: 20),
                    const SizedBox(width: 8),
                    Visibility(
                      visible: _title.isNotEmpty || _subTitle.isNotEmpty,
                      child: Text('$_title / $_subTitle'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ShellMenuButtonsView(visible: _visible),
        ],
      ),
    );
  }
}
