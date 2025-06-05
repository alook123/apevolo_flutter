import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apevolo_background_provider.g.dart';

/// 圆形移动幅度配置
class CircleMovementAmplitude {
  final double lowFreqX;
  final double lowFreqY;
  final double midFreqX;
  final double midFreqY;

  const CircleMovementAmplitude({
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

  const RectangleMovementAmplitude({
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

  const LetterMovementAmplitude({
    required this.lowFreqX,
    required this.lowFreqY,
    required this.midFreqX,
    required this.midFreqY,
    required this.highFreqX,
    required this.highFreqY,
  });
}

/// 背景动画配置
class BackgroundAnimationConfig {
  final int animationDuration;
  final CircleMovementAmplitude circleMovementAmplitude;
  final RectangleMovementAmplitude rectangleMovementAmplitude;
  final LetterMovementAmplitude letterMovementAmplitude;

  const BackgroundAnimationConfig({
    required this.animationDuration,
    required this.circleMovementAmplitude,
    required this.rectangleMovementAmplitude,
    required this.letterMovementAmplitude,
  });
}

/// ApeVolo 背景动画状态
class ApeVoloBackgroundState {
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final double animationValue;
  final double floatingValue;
  final double rotationValue;
  final Map<int, Map<String, double>> letterBasePositions;
  final Map<int, Map<String, double>> circleBasePositions;
  final Map<int, Map<String, double>> rectangleBasePositions;
  final bool positionsInitialized;
  final BackgroundAnimationConfig animationConfig;

  const ApeVoloBackgroundState({
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.animationValue,
    required this.floatingValue,
    required this.rotationValue,
    required this.letterBasePositions,
    required this.circleBasePositions,
    required this.rectangleBasePositions,
    required this.positionsInitialized,
    required this.animationConfig,
  });

  ApeVoloBackgroundState copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? tertiaryColor,
    double? animationValue,
    double? floatingValue,
    double? rotationValue,
    Map<int, Map<String, double>>? letterBasePositions,
    Map<int, Map<String, double>>? circleBasePositions,
    Map<int, Map<String, double>>? rectangleBasePositions,
    bool? positionsInitialized,
    BackgroundAnimationConfig? animationConfig,
  }) {
    return ApeVoloBackgroundState(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      animationValue: animationValue ?? this.animationValue,
      floatingValue: floatingValue ?? this.floatingValue,
      rotationValue: rotationValue ?? this.rotationValue,
      letterBasePositions: letterBasePositions ?? this.letterBasePositions,
      circleBasePositions: circleBasePositions ?? this.circleBasePositions,
      rectangleBasePositions:
          rectangleBasePositions ?? this.rectangleBasePositions,
      positionsInitialized: positionsInitialized ?? this.positionsInitialized,
      animationConfig: animationConfig ?? this.animationConfig,
    );
  }
}

/// ApeVolo 背景动画控制器
@riverpod
class ApeVoloBackgroundNotifier extends _$ApeVoloBackgroundNotifier {
  AnimationController? _animationController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;

  @override
  ApeVoloBackgroundState build() {
    return ApeVoloBackgroundState(
      primaryColor: const Color(0xFF000000),
      secondaryColor: const Color(0xFF000000),
      tertiaryColor: const Color(0xFF000000),
      animationValue: 0.0,
      floatingValue: 0.0,
      rotationValue: 0.0,
      letterBasePositions: const {},
      circleBasePositions: const {},
      rectangleBasePositions: const {},
      positionsInitialized: false,
      animationConfig: const BackgroundAnimationConfig(
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
      ),
    );
  }

  /// 初始化动画控制器
  void initializeAnimation(TickerProvider vsync) {
    if (_animationController != null) return;

    _animationController = AnimationController(
      vsync: vsync,
      duration: Duration(seconds: state.animationConfig.animationDuration),
    );

    // 创建浮动动画效果
    _floatingAnimation = TweenSequence<double>([
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
        parent: _animationController!,
        curve: Curves.easeInOut,
      ),
    );

    // 创建旋转动画
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );

    // 添加动画监听器
    _animationController!.addListener(_onAnimationUpdate);
    _animationController!.repeat();
  }

  /// 动画更新回调
  void _onAnimationUpdate() {
    if (_animationController == null) return;

    state = state.copyWith(
      animationValue: _animationController!.value,
      floatingValue: _floatingAnimation.value,
      rotationValue: _rotationAnimation.value,
    );
  }

  /// 更新颜色
  void updateColors({
    required Color primary,
    required Color secondary,
    Color? tertiary,
  }) {
    state = state.copyWith(
      primaryColor: primary,
      secondaryColor: secondary,
      tertiaryColor: tertiary ?? state.tertiaryColor,
    );
  }

  /// 加速动画
  void speedUpAnimation(double factor) {
    if (factor <= 0) return;

    final newConfig = state.animationConfig;
    updateAnimationConfig(
      animationDuration: (newConfig.animationDuration / factor).round(),
    );
  }

  /// 减速动画
  void slowDownAnimation(double factor) {
    if (factor <= 0) return;

    final newConfig = state.animationConfig;
    updateAnimationConfig(
      animationDuration: (newConfig.animationDuration * factor).round(),
    );
  }

  /// 重置动画到默认设置
  void resetAnimationToDefault() {
    const defaultConfig = BackgroundAnimationConfig(
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

    state = state.copyWith(animationConfig: defaultConfig);
    _resetAnimations();
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
          animationDuration ?? state.animationConfig.animationDuration,
      circleMovementAmplitude:
          circleMovement ?? state.animationConfig.circleMovementAmplitude,
      rectangleMovementAmplitude:
          rectangleMovement ?? state.animationConfig.rectangleMovementAmplitude,
      letterMovementAmplitude:
          letterMovement ?? state.animationConfig.letterMovementAmplitude,
    );

    state = state.copyWith(animationConfig: newConfig);
    _resetAnimations();
  }

  /// 重置动画
  void _resetAnimations() {
    if (_animationController == null) return;

    _animationController!.duration =
        Duration(seconds: state.animationConfig.animationDuration);
    _animationController!.reset();
    _animationController!.repeat();
  }

  /// 清理资源
  void clearResources() {
    state = state.copyWith(
      letterBasePositions: {},
      circleBasePositions: {},
      rectangleBasePositions: {},
      positionsInitialized: false,
    );
  }

  /// 销毁动画控制器
  void dispose() {
    _animationController?.removeListener(_onAnimationUpdate);
    _animationController?.dispose();
    _animationController = null;
  }
}
