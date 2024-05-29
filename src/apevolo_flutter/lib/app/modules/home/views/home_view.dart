import 'package:apevolo_flutter/app/modules/home/views/home_horizontal_menu_view.dart';
import 'package:apevolo_flutter/app/modules/home/views/home_vertical_menu_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

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
                  child: const HomeVerticalMenuView(),
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
                      HomeHorizontalMenuView(
                        visible: !controller.menuOpen.value,
                        onPressed: () {
                          //todo:弹出时候，隐藏抽屉顶部的菜单
                          scaffoldKey.currentState!.openDrawer();
                        },
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(controller.selectIcon.value),
                            Text(
                                '${controller.selectMenu.value?.meta?.title}/${controller.selectMenuChildren.value?.meta?.title}'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: controller.page.value,
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
            child: HomeVerticalMenuView(),
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
