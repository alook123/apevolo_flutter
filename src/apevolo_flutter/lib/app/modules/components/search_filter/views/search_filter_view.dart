import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_filter_controller.dart';

class SearchFilterView extends GetView<SearchFilterController> {
  SearchFilterView({super.key});
  final scrollController = ScrollController();
  void scrollLeft() {
    scrollController.animateTo(
      scrollController.offset - 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void scrollRight() {
    scrollController.animateTo(
      scrollController.offset + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isFirstTime = true;
    scrollController.addListener(
      () {
        if (isFirstTime) {
          controller.updateScrollPosition(
              scrollController.position.pixels,
              scrollController.position.minScrollExtent,
              scrollController.position.maxScrollExtent);
          isFirstTime = false;
        }
        if (scrollController.position.pixels ==
                scrollController.position.minScrollExtent ||
            scrollController.position.pixels ==
                scrollController.position.maxScrollExtent) {
          isFirstTime = true;
          controller.updateScrollPosition(
              scrollController.position.pixels,
              scrollController.position.minScrollExtent,
              scrollController.position.maxScrollExtent);
        }
      },
    );

    return GetBuilder<SearchFilterController>(
      builder: (controller) => Row(
        children: [
          const Icon(Icons.filter_alt),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: scrollController,
                  child: Row(
                    children: List.generate(
                      controller.searchFilter.length,
                      (index) {
                        final e =
                            controller.searchFilter.entries.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0), // Add spacing between chips
                          child: Chip(
                            label: Text('${e.key.name}:${e.key.value}'),
                            onDeleted: () {
                              controller.removeFilter(e.key);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: !controller.leftMost.value,
                  child: Positioned(
                    left: 0, // 调整按钮大小和间距
                    top: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Container(
                        width: 100, // 渐变效果的宽度
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Get.isDarkMode
                                  ? const Color.fromRGBO(29, 27, 32, 1)
                                  : const Color.fromRGBO(246, 242, 249, 1),
                              Get.isDarkMode
                                  ? const Color.fromRGBO(29, 27, 32, 0.8)
                                  : const Color.fromRGBO(246, 242, 249, 0.8),
                              Theme.of(context).cardColor.withOpacity(0.0)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !controller.leftMost.value,
                  child: Positioned(
                    left: 0, // 调整按钮大小和间距
                    top: 0,
                    bottom: 0,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        iconColor: Theme.of(context).iconTheme.color,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 40),
                      ),
                      onPressed: scrollLeft,
                      child: const Icon(Icons.chevron_left), // 设置图标大小
                    ),
                  ),
                ),
                Visibility(
                  visible: !controller.rightMost.value,
                  child: Positioned(
                    right: 0, // 调整按钮大小和间距
                    top: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Container(
                        width: 100, // 渐变效果的宽度
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Get.isDarkMode
                                  ? const Color.fromRGBO(29, 27, 32, 1)
                                  : const Color.fromRGBO(246, 242, 249, 1),
                              Get.isDarkMode
                                  ? const Color.fromRGBO(29, 27, 32, 0.8)
                                  : const Color.fromRGBO(246, 242, 249, 0.8),
                              Theme.of(context).cardColor.withOpacity(0.0)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !controller.rightMost.value,
                  child: Positioned(
                    right: 0, // 调整按钮大小和间距
                    top: 0,
                    bottom: 0,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        iconColor: Theme.of(context).iconTheme.color,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 40),
                      ),
                      onPressed: scrollRight,
                      child: const Icon(Icons.chevron_right), // 设置图标大小
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
