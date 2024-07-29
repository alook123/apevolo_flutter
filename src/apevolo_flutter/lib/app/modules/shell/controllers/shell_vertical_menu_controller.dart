import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/modules/shell/controllers/shell_controller.dart';
import 'package:apevolo_flutter/app/modules/shell/controllers/shell_tag_controller.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/auth/authorization_provider.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/api/menu/menu_provider.dart';
import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ShellVerticalMenuController extends GetxController {
  final ShellController shellController = Get.find<ShellController>();
  final ShellTagController shellTagController = Get.find<ShellTagController>();
  final AuthorizationProvider authProvider = Get.find<AuthorizationProvider>();
  final MenuProvider menuProvider = Get.find<MenuProvider>();

  ///菜单
  final RxList<MenuBuild> menus = <MenuBuild>[].obs;

  ///打开过的菜单
  final RxMap<String, (ChildrenMenu children, bool selected)> openMenus =
      <String, (ChildrenMenu, bool)>{}.obs;

  ///当前打开菜单的tag
  final Rxn<String> tag = Rxn<String>();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await onLoadMenu();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onLogout() async {
    await authProvider.logout();
    Get.offAndToNamed(Routes.LOGIN);
  }

  Future<void> onLoadMenu() async {
    await menuProvider.build().then((value) {
      menus.value = value;
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

  Future<void> onTapMenu(ChildrenMenu menu) async {
    for (var element in shellTagController.openMenus) {
      element.selected = false;
    }
    menu.selected = true;
    shellTagController.openMenus.add(menu);
    shellTagController.update();
  }
}
