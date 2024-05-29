import 'package:apevolo_flutter/app/data/models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/modules/permission/user/views/user_view.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final Rx<MenuBuild?> selectMenu = Rxn<MenuBuild>();
  final Rx<ChildrenMenu?> selectMenuChildren = Rxn<ChildrenMenu>();
  final Rx<IconData?> selectIcon = Rxn<IconData>();

  final Rx<Widget> page = Rx(const SizedBox());

  final RxBool menuOpen = true.obs;

  final RxDouble verticalMenuWidth = 280.0.obs;

  final RxBool resizeMouse = false.obs;

  final Map<String, Widget> pages = {
    "user": const UserView(),
  };

  @override
  Future<void> onInit() async {
    super.onInit();
    selectMenuChildren.listen((x) {
      page.value = pages[x?.path] ?? const SizedBox();
    });
  }

  @override
  void onReady() {
    super.onReady();

    // Future.delayed(
    //   const Duration(milliseconds: 1000),
    //   () {
    //     if (userService.loginInfo.value?.user == null) {
    //       Get.offAllNamed(Routes.LOGIN);
    //     }
    //   },
    // );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
