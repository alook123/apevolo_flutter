import 'package:apevolo_flutter/app/modules/permission/user/controllers/user_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/route_manager.dart';

class UserSearchView extends GetView<UserSearchController> {
  const UserSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: '请输入关键字',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.departmentTextController,
              decoration: const InputDecoration(
                labelText: '部门名称',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.keyWordTextController,
              decoration: const InputDecoration(
                labelText: '名称或邮箱',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入名称或邮箱！ ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.createFromTextController,
              decoration: InputDecoration(
                labelText: '创建开始日期',
                prefixIcon: const Icon(Icons.date_range),
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
                              controller.createFromTextController.text =
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
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.createToTextController,
              decoration: InputDecoration(
                labelText: '创建结束日期',
                prefixIcon: const Icon(Icons.date_range),
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
                              controller.createToTextController.text =
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
            const SizedBox(height: 16),
            InputDecorator(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.only(bottom: 1),
              ),
              child: DropdownButton<bool?>(
                value: controller.enabled.value,
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
                onChanged: (value) {
                  controller.enabled.value = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
