import 'package:apevolo_flutter/app/data/models/apevolo_models/user/user_query_model.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/user/user_query_request_model.dart';
import 'package:apevolo_flutter/app/modules/permission/user/controllers/user_search_controller.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/apevolo_dio_service.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/api/user/user_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserProvider userProvider =
      Get.put<UserProvider>(UserProvider(Get.find<ApevoloDioService>().dio));

  final UserSearchController userSearchController =
      Get.put(UserSearchController(), tag: Get.arguments);

  final TextEditingController departmentTextController =
      TextEditingController();
  final TextEditingController keyWordTextController = TextEditingController();
  final TextEditingController createFromTextController =
      TextEditingController();
  final TextEditingController createToTextController = TextEditingController();

  final Rx<bool?> enabled = Rx<bool?>(null);
  final Rx<bool?> isQuery = Rx<bool?>(null);

  final Rx<UserQuery?> query = Rx<UserQuery?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    // Get.lazyPut<UserSearchController>(() => UserSearchController());
    // Get.lazyPut<UserProvider>(
    //     () => UserProvider(Get.find<ApevoloDioService>().dio));
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await onQuery();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onReset() async {
    // query.value = null;
    departmentTextController.text = "";
    keyWordTextController.text = "";
    createFromTextController.text = "";
    createFromTextController.text = "";
    update();
    Get.rawSnackbar(
      title: '提示',
      message: '重置成功',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
      maxWidth: 500,
    );
  }

  Future<void> onQuery() async {
    UserQueryRequest request = UserQueryRequest();
    //request.deptId = departmentTextController.text;
    request.keyWords = keyWordTextController.text;
    request.createTime?.add(createFromTextController.text as DateTime);
    request.createTime?.add(createToTextController.text as DateTime);
    request.enabled = enabled.value;
    await userProvider.query(request).then(
      (value) {
        query.value = value;
        update();
      },
    ).onError(
      (error, stackTrace) {},
    );
  }
}
