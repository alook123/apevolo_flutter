import 'package:apevolo_flutter/app/data/models/search_filter_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SearchFilterController extends GetxController {
  final RxMap<SearchFilterModel, Function?> searchFilter =
      <SearchFilterModel, Function?>{}.obs;

  final RxBool leftMost = true.obs;
  final RxBool rightMost = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      searchFilter.addAll({
        SearchFilterModel<String>(key: "keywork", name: '关键字', value: 'abc'):
            () => {},
        SearchFilterModel<String>(key: "1", name: '关键字', value: '1'): () => {},
        SearchFilterModel<String>(key: "1", name: '关键字', value: '1'): () => {},
        SearchFilterModel<String>(key: "1", name: '关键字', value: '1'): () => {},
        SearchFilterModel<String>(key: "1", name: '关键字', value: '1'): () => {},
        SearchFilterModel<String>(key: "1", name: '关键字', value: '1'): () => {},
        SearchFilterModel<String>(key: "1", name: '关键字', value: '1'): () => {},
        SearchFilterModel<String>(key: "1", name: '关键字', value: '1'): () => {},
        SearchFilterModel<String>(key: "1", name: '关键字', value: '1'): () => {},
        SearchFilterModel<String>(key: "1", name: '关键字', value: '1'): () => {},
        SearchFilterModel<String>(key: "1", name: '关键字', value: '1'): () => {},
        SearchFilterModel<String>(key: "1", name: '关键字', value: '1'): () => {},
        SearchFilterModel<String>(key: "1", name: '关键字', value: '1'): () => {},
      });
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 判断在最左或最右
  void updateScrollPosition(
      double pixels, double minScrollExtent, double maxScrollExtent) {
    leftMost.value = pixels == minScrollExtent;
    rightMost.value = pixels == maxScrollExtent;
    update();
  }

  Future<void> removeFilter(SearchFilterModel k) async {
    searchFilter.removeWhere((key, value) => key == k);
    update();
  }
}
