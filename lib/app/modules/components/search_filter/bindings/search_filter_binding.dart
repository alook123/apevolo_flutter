import 'package:get/get.dart';

import '../controllers/search_filter_controller.dart';

class SearchFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchFilterController>(() => SearchFilterController(),
        tag: Get.arguments);
  }
}
