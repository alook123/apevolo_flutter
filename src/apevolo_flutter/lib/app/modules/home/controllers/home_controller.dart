import 'package:apevolo_flutter/app/data/models/menu_build_model.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/menu_provider.dart';
import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:apevolo_flutter/app/service/user_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final MenuProvider menuProvider = Get.find<MenuProvider>();

  final RxList<MenuBuild> menuList = <MenuBuild>[].obs;

  final RxBool menuOpen = true.obs;

  final RxDouble verticalMenuWidth = 280.0.obs;

  final RxBool resizeMouse = false.obs;

  final UserService userService = Get.find();

  @override
  Future<void> onInit() async {
    super.onInit();
    await onLoadMenu();
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

  Future<void> onLoadMenu() async {
    await menuProvider.build().then((value) {
      menuList.value = value;
      Get.snackbar("title", value.toString());
    }).catchError((error) {
      String errorText =
          error is String ? error : error.response.data['message'].toString();
      Get.snackbar("title", errorText);
    });
  }
}
