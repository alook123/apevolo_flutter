import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HomeHorizontalMenuView extends GetView {
  HomeHorizontalMenuView({
    Key? key,
    bool visible = true,
    Function()? onPressed,
  }) : super(key: key) {
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
                icon: const Icon(Icons.menu),
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
              IconButton(
                onPressed: () {
                  Get.changeThemeMode(ThemeMode.dark);
                },
                icon: const Icon(Icons.light_mode),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
