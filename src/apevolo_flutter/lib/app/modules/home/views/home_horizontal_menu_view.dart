import 'package:apevolo_flutter/app/modules/widget/theme_mode/views/theme_mode_view.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HomeHorizontalMenuView extends GetView {
  HomeHorizontalMenuView({
    super.key,
    bool visible = true,
    Function()? onPressed,
  }) {
    _visible = visible;
    _onPressed = onPressed;
  }
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
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.message),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_outlined),
              ),
              const ThemeModeView(),
            ],
          ),
        ],
      ),
    );
  }
}
