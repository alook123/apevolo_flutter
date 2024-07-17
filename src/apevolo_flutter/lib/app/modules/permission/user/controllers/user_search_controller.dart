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
