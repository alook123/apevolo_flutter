import 'package:apevolo_flutter/app/modules/permission/user/views/user_search_view.dart';
import 'package:apevolo_flutter/app/modules/components/search_filter/views/search_filter_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserView extends GetView<UserController> {
  UserView({super.key});
  final scrollController = ScrollController();

  @override
  UserController get controller => Get.find<UserController>(tag: Get.arguments);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: controller,
      tag: Get.arguments,
      builder: (controller) => Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: ListView(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SearchFilterView(),
                            ),
                            const SizedBox(width: 48),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Get.dialog(
                                        AlertDialog(
                                          //title: const Text('搜索'),
                                          content: const UserSearchView(),
                                          actions: [
                                            IconButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              icon: const Icon(Icons.close),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Icon(Icons.search),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.search)),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.add),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InteractiveViewer(
                                scaleEnabled: false,
                                child: Scrollbar(
                                  controller: scrollController,
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: DataTable(
                                      columns: [
                                        DataColumn(
                                          label: Checkbox(
                                            value: false,
                                            onChanged: (value) {},
                                          ),
                                        ),
                                        DataColumn(
                                          label: const Text('用户名'),
                                          onSort: (columnIndex, ascending) {},
                                        ),
                                        DataColumn(
                                          label: const Text('昵称'),
                                          onSort: (columnIndex, ascending) {},
                                        ),
                                        DataColumn(
                                          label: const Text('性别'),
                                          onSort: (columnIndex, ascending) {},
                                        ),
                                        DataColumn(
                                          label: const Text('电话'),
                                          onSort: (columnIndex, ascending) {},
                                        ),
                                        DataColumn(
                                          label: const Text('邮箱'),
                                          onSort: (columnIndex, ascending) {},
                                        ),
                                        DataColumn(
                                          label: const Text('部门'),
                                          onSort: (columnIndex, ascending) {},
                                        ),
                                        DataColumn(
                                          label: const Text('状态'),
                                          onSort: (columnIndex, ascending) {},
                                        ),
                                        DataColumn(
                                          label: const Text('创建日期'),
                                          onSort: (columnIndex, ascending) {},
                                        ),
                                        DataColumn(
                                          label: const Text('创建人'),
                                          onSort: (columnIndex, ascending) {},
                                        ),
                                      ],
                                      rows: controller.query.value?.content !=
                                              null
                                          ? controller.query.value!.content!
                                              .map(
                                                (e) => DataRow(
                                                  cells: [
                                                    DataCell(
                                                      Checkbox(
                                                        value: false,
                                                        onChanged: (value) {},
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(e.username ?? ''),
                                                    ),
                                                    DataCell(
                                                      Text(e.nickName ?? ''),
                                                    ),
                                                    DataCell(
                                                      Text(e.sex == null
                                                          ? '未知'
                                                          : (e.sex == true
                                                              ? '女'
                                                              : '男')),
                                                    ),
                                                    DataCell(
                                                      Text(e.phone ?? ''),
                                                    ),
                                                    DataCell(
                                                      Text(e.email ?? ''),
                                                    ),
                                                    DataCell(
                                                      Text(e.dept?.name ?? ''),
                                                    ),
                                                    DataCell(
                                                      Text(e.enabled == null
                                                          ? '未知'
                                                          : (e.enabled == true
                                                              ? '启用'
                                                              : '禁用')),
                                                    ),
                                                    DataCell(
                                                      Text(e.createTime ?? ''),
                                                    ),
                                                    DataCell(
                                                      Text(e.createBy ?? ''),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList()
                                          : const [],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataTable(
                              columns: const [
                                DataColumn(label: Text('操作')),
                              ],
                              rows: controller.query.value?.content != null
                                  ? controller.query.value!.content!
                                      .map((e) => DataRow(cells: [
                                            DataCell(Row(children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons.edit),
                                              ),
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons.delete),
                                              ),
                                            ]))
                                          ]))
                                      .toList()
                                  : const [],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
