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
  final Rx<Map<int, Map<String, double>>> letterBasePositions =
      Rx<Map<int, Map<String, double>>>({});
  // 存储圆形的初始位置和属性
  final Rx<Map<int, Map<String, double>>> circleBasePositions =
      Rx<Map<int, Map<String, double>>>({});
  // 存储矩形的初始位置和属性
  final Rx<Map<int, Map<String, double>>> rectangleBasePositions =
      Rx<Map<int, Map<String, double>>>({});

  // 使用Rx变量，确保在状态变化时能够正确追踪
  final RxBool positionsInitialized = false.obs;

  // 动画速度和幅度的配置参数
  final Rx<BackgroundAnimationConfig> animationConfig =
      Rx<BackgroundAnimationConfig>(
    BackgroundAnimationConfig(
      // 动画持续时间(秒)，值越小动画速度越快
      animationDuration: 60,

      // 圆形动画参数
      circleMovementAmplitude: CircleMovementAmplitude(
        lowFreqX: 0.15,
        lowFreqY: 0.15,
        midFreqX: 0.05,
        midFreqY: 0.05,
      ),

      // 矩形动画参数
      rectangleMovementAmplitude: RectangleMovementAmplitude(
        lowFreqX: 0.2,
        lowFreqY: 0.2,
        midFreqX: 0.07,
        midFreqY: 0.07,
        rotationFactorMin: 0.2,
        rotationFactorMax: 0.4,
      ),

      // 字母动画参数
      letterMovementAmplitude: LetterMovementAmplitude(
        lowFreqX: 0.3,
        lowFreqY: 0.3,
        midFreqX: 0.1,
        midFreqY: 0.1,
        highFreqX: 0.02,
        highFreqY: 0.02,
      ),
    ),
  );

  @override
  void onInit() {
    super.onInit();

    _initAnimations();

    // 添加位置状态变化的监听器
    ever(positionsInitialized, (_) => update(['background_positions']));
    ever(letterBasePositions, (_) => update(['background_positions']));
    ever(circleBasePositions, (_) => update(['background_positions']));
    ever(rectangleBasePositions, (_) => update(['background_positions']));
    ever(animationConfig, (_) {
      _resetAnimations();
      update(['background_positions']);
    });
  }

  /// 初始化动画
  void _initAnimations() {
    // 初始化动画控制器
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: animationConfig.value.animationDuration),
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

  /// 动态调整动画时长并重设动画
  void _updateAnimationDuration(int newDurationInSeconds) {
    // 记录当前动画的位置
    final currentValue = animationController.value;

    // 停止但不销毁动画控制器
    animationController.stop();

    // 直接修改动画控制器的持续时间
    animationController.duration = Duration(seconds: newDurationInSeconds);

    // 保持原来的值，避免动画跳变
    animationController.value = currentValue;

    // 重新开始循环动画
    animationController.repeat();
  }

  /// 重置动画 - 避免销毁和重建动画控制器
  void _resetAnimations() {
    // 更新动画持续时间
    _updateAnimationDuration(animationConfig.value.animationDuration);

    // 不需要重新创建动画对象，它们会自动使用更新后的控制器
  }

  /// 更新动画配置
  void updateAnimationConfig({
    int? animationDuration,
    CircleMovementAmplitude? circleMovement,
    RectangleMovementAmplitude? rectangleMovement,
    LetterMovementAmplitude? letterMovement,
  }) {
    final newConfig = BackgroundAnimationConfig(
      animationDuration:
          animationDuration ?? animationConfig.value.animationDuration,
      circleMovementAmplitude:
          circleMovement ?? animationConfig.value.circleMovementAmplitude,
      rectangleMovementAmplitude:
          rectangleMovement ?? animationConfig.value.rectangleMovementAmplitude,
      letterMovementAmplitude:
          letterMovement ?? animationConfig.value.letterMovementAmplitude,
    );

    animationConfig.value = newConfig;
  }

  /// 加速动画 (倍数值)
  void speedUpAnimation(double factor) {
    if (factor <= 0) return;

    // 缩短动画时间
    final newDuration =
        (animationConfig.value.animationDuration / factor).round();

    // 增加动画幅度
    final circleMovement = animationConfig.value.circleMovementAmplitude;
    final rectangleMovement = animationConfig.value.rectangleMovementAmplitude;
    final letterMovement = animationConfig.value.letterMovementAmplitude;

    updateAnimationConfig(
      animationDuration: newDuration,
      circleMovement: CircleMovementAmplitude(
        lowFreqX: circleMovement.lowFreqX * factor.clamp(1.0, 2.0),
        lowFreqY: circleMovement.lowFreqY * factor.clamp(1.0, 2.0),
        midFreqX: circleMovement.midFreqX * factor.clamp(1.0, 2.0),
        midFreqY: circleMovement.midFreqY * factor.clamp(1.0, 2.0),
      ),
      rectangleMovement: RectangleMovementAmplitude(
        lowFreqX: rectangleMovement.lowFreqX * factor.clamp(1.0, 2.0),
        lowFreqY: rectangleMovement.lowFreqY * factor.clamp(1.0, 2.0),
        midFreqX: rectangleMovement.midFreqX * factor.clamp(1.0, 2.0),
        midFreqY: rectangleMovement.midFreqY * factor.clamp(1.0, 2.0),
        rotationFactorMin:
            rectangleMovement.rotationFactorMin * factor.clamp(1.0, 2.0),
        rotationFactorMax:
            rectangleMovement.rotationFactorMax * factor.clamp(1.0, 2.0),
      ),
      letterMovement: LetterMovementAmplitude(
        lowFreqX: letterMovement.lowFreqX * factor.clamp(1.0, 2.0),
        lowFreqY: letterMovement.lowFreqY * factor.clamp(1.0, 2.0),
        midFreqX: letterMovement.midFreqX * factor.clamp(1.0, 2.0),
        midFreqY: letterMovement.midFreqY * factor.clamp(1.0, 2.0),
        highFreqX: letterMovement.highFreqX * factor.clamp(1.0, 2.0),
        highFreqY: letterMovement.highFreqY * factor.clamp(1.0, 2.0),
      ),
    );
  }

  /// 减慢动画 (倍数值)
  void slowDownAnimation(double factor) {
    if (factor <= 0) return;

    // 延长动画时间
    final newDuration =
        (animationConfig.value.animationDuration * factor).round();

    // 减小动画幅度
    final circleMovement = animationConfig.value.circleMovementAmplitude;
    final rectangleMovement = animationConfig.value.rectangleMovementAmplitude;
    final letterMovement = animationConfig.value.letterMovementAmplitude;

    updateAnimationConfig(
      animationDuration: newDuration,
      circleMovement: CircleMovementAmplitude(
        lowFreqX: circleMovement.lowFreqX / factor.clamp(1.0, 2.0),
        lowFreqY: circleMovement.lowFreqY / factor.clamp(1.0, 2.0),
        midFreqX: circleMovement.midFreqX / factor.clamp(1.0, 2.0),
        midFreqY: circleMovement.midFreqY / factor.clamp(1.0, 2.0),
      ),
      rectangleMovement: RectangleMovementAmplitude(
        lowFreqX: rectangleMovement.lowFreqX / factor.clamp(1.0, 2.0),
        lowFreqY: rectangleMovement.lowFreqY / factor.clamp(1.0, 2.0),
        midFreqX: rectangleMovement.midFreqX / factor.clamp(1.0, 2.0),
        midFreqY: rectangleMovement.midFreqY / factor.clamp(1.0, 2.0),
        rotationFactorMin:
            rectangleMovement.rotationFactorMin / factor.clamp(1.0, 2.0),
        rotationFactorMax:
            rectangleMovement.rotationFactorMax / factor.clamp(1.0, 2.0),
      ),
      letterMovement: LetterMovementAmplitude(
        lowFreqX: letterMovement.lowFreqX / factor.clamp(1.0, 2.0),
        lowFreqY: letterMovement.lowFreqY / factor.clamp(1.0, 2.0),
        midFreqX: letterMovement.midFreqX / factor.clamp(1.0, 2.0),
        midFreqY: letterMovement.midFreqY / factor.clamp(1.0, 2.0),
        highFreqX: letterMovement.highFreqX / factor.clamp(1.0, 2.0),
        highFreqY: letterMovement.highFreqY / factor.clamp(1.0, 2.0),
      ),
    );
  }

  /// 恢复动画默认设置
  void resetAnimationToDefault() {
    animationConfig.value = BackgroundAnimationConfig(
      animationDuration: 60,
      circleMovementAmplitude: CircleMovementAmplitude(
        lowFreqX: 0.15,
        lowFreqY: 0.15,
        midFreqX: 0.05,
        midFreqY: 0.05,
      ),
      rectangleMovementAmplitude: RectangleMovementAmplitude(
        lowFreqX: 0.2,
        lowFreqY: 0.2,
        midFreqX: 0.07,
        midFreqY: 0.07,
        rotationFactorMin: 0.2,
        rotationFactorMax: 0.4,
      ),
      letterMovementAmplitude: LetterMovementAmplitude(
        lowFreqX: 0.3,
        lowFreqY: 0.3,
        midFreqX: 0.1,
        midFreqY: 0.1,
        highFreqX: 0.02,
        highFreqY: 0.02,
      ),
    );
  }

  /// 清理资源方法
  void clearResources() {
    letterBasePositions.value.clear();
    circleBasePositions.value.clear();
    rectangleBasePositions.value.clear();
    positionsInitialized.value = false;
    update(['background_positions']);
  }

  /// 获取圆形动画幅度参数
  CircleMovementAmplitude get circleAmplitude =>
      animationConfig.value.circleMovementAmplitude;

  /// 获取矩形动画幅度参数
  RectangleMovementAmplitude get rectangleAmplitude =>
      animationConfig.value.rectangleMovementAmplitude;

  /// 获取字母动画幅度参数
  LetterMovementAmplitude get letterAmplitude =>
      animationConfig.value.letterMovementAmplitude;

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

