import 'package:apevolo_flutter/app/modules/shell/views/shell_horizontal_menu_view.dart';
import 'package:apevolo_flutter/app/modules/shell/views/shell_vertical_menu_view.dart';
import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/shell_controller.dart';

class ShellView extends GetView<ShellController> {
  const ShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      body: Flex(
        direction: Axis.horizontal,
        children: [
          Obx(
            () => Visibility(
              visible: controller.menuOpen.value,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 100.0),
                child: SizedBox(
                  width: controller.verticalMenuWidth.value,
                  child: ShellVerticalMenuView(
                    expandOpen: controller.menuOpen.value,
                    onExpandMenu: () =>
                        controller.menuOpen.value = !controller.menuOpen.value,
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: Listener(
                onPointerMove: (event) {
                  double width =
                      controller.verticalMenuWidth.value + event.delta.dx;
                  if (width < 250 || width > 800) return;
                  controller.verticalMenuWidth.value += event.delta.dx;
                },
                onPointerHover: (event) {
                  controller.resizeMouse.value = true;
                },
                child: Container(
                  width: 5,
                  color: controller.resizeMouse.value
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  //color: Colors.blue,
                ),
              ),
              onExit: (event) => controller.resizeMouse.value = false,
            ),
          ),
          Expanded(
            flex: 3,
            child: Card(
              //todo: 全屏时，去除card
              margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: Scaffold(
                body: Obx(
                  () => Column(
                    children: [
                      ShellHorizontalMenuView(
                        title: controller.userService.menus
                            .firstWhereOrNull(
                              (x) =>
                                  x.children != null &&
                                  x.children!.any((y) =>
                                      y.path ==
                                      controller
                                          .userService.currentMenu.value?.path),
                            )
                            ?.meta
                            ?.title,
                        subTitle: controller
                            .userService.currentMenu.value?.meta?.title,
                        // svgIconPath: controller.userService.currentMenu.value !=
                        //             null &&
                        //         controller
                        //                 .userService.currentMenu.value!.path !=
                        //             null
                        //     ? controller.userService.getSvgIconPath(
                        //         controller.userService.currentMenu.value!.path!)
                        //     : null,
                        visible: !controller.menuOpen.value,
                        onPressed: () => scaffoldKey.currentState!.openDrawer(),
                      ),
                      Expanded(
                        child: Scaffold(
                            body: Navigator(
                          key: Get.nestedKey(1),
                          initialRoute: Routes.HOME,
                          onGenerateRoute: controller.onGenerateRoute,
                        )),
                      ), //主要显示的内容
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Obx(
        () => SizedBox(
          width: controller.verticalMenuWidth.value,
          child: Card(
            margin: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
            child: ShellVerticalMenuView(
              expandOpen: controller.menuOpen.value,
              onExpandMenu: () =>
                  controller.menuOpen.value = !controller.menuOpen.value,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
