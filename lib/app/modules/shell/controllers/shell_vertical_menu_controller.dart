import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/auth/authorization_provider.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/api/menu/menu_provider.dart';
import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:apevolo_flutter/app/service/user_service.dart';
import 'package:get/get.dart';

class ShellVerticalMenuController extends GetxController {
  final UserService userService = Get.find<UserService>();
  final AuthorizationProvider authProvider = Get.find<AuthorizationProvider>();
  final MenuProvider menuProvider = Get.find<MenuProvider>();

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
    // await onLoadMenu();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onLogout() async {
    await authProvider.logout();
    Get.offAndToNamed(Routes.LOGIN);
  }

  Future<void> onTapMenu(ChildrenMenu menu) async {
    // for (var element in userService.openMenus.values) {
    //   element.selected = false;
    // }
    // menu.selected = true;
    // userService.openMenus[menu.tag!] = menu;
    update();
  }
}
