import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ShellController extends GetxController {
  final Rx<MenuBuild?> selectMenu = Rxn<MenuBuild>();
  final Rx<ChildrenMenu?> selectMenuChildren = Rxn<ChildrenMenu>();
  final Rx<IconData?> selectIcon = Rxn<IconData>();

  final RxBool menuOpen = true.obs;

  final RxDouble verticalMenuWidth = 280.0.obs;

  final RxBool resizeMouse = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  GetPageRoute<dynamic> onGenerateRoute(RouteSettings settings) {
    GetPage<dynamic> getPage = AppPages.routes.firstWhere(
      (x) =>
          (settings.name == '/' && x.name == Routes.HOME) ||
          (settings.name != '/' && x.name == settings.name) ||
          x.name == Routes.NOT_FOUND,
    );
    return GetPageRoute(
      page: getPage.page,
      settings: settings,
      binding: getPage.binding,
      transition: Transition.leftToRightWithFade, //过渡动画
    );
  }
}
