import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/auth/authorization_provider.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/api/menu/menu_provider.dart';
import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:darq/darq.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ShellVerticalMenuController extends GetxController {
  final AuthorizationProvider authProvider = Get.find<AuthorizationProvider>();
  final MenuProvider menuProvider = Get.find<MenuProvider>();

  final RxList<MenuBuild> menus = <MenuBuild>[].obs;
  final RxMap<String, (ChildrenMenu children, bool selected)> openMenu =
      <String, (ChildrenMenu, bool)>{}.obs;
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

  Future<void> onTapMenu(
    ChildrenMenu children, {
    String? tag,
    MenuBuild? menu,
    bool newTab = false,
  }) async {
    if (children.path == null) return;
    if (tag != null && tag == this.tag.value) return; // 防止重复点击

    tag ??= const Uuid().v4();
    openMenu.forEach((key, value) {
      if (key != tag) {
        openMenu[key] = (value.$1, false);
      }
    });
    openMenu[tag] = (children, true);
    this.tag.value = tag;
    menu ??= menus.firstWhere((x) => x.children!.contains(children));
    update();
    await Get.toNamed(
      '${menu.path}/${children.path}',
      id: 1,
      arguments: tag,
      parameters: {'tag': tag},
    );
  }
}
