import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/material_background_provider.dart';

/// Material 3 风格的动态背景组件
class MaterialBackgroundView extends ConsumerStatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const MaterialBackgroundView({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  ConsumerState<MaterialBackgroundView> createState() =>
      _MaterialBackgroundViewState();
}

class _MaterialBackgroundViewState extends ConsumerState<MaterialBackgroundView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // 初始化动画
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(materialBackgroundNotifierProvider.notifier)
        ..initializeAnimation(this)
        ..updateColors(
          primary: widget.primaryColor,
          secondary: widget.secondaryColor,
        );
    });
  }

  @override
  void didUpdateWidget(MaterialBackgroundView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.primaryColor != widget.primaryColor ||
        oldWidget.secondaryColor != widget.secondaryColor) {
      ref.read(materialBackgroundNotifierProvider.notifier).updateColors(
            primary: widget.primaryColor,
            secondary: widget.secondaryColor,
          );
    }
  }

  @override
  void dispose() {
    ref.read(materialBackgroundNotifierProvider.notifier).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).colorScheme.surface;
    final surfaceColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    final state = ref.watch(materialBackgroundNotifierProvider);

    return CustomPaint(
      painter: MaterialBackgroundPainter(
        primaryColor: widget.primaryColor.withOpacity(isDarkMode ? 0.25 : 0.2),
        secondaryColor:
            widget.secondaryColor.withOpacity(isDarkMode ? 0.25 : 0.2),
        backgroundColor: backgroundColor,
        isDarkMode: isDarkMode,
        animationValue: state.animationValue,
        rotationValue: state.rotationValue,
        scaleValue: state.scaleValue,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor,
              backgroundColor.withOpacity(0.9),
              surfaceColor.withOpacity(isDarkMode ? 0.7 : 0.6),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}

class MaterialBackgroundPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final bool isDarkMode;
  final double animationValue; // 0.0 到 1.0 的动画进度值
  final double rotationValue; // 旋转角度
  final double scaleValue; // 缩放值

  MaterialBackgroundPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.isDarkMode,
    required this.animationValue,
    required this.rotationValue,
    required this.scaleValue,
  });
  @override
  void paint(Canvas canvas, Size size) {
    // 绘制规则的图案背景
    _drawPatternBackground(canvas, size);
  }

  void _drawPatternBackground(Canvas canvas, Size size) {
    const patternType = 2; // 可选择不同图案类型: 0=波浪, 1=网格, 2=六边形

    switch (patternType) {
      case 0:
        _drawWavePattern(canvas, size);
        break;
      case 1:
        _drawGridPattern(canvas, size);
        break;
      case 2:
        _drawHexagonPattern(canvas, size);
        break;
    }
  }

  // 绘制动态波浪图案
  void _drawWavePattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const waveHeight = 20.0;
    const waveWidth = 40.0;
    final rows = (size.height / 25).ceil() + 1;
    final cols = (size.width / waveWidth).ceil() + 1;

    // 波浪偏移量，随时间变化
    final waveOffset = animationValue * waveWidth;

    for (int row = -1; row < rows; row++) {
      for (int i = 0; i < 2; i++) {
        final path = Path();
        final startY = row * 50.0 + i * 25.0;

        paint.color = (i == 0 ? primaryColor : secondaryColor).withOpacity(
          isDarkMode ? 0.3 : 0.25,
        );

        path.moveTo(-waveOffset, startY);

        for (int col = -1; col < cols + 1; col++) {
          final x1 = col * waveWidth + waveOffset;
          final x2 = x1 + waveWidth / 2;
          final x3 = x1 + waveWidth;

          // 波浪高度随动画变化
          final dynamicWaveHeight =
              waveHeight * (0.8 + 0.4 * math.sin(animationValue * 2 * math.pi));

          path.quadraticBezierTo(
            x1 + waveWidth / 4,
            startY + dynamicWaveHeight,
            x2,
            startY,
          );

          path.quadraticBezierTo(
            x2 + waveWidth / 4,
            startY - dynamicWaveHeight,
            x3,
            startY,
          );
        }

        canvas.drawPath(path, paint);
      }
    }
  }

  // 绘制动态网格图案
  void _drawGridPattern(Canvas canvas, Size size) {
    final primaryPaint = Paint()
      ..color = primaryColor.withOpacity(isDarkMode ? 0.22 : 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final secondaryPaint = Paint()
      ..color = secondaryColor.withOpacity(isDarkMode ? 0.20 : 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // 网格大小随动画缓慢变化
    final gridSize =
        30.0 * (0.95 + 0.1 * math.sin(animationValue * 2 * math.pi));

    // 保存当前绘制状态
    canvas.save();

    // 应用旋转效果 - 非常轻微的旋转，仅用于微妙的动态效果
    final rotationAngle =
        math.sin(animationValue * 2 * math.pi) * 0.01; // 最大旋转角度±0.01弧度
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotationAngle);
    canvas.translate(-size.width / 2, -size.height / 2);

    final horizontalLines = (size.height / gridSize).ceil() + 1;
    final verticalLines = (size.width / gridSize).ceil() + 1;

    // 绘制主网格线
    for (int i = 0; i < horizontalLines; i++) {
      final y = i * gridSize;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), primaryPaint);
    }

    for (int i = 0; i < verticalLines; i++) {
      final x = i * gridSize;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), primaryPaint);
    }

    // 绘制次网格线
    for (int i = 0; i < horizontalLines; i++) {
      final y = i * gridSize + gridSize / 2;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), secondaryPaint);
    }

    for (int i = 0; i < verticalLines; i++) {
      final x = i * gridSize + gridSize / 2;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), secondaryPaint);
    }

    // 恢复绘制状态
    canvas.restore();
  }

  // 绘制动态六边形蜂窝图案
  void _drawHexagonPattern(Canvas canvas, Size size) {
    final primaryPaint = Paint()
      ..color = primaryColor.withOpacity(isDarkMode ? 0.25 : 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final secondaryPaint = Paint()
      ..color = secondaryColor.withOpacity(isDarkMode ? 0.18 : 0.15)
      ..style = PaintingStyle.fill;

    // 保存当前绘制状态
    canvas.save();

    // 使用连续旋转 - 这里使用sin函数来实现平滑周期性旋转，避免重置点
    final smoothRotation = math.sin(rotationValue) * 0.05;

    // 应用轻微的旋转效果
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(smoothRotation); // 使用sin函数产生平滑的往复旋转
    canvas.scale(scaleValue); // 应用呼吸缩放效果
    canvas.translate(-size.width / 2, -size.height / 2);

    const hexSize = 36.0; // 六边形的基础大小
    const horizontalSpacing = hexSize * 1.5;
    double verticalSpacing = hexSize * math.sqrt(3);

    final horizontalCount =
        (size.width / horizontalSpacing).ceil() + 2; // 增加外边界
    final verticalCount = (size.height / verticalSpacing).ceil() + 2;

    // 计算额外的边界偏移量，确保旋转时边缘仍有图案
    const extraOffset = hexSize * 2;

    // 使用连续函数计算动画偏移量，避免跳跃
    final continuousAnimValue = animationValue * 2 * math.pi;

    for (int row = -2; row < verticalCount; row++) {
      for (int col = -2; col < horizontalCount; col++) {
        final isEvenRow = row % 2 == 0;
        final xOffset = isEvenRow ? 0.0 : horizontalSpacing / 2;

        // 使用正弦函数使波浪运动更加平滑，没有突变
        final waveOffset =
            math.sin((row + col) * 0.3 + continuousAnimValue) * 4.0;

        final x = col * horizontalSpacing + xOffset - extraOffset + waveOffset;
        final y = row * verticalSpacing - extraOffset + waveOffset;

        // 动态调整六边形大小 - 使用连续函数避免突变
        final sizePhase =
            (row * 0.5 + col * 0.3) * 0.2 + continuousAnimValue * 0.3;
        final dynamicSize = hexSize * (0.98 + 0.04 * math.sin(sizePhase));

        final hexagonPath = _createHexagonPath(x, y, dynamicSize);

        // 动态决定是否填充六边形 - 使用连续函数控制填充模式
        final fillPhase = (row + col) * 0.7 + continuousAnimValue * 0.5;
        final fillFactor = (math.sin(fillPhase) + 1) / 2; // 归一化到0-1范围
        final shouldFill = fillFactor > 0.5; // 50%概率填充

        if (shouldFill) {
          // 动态调整填充颜色的透明度 - 使用连续函数平滑过渡
          final opacityPhase =
              (row * 0.7 + col * 0.5) * 0.3 + continuousAnimValue * 0.4;
          final opacityBase = isDarkMode ? 0.18 : 0.15;
          final opacityVariation = isDarkMode ? 0.07 : 0.05;
          final opacity =
              opacityBase + opacityVariation * math.sin(opacityPhase);

          secondaryPaint.color = secondaryColor.withOpacity(opacity);
          canvas.drawPath(hexagonPath, secondaryPaint);
        }

        // 所有六边形都绘制边框
        canvas.drawPath(hexagonPath, primaryPaint);
      }
    }

    // 恢复绘制状态
    canvas.restore();
  }

  Path _createHexagonPath(double x, double y, double size) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * math.pi / 180;
      final xPoint = x + size * math.cos(angle);
      final yPoint = y + size * math.sin(angle);

      if (i == 0) {
        path.moveTo(xPoint, yPoint);
      } else {
        path.lineTo(xPoint, yPoint);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(MaterialBackgroundPainter oldDelegate) =>
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.isDarkMode != isDarkMode ||
      oldDelegate.animationValue != animationValue ||
      oldDelegate.rotationValue != rotationValue ||
      oldDelegate.scaleValue != scaleValue;
}
