import 'package:apevolo_flutter/app/data/models/user/user_query_model.dart';
import 'package:apevolo_flutter/app/data/models/user/user_query_request_model.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/apevolo_dio_service.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/api/user/user_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserProvider userProvider =
      Get.put<UserProvider>(UserProvider(Get.find<ApevoloDioService>().dio));

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
    await onQuery();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onReset() async {
    query.value = null;
    departmentTextController.text = "";
    keyWordTextController.text = "";
    createFromTextController.text = "";
    createFromTextController.text = "";
    update();
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
