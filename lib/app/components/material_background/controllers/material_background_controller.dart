import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaterialBackgroundController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final Rx<Color> primaryColor = const Color(0xFF000000).obs;
  final Rx<Color> secondaryColor = const Color(0xFF000000).obs;

  late AnimationController animationController;
  late Animation<double> rotationAnimation;
  late Animation<double> scaleAnimation;

  void updateColors({required Color primary, required Color secondary}) {
    primaryColor.value = primary;
    secondaryColor.value = secondary;
  }

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // 动画持续时间
    );

    // 使用循环动画，但确保平滑过渡
    animationController.repeat();

    // 创建循环旋转动画 - 使用Tween<double>并设置适当的开始和结束值
    rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 2 * math.pi),
        weight: 100,
      ),
    ]).animate(
      CurvedAnimation(
        parent: animationController,
        // 使用循环曲线避免跳跃
        curve: Curves.linear,
      ),
    );

    // 创建缩放动画（呼吸效果）- 使用正弦函数实现平滑循环
    scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.05),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
