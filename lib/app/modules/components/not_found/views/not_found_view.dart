import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/not_found_controller.dart';

class NotFoundView extends GetView<NotFoundController> {
  const NotFoundView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '404',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
