import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserView extends GetView<UserController> {
  const UserView({super.key});
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return GetBuilder<UserController>(
      init: UserController(),
      builder: (controller) => Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: ListView(
              children: [
                Form(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 100,
                              maxWidth: 200,
                              maxHeight: 50,
                            ),
                            child: TextFormField(
                              controller: controller.departmentTextController,
                              decoration: const InputDecoration(
                                labelText: '部门名称',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 100,
                              maxWidth: 200,
                              maxHeight: 50,
                            ),
                            child: TextFormField(
                              controller: controller.keyWordTextController,
                              decoration: const InputDecoration(
                                labelText: '名称或邮箱',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '请输入名称或邮箱！ ';
                                }
                                return null;
                              },
                            ),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 100,
                              maxWidth: 200,
                              maxHeight: 50,
                            ),
                            child: TextFormField(
                              controller: controller.createFromTextController,
                              decoration: InputDecoration(
                                labelText: '创建开始日期',
                                prefixIcon: const Icon(Icons.person),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: "选择创建时间",
                                        content: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            minWidth: 800,
                                            maxWidth: 800,
                                          ),
                                          child: CalendarDatePicker(
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100),
                                            initialDate: DateTime.now(),
                                            onDateChanged: (value) {
                                              controller
                                                      .createFromTextController
                                                      .text =
                                                  '${value.year}-${value.month}-${value.day}';
                                              Get.back();
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.calendar_month)),
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 100,
                              maxWidth: 200,
                              maxHeight: 50,
                            ),
                            child: TextFormField(
                              controller: controller.createToTextController,
                              decoration: InputDecoration(
                                labelText: '创建结束日期',
                                prefixIcon: const Icon(Icons.person),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: "选择创建时间",
                                        content: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            minWidth: 800,
                                            maxWidth: 800,
                                          ),
                                          child: CalendarDatePicker(
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100),
                                            initialDate: DateTime.now(),
                                            onDateChanged: (value) {
                                              controller.createToTextController
                                                      .text =
                                                  '${value.year}-${value.month}-${value.day}';
                                              Get.back();
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.calendar_month)),
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 100,
                              maxWidth: 200,
                              maxHeight: 50,
                            ),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.only(bottom: 1),
                              ),
                              child: DropdownButton<bool?>(
                                value: null,
                                underline: Container(), // 移除下划线
                                items: const [
                                  DropdownMenuItem<bool?>(
                                    value: null,
                                    child: Text('全部'),
                                  ),
                                  DropdownMenuItem<bool?>(
                                    value: false,
                                    child: Text('禁用'),
                                  ),
                                  DropdownMenuItem<bool?>(
                                    value: true,
                                    child: Text('启用'),
                                  ),
                                ],
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 100,
                              maxWidth: 200,
                            ),
                            child: Column(
                              children: [
                                OutlinedButton(
                                  onPressed: () => controller.onQuery(),
                                  child: const Text('查询'),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () => controller.onReset(),
                                  child: const Text('重置'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InteractiveViewer(
                            scaleEnabled: false,
                            child: Scrollbar(
                              controller: scrollController,
                              child: SingleChildScrollView(
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: DataTable(
                                  columns: const [
                                    DataColumn(
                                      label: Text('用户名'),
                                      //onSort: (columnIndex, ascending) {},
                                    ),
                                    DataColumn(label: Text('昵称')),
                                    DataColumn(label: Text('性别')),
                                    DataColumn(label: Text('电话')),
                                    DataColumn(label: Text('邮箱')),
                                    DataColumn(label: Text('部门')),
                                    DataColumn(label: Text('状态')),
                                    DataColumn(label: Text('创建日期')),
                                    DataColumn(label: Text('创建人')),
                                  ],
                                  rows: controller.query.value?.content != null
                                      ? controller.query.value!.content!
                                          .map(
                                            (e) => DataRow(
                                              cells: [
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
