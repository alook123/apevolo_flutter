import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ApeVolo背景的控制器类，管理动画和状态
class ApeVoloBackgroundController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> floatingAnimation;
  late Animation<double> rotationAnimation;

  // 存储每个字母的初始位置和种子，避免UI重建时位置跳变
  final Map<int, Map<String, double>> letterBasePositions = {};
  bool positionsInitialized = false;

  @override
  void onInit() {
    super.onInit();

    // 初始化动画控制器
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60), // 增加动画持续时间，使运动更加平缓
    );

    // 使用循环动画
    animationController.repeat();

    // 创建浮动动画效果，使用更平滑的曲线
    floatingAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    // 创建旋转动画，使用更平滑的过渡
    rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );
  }

  /// 清理资源方法
  void clearResources() {
    letterBasePositions.clear();
    positionsInitialized = false;
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
