import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'apevolo_background_controller.dart';

/// Apevolo字母风格的Material 3动态背景组件
class ApeVoloBackground extends GetView<ApeVoloBackgroundController> {
  final Color primaryColor;
  final Color secondaryColor;
  final Color? tertiaryColor;

  const ApeVoloBackground({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    this.tertiaryColor,
  }) : super(key: key);

  /// 静态方法用于清理背景资源，可从外部调用
  static void clearResources() {
    // 使用Get.find找到控制器实例并调用其清理方法
    if (Get.isRegistered<ApeVoloBackgroundController>()) {
      final controller = Get.find<ApeVoloBackgroundController>();
      controller.clearResources();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).colorScheme.background;
    final tertiaryColorValue =
        tertiaryColor ?? Theme.of(context).colorScheme.tertiary;

    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: ApeVoloBackgroundPainter(
            primaryColor: primaryColor.withOpacity(isDarkMode ? 0.3 : 0.2),
            secondaryColor: secondaryColor.withOpacity(isDarkMode ? 0.3 : 0.2),
            tertiaryColor:
                tertiaryColorValue.withOpacity(isDarkMode ? 0.25 : 0.15),
            backgroundColor: backgroundColor,
            isDarkMode: isDarkMode,
            animationValue: controller.animationController.value,
            floatingValue: controller.floatingAnimation.value,
            rotationValue: controller.rotationAnimation.value,
            letterBasePositions: controller.letterBasePositions,
            positionsInitialized: controller.positionsInitialized,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  backgroundColor,
                  backgroundColor.withOpacity(0.9),
                  Theme.of(context)
                      .colorScheme
                      .surfaceVariant
                      .withOpacity(isDarkMode ? 0.7 : 0.6),
                ],
                stops: const [0.0, 0.5, 1.0],
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
  final double animationValue; // 0.0 到 1.0 的动画进度值
  final double floatingValue; // 浮动值
  final double rotationValue; // 旋转角度
  final Map<int, Map<String, double>> letterBasePositions;
  final bool positionsInitialized;

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
    required this.positionsInitialized,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制Apevolo字母风格背景
    _drawApeVoloBackground(canvas, size);
  }

  void _drawApeVoloBackground(Canvas canvas, Size size) {
    canvas.save();
    _drawLetterShapes(canvas, size);
    canvas.restore();
  }

  void _drawLetterShapes(Canvas canvas, Size size) {
    final random = math.Random(42);
    _drawFloatingCircles(canvas, size, random);
    _drawFloatingRectangles(canvas, size, random);
    _drawApeVoloLetters(canvas, size, random);
  }

