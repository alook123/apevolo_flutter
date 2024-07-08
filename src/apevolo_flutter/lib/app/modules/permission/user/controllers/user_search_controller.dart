import 'package:apevolo_flutter/app/data/models/apevolo_models/user/user_query_model.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/user/user_query_request_model.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/apevolo_dio_service.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/api/user/user_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class UserSearchController extends GetxController {
  final TextEditingController departmentTextController =
      TextEditingController();
  final TextEditingController keyWordTextController = TextEditingController();
  final TextEditingController createFromTextController =
      TextEditingController();
  final TextEditingController createToTextController = TextEditingController();
  final Rx<bool?> enabled = Rx<bool?>(null);
  final Rx<bool?> isQuery = Rx<bool?>(null);

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
}
