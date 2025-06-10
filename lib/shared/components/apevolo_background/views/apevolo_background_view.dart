// 复制自 app/components/apevolo_background/views/apevolo_background_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import '../providers/apevolo_background_provider.dart';

/// Apevolo字母风格的Material 3动态背景组件
class ApeVoloBackgroundView extends ConsumerStatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color? tertiaryColor;

  const ApeVoloBackgroundView({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    this.tertiaryColor,
  });

  @override
  ConsumerState<ApeVoloBackgroundView> createState() =>
      _ApeVoloBackgroundViewState();
}

class _ApeVoloBackgroundViewState extends ConsumerState<ApeVoloBackgroundView>
    with TickerProviderStateMixin {
  late final ApeVoloBackgroundNotifier _notifier;

  @override
  void initState() {
    super.initState();
    // 保存 notifier 引用以便在 dispose 中使用
    _notifier = ref.read(apeVoloBackgroundNotifierProvider.notifier);

    // 初始化动画
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifier
        ..initializeAnimation(this)
        ..updateColors(
          primary: widget.primaryColor,
          secondary: widget.secondaryColor,
          tertiary: widget.tertiaryColor,
        );
    });
  }

  @override
  void didUpdateWidget(ApeVoloBackgroundView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.primaryColor != widget.primaryColor ||
        oldWidget.secondaryColor != widget.secondaryColor ||
        oldWidget.tertiaryColor != widget.tertiaryColor) {
      // 延迟执行，避免在widget构建过程中修改provider
      Future.microtask(() {
        _notifier.updateColors(
          primary: widget.primaryColor,
          secondary: widget.secondaryColor,
          tertiary: widget.tertiaryColor,
        );
      });
    }
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).colorScheme.surface;
    final tertiaryColorValue =
        widget.tertiaryColor ?? Theme.of(context).colorScheme.tertiary;

    final state = ref.watch(apeVoloBackgroundNotifierProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        // 初始化位置（仅在第一次或尺寸变化时）
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!state.positionsInitialized) {
            ref
                .read(apeVoloBackgroundNotifierProvider.notifier)
                .initializePositions(
                    Size(constraints.maxWidth, constraints.maxHeight));
          }
        });

        // 如果还没有动画控制器，不进行动画构建
        if (state.animationValue == 0.0 && !state.positionsInitialized) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  backgroundColor,
                  backgroundColor.withValues(alpha: 0.95),
                  backgroundColor.withValues(alpha: 0.9),
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          );
        }

        return CustomPaint(
          painter: ApeVoloBackgroundPainter(
            primaryColor: widget.primaryColor,
            secondaryColor: widget.secondaryColor,
            tertiaryColor: tertiaryColorValue,
            backgroundColor: backgroundColor,
            isDarkMode: isDarkMode,
            animationValue: state.animationValue,
            letterBasePositions: state.letterBasePositions,
            circleBasePositions: state.circleBasePositions,
            rectangleBasePositions: state.rectangleBasePositions,
            isPositionsInitialized: state.positionsInitialized,
            floatingValue: state.floatingValue,
            rotationValue: state.rotationValue,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  backgroundColor,
                  backgroundColor.withOpacity(0.95),
                  backgroundColor.withOpacity(0.9),
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ApeVoloBackgroundPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color backgroundColor;
  final bool isDarkMode;
  final double animationValue;
  final double floatingValue;
  final double rotationValue;
  final Map<int, Map<String, double>> letterBasePositions;
  final Map<int, Map<String, double>> circleBasePositions;
  final Map<int, Map<String, double>> rectangleBasePositions;
  final bool isPositionsInitialized;

  ApeVoloBackgroundPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.backgroundColor,
    required this.isDarkMode,
    required this.animationValue,
    required this.floatingValue,
    required this.rotationValue,
    required this.letterBasePositions,
    required this.circleBasePositions,
    required this.rectangleBasePositions,
    required this.isPositionsInitialized,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isPositionsInitialized) {
      // 如果位置还未初始化，只绘制简单的渐变背景
      return;
    }

    // 绘制圆形元素
    _drawCircles(canvas, size);

    // 绘制矩形元素
    _drawRectangles(canvas, size);

    // 绘制字母元素
    _drawLetters(canvas, size);
  }

  void _drawCircles(Canvas canvas, Size size) {
    if (circleBasePositions.isEmpty) return;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = primaryColor.withOpacity(isDarkMode ? 0.15 : 0.12);

    circleBasePositions.forEach((index, positionData) {
      final baseX = positionData['x'] ?? 0.0;
      final baseY = positionData['y'] ?? 0.0;

      // 计算动态位置偏移
      final offsetX =
          math.sin(animationValue * 2 * math.pi + index * 0.5) * 20.0;
      final offsetY =
          math.cos(animationValue * 2 * math.pi + index * 0.7) * 15.0;

      final position = Offset(baseX + offsetX, baseY + offsetY);
      final sizeVariation =
          0.8 + 0.4 * math.sin(animationValue * 2 * math.pi + index * 0.5);
      final radius = (15.0 + index % 3 * 5.0) * sizeVariation;

      // 添加脉冲效果
      final pulsePhase = animationValue * 2 * math.pi + index * 0.3;
      final pulseRadius = radius * (1.0 + 0.1 * math.sin(pulsePhase));

      canvas.drawCircle(position, pulseRadius, paint);
    });
  }

  void _drawRectangles(Canvas canvas, Size size) {
    if (rectangleBasePositions.isEmpty) return;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = secondaryColor.withOpacity(isDarkMode ? 0.18 : 0.15);

    rectangleBasePositions.forEach((index, positionData) {
      final baseX = positionData['x'] ?? 0.0;
      final baseY = positionData['y'] ?? 0.0;

      // 计算动态位置偏移
      final offsetX =
          math.sin(animationValue * 2 * math.pi + index * 0.3) * 25.0;
      final offsetY =
          math.cos(animationValue * 2 * math.pi + index * 0.8) * 18.0;

      final position = Offset(baseX + offsetX, baseY + offsetY);
      final rotation = animationValue * math.pi + index * 0.5;
      final sizeVariation =
          0.9 + 0.2 * math.sin(animationValue * 2 * math.pi + index * 0.7);
      final width = (20.0 + index % 4 * 8.0) * sizeVariation;
      final height = (15.0 + index % 3 * 6.0) * sizeVariation;

      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(rotation);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: width, height: height),
        paint,
      );
      canvas.restore();
    });
  }

  void _drawLetters(Canvas canvas, Size size) {
    if (letterBasePositions.isEmpty) return;

    const letters = ['A', 'P', 'E', 'V', 'O', 'L', 'O'];

    letterBasePositions.forEach((index, positionData) {
      if (index >= letters.length) return;

      final baseX = positionData['x'] ?? 0.0;
      final baseY = positionData['y'] ?? 0.0;

      // 计算动态位置偏移
      final offsetX =
          math.sin(animationValue * 2 * math.pi + index * 0.4) * 30.0;
      final offsetY =
          math.cos(animationValue * 2 * math.pi + index * 0.6) * 22.0;

      final position = Offset(baseX + offsetX, baseY + offsetY);
      final letter = letters[index];
      final sizeVariation =
          0.8 + 0.4 * math.sin(animationValue * 2 * math.pi + index * 0.4);
      final fontSize = (28.0 + index % 3 * 8.0) * sizeVariation;

      // 创建文字样式
      final textStyle = TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: tertiaryColor.withOpacity(isDarkMode ? 0.25 : 0.2),
        letterSpacing: 2.0,
      );

      // 创建文字绘制器
      final textPainter = TextPainter(
        text: TextSpan(text: letter, style: textStyle),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      // 应用轻微的旋转效果
      final rotation =
          math.sin(animationValue * 2 * math.pi + index * 0.6) * 0.2;

      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(rotation);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    });
  }

  @override
  bool shouldRepaint(ApeVoloBackgroundPainter oldDelegate) =>
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.tertiaryColor != tertiaryColor ||
      oldDelegate.isDarkMode != isDarkMode ||
      oldDelegate.animationValue != animationValue ||
      oldDelegate.floatingValue != floatingValue ||
      oldDelegate.rotationValue != rotationValue ||
      oldDelegate.letterBasePositions != letterBasePositions ||
      oldDelegate.circleBasePositions != circleBasePositions ||
      oldDelegate.rectangleBasePositions != rectangleBasePositions ||
      oldDelegate.isPositionsInitialized != isPositionsInitialized;
}