/// 背景动画配置
class BackgroundAnimationConfig {
  final int animationDuration;
  final CircleMovementAmplitude circleMovementAmplitude;
  final RectangleMovementAmplitude rectangleMovementAmplitude;
  final LetterMovementAmplitude letterMovementAmplitude;

  BackgroundAnimationConfig({
    required this.animationDuration,
    required this.circleMovementAmplitude,
    required this.rectangleMovementAmplitude,
    required this.letterMovementAmplitude,
  });
}

/// 圆形移动幅度配置
class CircleMovementAmplitude {
  final double lowFreqX;
  final double lowFreqY;
  final double midFreqX;
  final double midFreqY;

  CircleMovementAmplitude({
    required this.lowFreqX,
    required this.lowFreqY,
    required this.midFreqX,
    required this.midFreqY,
  });
}

/// 矩形移动幅度配置
class RectangleMovementAmplitude {
  final double lowFreqX;
  final double lowFreqY;
  final double midFreqX;
  final double midFreqY;
  final double rotationFactorMin;
  final double rotationFactorMax;

  RectangleMovementAmplitude({
    required this.lowFreqX,
    required this.lowFreqY,
    required this.midFreqX,
    required this.midFreqY,
    required this.rotationFactorMin,
    required this.rotationFactorMax,
  });
}

/// 字母移动幅度配置
class LetterMovementAmplitude {
  final double lowFreqX;
  final double lowFreqY;
  final double midFreqX;
  final double midFreqY;
  final double highFreqX;
  final double highFreqY;

  LetterMovementAmplitude({
    required this.lowFreqX,
    required this.lowFreqY,
    required this.midFreqX,
    required this.midFreqY,
    required this.highFreqX,
    required this.highFreqY,
  });
}
