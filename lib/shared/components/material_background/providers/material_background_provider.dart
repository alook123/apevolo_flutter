import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'material_background_provider.g.dart';

/// Material 背景动画状态
class MaterialBackgroundState {
  final Color primaryColor;
  final Color secondaryColor;
  final double animationValue;
  final double rotationValue;
  final double scaleValue;

  const MaterialBackgroundState({
    required this.primaryColor,
    required this.secondaryColor,
    required this.animationValue,
    required this.rotationValue,
    required this.scaleValue,
  });

  MaterialBackgroundState copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    double? animationValue,
    double? rotationValue,
    double? scaleValue,
  }) {
    return MaterialBackgroundState(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      animationValue: animationValue ?? this.animationValue,
      rotationValue: rotationValue ?? this.rotationValue,
      scaleValue: scaleValue ?? this.scaleValue,
    );
  }
}

/// Material 背景动画控制器
@riverpod
class MaterialBackgroundNotifier extends _$MaterialBackgroundNotifier {
  AnimationController? _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  MaterialBackgroundState build() {
    return const MaterialBackgroundState(
      primaryColor: Color(0xFF000000),
      secondaryColor: Color(0xFF000000),
      animationValue: 0.0,
      rotationValue: 0.0,
      scaleValue: 1.0,
    );
  }

  /// 初始化动画控制器
  void initializeAnimation(TickerProvider vsync) {
    if (_animationController != null) return;

    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 20),
    );

    // 创建循环旋转动画
    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 2 * math.pi),
        weight: 100,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );

    // 创建缩放动画（呼吸效果）
    _scaleAnimation = TweenSequence<double>([
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
        parent: _animationController!,
        curve: Curves.easeInOut,
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
      rotationValue: _rotationAnimation.value,
      scaleValue: _scaleAnimation.value,
    );
  }

  /// 更新颜色
  void updateColors({required Color primary, required Color secondary}) {
    state = state.copyWith(
      primaryColor: primary,
      secondaryColor: secondary,
    );
  }

  /// 销毁动画控制器
  void dispose() {
    _animationController?.removeListener(_onAnimationUpdate);
    _animationController?.dispose();
    _animationController = null;
  }
}
