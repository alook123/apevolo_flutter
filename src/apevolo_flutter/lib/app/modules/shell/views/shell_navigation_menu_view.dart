import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/shell_navigation_menu_controller.dart';

class ShellNavigationMenuView extends GetView<ShellNavigationMenuController> {
  const ShellNavigationMenuView({super.key, this.visible = false});

  final bool visible;
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (controller) {
        return Visibility(
          visible: visible,
          child: ButtonBar(
            alignment: MainAxisAlignment.end,
            buttonPadding: const EdgeInsets.all(0),
            // buttonTextTheme: ButtonTextTheme.primary,
            overflowButtonSpacing: 0,
            children: [
              IconButton(
                onPressed: controller.onToHome,
                icon: const Icon(Icons.home),
                isSelected: controller.isSelectedHome.value,
              ),
              IconButton(
                onPressed: controller.onBack,
                icon: const Icon(Icons.arrow_back),
              ),
              const IconButton(
                onPressed: null,
                icon: Icon(Icons.arrow_forward),
              ),
              IconButton(
                onPressed: () => Get.reload(),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        );
      },
    );
  }
}
