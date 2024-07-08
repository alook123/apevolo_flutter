import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_filter_controller.dart';

class SearchFilterView extends GetView<SearchFilterController> {
  SearchFilterView({super.key});
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
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
      builder: (controller) => Stack(
        children: [
          Row(
            children: [
              Visibility(
                visible: !controller.leftMost.value &&
                    controller.searchFilter.isNotEmpty,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: scrollLeft,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
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
              ),
              Visibility(
                visible: !controller.rightMost.value &&
                    controller.searchFilter.isNotEmpty,
                maintainSize: false,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: scrollRight,
                ),
              ),
            ],
          ),
          Visibility(
            visible: !controller.leftMost.value,
            child: Positioned(
              left: 40, // 调整按钮大小和间距
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  width: 50, // 渐变效果的宽度
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Get.isDarkMode
                            ? const Color.fromRGBO(29, 27, 32, 1)
                            : const Color.fromRGBO(246, 242, 249, 1),
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
              right: 40, // 调整按钮大小和间距
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  width: 50, // 渐变效果的宽度
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Get.isDarkMode
                            ? const Color.fromRGBO(29, 27, 32, 1)
                            : const Color.fromRGBO(246, 242, 249, 1),
                        Theme.of(context).cardColor.withOpacity(0.0)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