  void _drawFloatingCircles(Canvas canvas, Size size, math.Random random) {
    final circleCount = 12;

    for (int i = 0; i < circleCount; i++) {
      final randomX = random.nextDouble() * size.width;
      final randomY = random.nextDouble() * size.height;
      final randomRadius = 20.0 + random.nextDouble() * 60.0;

      final floatOffsetX = math.sin((animationValue * 2 * math.pi) + i) * 20.0;
      final floatOffsetY =
          math.cos((animationValue * 2 * math.pi) + i * 1.5) * 20.0;

      final color = i % 3 == 0
          ? primaryColor
          : (i % 3 == 1 ? secondaryColor : tertiaryColor);

      final opacity =
          0.7 + math.sin((animationValue * 2 * math.pi) + i * 0.5) * 0.3;

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(randomX + floatOffsetX, randomY + floatOffsetY),
          randomRadius * (0.8 + floatingValue * 0.4), paint);
    }
  }

  void _drawFloatingRectangles(Canvas canvas, Size size, math.Random random) {
    final rectCount = 8;

    for (int i = 0; i < rectCount; i++) {
      final randomX = random.nextDouble() * size.width;
      final randomY = random.nextDouble() * size.height;

      final width = 40.0 + random.nextDouble() * 80.0;
      final height = 40.0 + random.nextDouble() * 80.0;

      final floatOffsetX =
          math.cos((animationValue * 2 * math.pi) + i * 0.7) * 25.0;
      final floatOffsetY =
          math.sin((animationValue * 2 * math.pi) + i * 1.2) * 25.0;

      final angle = rotationValue *
          (0.2 + random.nextDouble() * 0.2) *
          (i % 2 == 0 ? 1 : -1);

      final color = i % 3 == 0
          ? secondaryColor
          : (i % 3 == 1 ? primaryColor : tertiaryColor);

      final opacity =
          0.6 + math.cos((animationValue * 2 * math.pi) + i * 0.8) * 0.4;

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.save();

      canvas.translate(randomX + floatOffsetX, randomY + floatOffsetY);
      canvas.rotate(angle);

      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: width * (0.9 + floatingValue * 0.2),
        height: height * (0.9 + floatingValue * 0.2),
      );

      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.2)),
          paint);

      canvas.restore();
    }
  }

  void _drawApeVoloLetters(Canvas canvas, Size size, math.Random random) {
    final letters = ['a', 'p', 'e', 'v', 'o', 'l', 'o'];
    final letterCount = 7;

    final safeMargin = size.width * 0.1;
    final availableWidth = size.width - safeMargin * 2;
    final availableHeight = size.height - safeMargin * 2;

    // 初始化位置信息，如果尚未初始化
    if (!positionsInitialized || letterBasePositions.isEmpty) {
      for (int i = 0; i < letterCount; i++) {
        // 为每个字母创建一个确定性随机数生成器
        final letterRandom = math.Random(42 + i * 10);

        // 生成基础位置，在整个应用生命周期内保持不变
        letterBasePositions[i] = {
          'baseX': safeMargin + letterRandom.nextDouble() * availableWidth,
          'baseY': safeMargin + letterRandom.nextDouble() * availableHeight,
          'seed1': letterRandom.nextDouble() * 10,
          'seed2': letterRandom.nextDouble() * 10,
          'seed3': letterRandom.nextDouble() * 10,
          'baseSize': 50.0 + letterRandom.nextDouble() * 40.0,
        };
      }
    }

    for (int i = 0; i < letterCount; i++) {
      // 使用已初始化的位置信息
      final baseX = letterBasePositions[i]!['baseX']!;
      final baseY = letterBasePositions[i]!['baseY']!;
      final seed1 = letterBasePositions[i]!['seed1']!;
      final seed2 = letterBasePositions[i]!['seed2']!;
      final seed3 = letterBasePositions[i]!['seed3']!;
      final baseSize = letterBasePositions[i]!['baseSize']!;

      final lowFreqX = math.sin((animationValue * 0.7 * math.pi) + seed1) *
          (availableWidth * 0.3);
      final lowFreqY = math.cos((animationValue * 0.5 * math.pi) + seed2) *
          (availableHeight * 0.3);

      final midFreqX = math.sin((animationValue * 1.5 * math.pi) + seed3) *
          (availableWidth * 0.1);
      final midFreqY = math.cos((animationValue * 1.3 * math.pi) + seed1) *
          (availableHeight * 0.1);

      final highFreqX = math.sin((animationValue * 5.0 * math.pi) + seed2) *
          (availableWidth * 0.02);
      final highFreqY = math.cos((animationValue * 4.7 * math.pi) + seed3) *
          (availableHeight * 0.02);

      final posX = baseX + lowFreqX + midFreqX + highFreqX;
      final posY = baseY + lowFreqY + midFreqY + highFreqY;

      final isCardHiddenLetter = letters[i] == 'p' || letters[i] == 'l';

      final distToCenterX = posX - (size.width / 2);
      final distToCenterY = posY - (size.height / 2);
      final distToCenter = math
          .sqrt(distToCenterX * distToCenterX + distToCenterY * distToCenterY);

      double finalX = posX;
      double finalY = posY;

      if (isCardHiddenLetter && distToCenter < availableWidth * 0.2) {
        final pushDistance = availableWidth * 0.2 - distToCenter;
        if (distToCenter > 0) {
          finalX += (distToCenterX / distToCenter) * pushDistance;
          finalY += (distToCenterY / distToCenter) * pushDistance;
        } else {
          final pushAngle = seed1 * math.pi * 2;
          finalX += math.cos(pushAngle) * availableWidth * 0.2;
          finalY += math.sin(pushAngle) * availableWidth * 0.2;
        }
      }

      final letterSize = baseSize * (0.9 + floatingValue * 0.2);

      final color = i % 3 == 0
          ? tertiaryColor
          : (i % 3 == 1 ? primaryColor : secondaryColor);

      final opacity = 0.8 + math.sin((animationValue * 2 * math.pi) + i) * 0.2;

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill
        ..strokeWidth = letterSize * 0.1
        ..strokeCap = StrokeCap.round;

      canvas.save();

      canvas.translate(finalX, finalY);

      final angle = math.sin(animationValue * 1.5 * math.pi + seed1) * 0.15 +
          math.sin(animationValue * 0.7 * math.pi + seed2) * 0.05;
      canvas.rotate(angle);

      _drawSpecificLetter(canvas, letters[i], letterSize, paint);

      canvas.restore();
    }
  }

  void _drawSpecificLetter(
      Canvas canvas, String letter, double size, Paint paint) {
    switch (letter) {
      case 'a':
        _drawLetterA(canvas, size, paint);
        break;
      case 'p':
        _drawLetterP(canvas, size, paint);
        break;
      case 'e':
        _drawLetterE(canvas, size, paint);
        break;
      case 'v':
        _drawLetterV(canvas, size, paint);
        break;
      case 'o':
        _drawLetterO(canvas, size, paint);
        break;
      case 'l':
        _drawLetterL(canvas, size, paint);
        break;
      default:
        _drawLetterO(canvas, size, paint);
    }
  }

  void _drawLetterA(Canvas canvas, double size, Paint paint) {
    final strokePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.1
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    path.moveTo(-size * 0.3, size * 0.4);
    path.lineTo(0, -size * 0.4);
    path.lineTo(size * 0.3, size * 0.4);

    final crossbarPath = Path();
    crossbarPath.moveTo(-size * 0.2, size * 0.1);
    crossbarPath.lineTo(size * 0.2, size * 0.1);

    canvas.drawPath(path, strokePaint);
    canvas.drawPath(crossbarPath, strokePaint);
  }

  void _drawLetterP(Canvas canvas, double size, Paint paint) {
    final strokePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.1
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    path.moveTo(-size * 0.2, size * 0.4);
    path.lineTo(-size * 0.2, -size * 0.4);

    final arcRect = Rect.fromLTRB(
      -size * 0.2,
      -size * 0.4,
      size * 0.2,
      0,
    );
    path.addArc(arcRect, -math.pi / 2, math.pi);
    path.lineTo(-size * 0.2, 0);

    canvas.drawPath(path, strokePaint);
  }

  void _drawLetterE(Canvas canvas, double size, Paint paint) {
    final strokePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.1
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    path.moveTo(-size * 0.2, size * 0.4);
    path.lineTo(-size * 0.2, -size * 0.4);

    path.moveTo(-size * 0.2, -size * 0.4);
    path.lineTo(size * 0.2, -size * 0.4);

    final middlePath = Path();
    middlePath.moveTo(-size * 0.2, 0);
    middlePath.lineTo(size * 0.2, 0);

    final bottomPath = Path();
    bottomPath.moveTo(-size * 0.2, size * 0.4);
    bottomPath.lineTo(size * 0.2, size * 0.4);

    canvas.drawPath(path, strokePaint);
    canvas.drawPath(middlePath, strokePaint);
    canvas.drawPath(bottomPath, strokePaint);
  }

  void _drawLetterV(Canvas canvas, double size, Paint paint) {
    final strokePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.1
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    path.moveTo(-size * 0.3, -size * 0.4);
    path.lineTo(0, size * 0.4);
    path.lineTo(size * 0.3, -size * 0.4);

    canvas.drawPath(path, strokePaint);
  }

  void _drawLetterO(Canvas canvas, double size, Paint paint) {
    final strokePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.1
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final ovalRect = Rect.fromCenter(
      center: Offset.zero,
      width: size * 0.6,
      height: size * 0.8,
    );

    canvas.drawOval(ovalRect, strokePaint);
  }

  void _drawLetterL(Canvas canvas, double size, Paint paint) {
    final strokePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.1
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    path.moveTo(-size * 0.2, -size * 0.4);
    path.lineTo(-size * 0.2, size * 0.4);
    path.lineTo(size * 0.2, size * 0.4);

    canvas.drawPath(path, strokePaint);
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
      oldDelegate.positionsInitialized != positionsInitialized;
}
