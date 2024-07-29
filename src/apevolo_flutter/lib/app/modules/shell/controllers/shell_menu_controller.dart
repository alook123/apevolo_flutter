import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/api/menu/menu_provider.dart';
import 'package:apevolo_flutter/app/utilities/logger_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ShellMenuController extends GetxController with StateMixin {
  final MenuProvider menuProvider = Get.find<MenuProvider>();

  ///菜单
  final RxList<MenuBuild> menus = <MenuBuild>[].obs;

  /// 菜单图标数据
  final RxMap<String, IconData> menuIconDatas = <String, IconData>{}.obs;

  ///当前tag
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

  Future<void> onLoadMenu() async {
    menuProvider.build().then((value) {
      menus.value = value;
      change(menus, status: RxStatus.success());
    }).onError((error, stackTrace) {
      Logger.write('error:$error');
      change(null, status: RxStatus.error(error.toString()));
      if (kDebugMode) {
        Get.defaultDialog(title: '错误', middleText: error.toString());
      }
    });
  }

  Future<void> onExpansionChanged(bool value, MenuBuild menu) async {
    menus.firstWhere((x) => x == menu).expanded = value;
  }

  Future<void> onTapMenu({
    required ChildrenMenu children,
    MenuBuild? menu,
  }) async {
    if (children.path == null) return;
    tag.value = const Uuid().v4();
    menu ??= menus.firstWhere((x) => x.children!.contains(children));
    await Get.toNamed(
      '${menu.path}/${children.path}',
      id: 1,
      arguments: tag.value,
      parameters: {'tag': tag.value!},
    );
  }
}
