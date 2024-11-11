import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ShellNavigationMenuController extends GetxController {
  final Rx<bool> isSelectedHome = true.obs;

  @override
  void onInit() {
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

  Future<void> onToHome() async {
    isSelectedHome.value = true;
    Get.toNamed(Routes.HOME, id: 1);
    var a = Get.routing;
  }

  Future<void> onReload() async {
    Get.reload();
  }

  Future<void> onBack() async {
    var a = Get.routing;
    Get.back();
    var b = Get.routing;
  }

  Future<void> onForward() async {
    //TODO: 记录前进过的页面，以便前进
  }
}
