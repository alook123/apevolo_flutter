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
                constraints: const BoxConstraints(
                  minWidth: 100.0, // 设置最小高度
                ),
                child: SizedBox(
                  width: controller.verticalMenuWidth.value,
                  child: const ShellVerticalMenuView(),
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
                        title: controller.selectMenu.value?.meta?.title,
                        subTitle:
                            controller.selectMenuChildren.value?.meta?.title,
                        icon: controller.selectIcon.value,
                        visible: !controller.menuOpen.value,
                        onPressed: () {
                          //todo:弹出时候，隐藏抽屉顶部的菜单
                          scaffoldKey.currentState!.openDrawer();
                        },
                      ),
                      Visibility(
                        visible: controller.menuOpen.value,
                        child: TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              // Image.asset('assets/image/logo.png', width: 20),
                              // const SizedBox(width: 16),
                              Icon(controller.selectIcon.value, size: 20),
                              const SizedBox(width: 8),
                              Visibility(
                                visible:
                                    controller.selectMenu.value?.meta?.title !=
                                            null &&
                                        controller.selectMenuChildren.value
                                                ?.meta?.title !=
                                            null,
                                child: Text(
                                  '${controller.selectMenu.value?.meta?.title ?? ''} / ${controller.selectMenuChildren.value?.meta?.title ?? ''}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Scaffold(
                          body: Navigator(
                            key: Get.nestedKey(1),
                            initialRoute: Routes.HOME,
                            onGenerateRoute: (settings) {
                              GetPage<dynamic> getPage =
                                  AppPages.routes.firstWhere(
                                (element) =>
                                    (settings.name == '/' &&
                                        element.name == Routes.HOME) ||
                                    (settings.name != '/' &&
                                        element.name == settings.name) ||
                                    element.name == Routes.NOT_FOUND,
                              );
                              return GetPageRoute(
                                page: getPage.page,
                                settings: settings,
                                binding: getPage.binding,
                                transition:
                                    Transition.leftToRightWithFade, //过渡动画
                              );
                            },
                          ),
                        ),
                      ),
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
          child: const Card(
            margin: EdgeInsets.only(left: 8, top: 8, bottom: 8),
            child: ShellVerticalMenuView(),
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
