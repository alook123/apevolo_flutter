import 'package:apevolo_flutter/app/data/models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/auth/authorization_provider.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/api/menu/menu_provider.dart';
import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:apevolo_flutter/app/service/system_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeVerticalMenuController extends GetxController {
  final AuthorizationProvider _provider2 = Get.find<AuthorizationProvider>();
  final MenuProvider menuProvider = Get.find<MenuProvider>();
  final HomeController _homeController = Get.find();

  final RxList<MenuBuild> menuList = <MenuBuild>[].obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    await onLoadMenu();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onLogout() async {
    await _provider2.logout();
    Get.offAndToNamed(Routes.LOGIN);
  }

  Future<void> onChangeMenu(
      MenuBuild? menu, ChildrenMenu? children, IconData? icon) async {
    if (children == null) {
      Get.rawSnackbar(
        title: "提示",
        message: "菜单路径为空！",
      );
    }
    // final selectMenu = _homeController.menuList
    //     .selectMany<ChildrenMenu?>((e, i) => e.children ?? [])
    //     .where((e) => e != null && e.path == path)
    //     .firstOrDefault();
    _homeController.selectMenu.value = menu;
    _homeController.selectMenuChildren.value = children;
    _homeController.selectIcon.value = icon;
    Get.find<SystemService>().selectMenu.value = children;
    update();
  }

  Future<void> onLoadMenu() async {
    await menuProvider.build().then((value) {
      menuList.value = value;
      // Get.snackbar("title", value.toString());
      update();
    }).catchError((error) {
      if (error.data != null) {
        Get.snackbar("title", error?.data?['message'].toString() ?? error);
      } else if (error.message != null) {
        Get.snackbar("title", error.message);
      }
    });
  }
}
