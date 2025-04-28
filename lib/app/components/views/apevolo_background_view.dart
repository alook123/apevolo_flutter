import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Apevolo字母风格的Material 3动态背景组件
class ApeVoloBackground extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color? tertiaryColor;

  const ApeVoloBackground({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    this.tertiaryColor,
  }) : super(key: key);

  @override
  State<ApeVoloBackground> createState() => _ApeVoloBackgroundState();
}

class _ApeVoloBackgroundState extends State<ApeVoloBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), // 动画持续时间
    );

    // 使用循环动画
    _animationController.repeat();

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
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // 创建旋转动画
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).colorScheme.background;
    final tertiaryColor =
        widget.tertiaryColor ?? Theme.of(context).colorScheme.tertiary;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: ApeVoloBackgroundPainter(
            primaryColor:
                widget.primaryColor.withOpacity(isDarkMode ? 0.3 : 0.2),
            secondaryColor:
                widget.secondaryColor.withOpacity(isDarkMode ? 0.3 : 0.2),
            tertiaryColor: tertiaryColor.withOpacity(isDarkMode ? 0.25 : 0.15),
            backgroundColor: backgroundColor,
            isDarkMode: isDarkMode,
            animationValue: _animationController.value,
            floatingValue: _floatingAnimation.value,
            rotationValue: _rotationAnimation.value,
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

  ApeVoloBackgroundPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.backgroundColor,
    required this.isDarkMode,
    required this.animationValue,
    required this.floatingValue,
    required this.rotationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制Apevolo字母风格背景
    _drawApeVoloBackground(canvas, size);
  }

  void _drawApeVoloBackground(Canvas canvas, Size size) {
    // 保存当前绘制状态
    canvas.save();

    // 绘制Apevolo字母色块
    _drawLetterShapes(canvas, size);

    // 恢复绘制状态
    canvas.restore();
  }

  void _drawLetterShapes(Canvas canvas, Size size) {
    // 创建随机数生成器，但与动画值相关联以确保确定性
    final random = math.Random(42);

    // 绘制各种形状
    _drawFloatingCircles(canvas, size, random);
    _drawFloatingRectangles(canvas, size, random);
    _drawApeVoloLetters(canvas, size, random);
  }

  void _drawFloatingCircles(Canvas canvas, Size size, math.Random random) {
    final circleCount = 12;

    for (int i = 0; i < circleCount; i++) {
      // 使用随机数，但以确定性方式生成，确保不会在动画期间改变位置
      final randomX = random.nextDouble() * size.width;
      final randomY = random.nextDouble() * size.height;
      final randomRadius = 20.0 + random.nextDouble() * 60.0;

      // 使用动画值计算漂浮效果
      final floatOffsetX = math.sin((animationValue * 2 * math.pi) + i) * 20.0;
      final floatOffsetY =
          math.cos((animationValue * 2 * math.pi) + i * 1.5) * 20.0;

      // 循环交替使用颜色
      final color = i % 3 == 0
          ? primaryColor
          : (i % 3 == 1 ? secondaryColor : tertiaryColor);

      // 为圆形添加透明度变化效果
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

      // 尺寸和位置偏移使用动画值进行计算
      final width = 40.0 + random.nextDouble() * 80.0;
      final height = 40.0 + random.nextDouble() * 80.0;

      final floatOffsetX =
          math.cos((animationValue * 2 * math.pi) + i * 0.7) * 25.0;
      final floatOffsetY =
          math.sin((animationValue * 2 * math.pi) + i * 1.2) * 25.0;

      // 旋转角度
      final angle = rotationValue *
          (0.2 + random.nextDouble() * 0.2) *
          (i % 2 == 0 ? 1 : -1);

      // 颜色选择
      final color = i % 3 == 0
          ? secondaryColor
          : (i % 3 == 1 ? primaryColor : tertiaryColor);

      // 透明度变化效果
      final opacity =
          0.6 + math.cos((animationValue * 2 * math.pi) + i * 0.8) * 0.4;

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.save();

      // 应用动画效果
      canvas.translate(randomX + floatOffsetX, randomY + floatOffsetY);
      canvas.rotate(angle);

      // 绘制圆角矩形
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
    // "apevolo"的每个字母
    final letters = ['a', 'p', 'e', 'v', 'o', 'l', 'o'];
    final letterCount = 7; // 对应"apevolo"的7个字母

    // 设置一个边缘安全区域，防止字母太靠近边缘导致清晰度下降或被裁剪
    final safeMargin = size.width * 0.1; // 屏幕宽度的10%作为安全边距

    // 可用区域尺寸
    final availableWidth = size.width - safeMargin * 2;
    final availableHeight = size.height - safeMargin * 2;

    for (int i = 0; i < letterCount; i++) {
      // 为每个字母生成一个随机初始位置和方向，但基于确定性随机数，以保证一致性
      // 随机种子基于字母索引，这样每个字母都会有自己的随机序列
      final letterRandom = math.Random(42 + i * 10);

      // 随机初始位置（一个确定的初始位置）
      // 注意：我们使用animationValue来模拟时间的流逝

      // 使用佩林噪声(Perlin noise)的思想，结合多个不同频率的正弦/余弦波
      // 这会产生看起来更加随机但仍然平滑的运动

      // 基础移动 - 低频
      final lowFreqX = math.sin((animationValue * 0.7 * math.pi) + i * 1.5) *
          (availableWidth * 0.3);
      final lowFreqY = math.cos((animationValue * 0.5 * math.pi) + i * 2.1) *
          (availableHeight * 0.3);

      // 中频移动 - 添加变化
      final midFreqX = math.sin((animationValue * 1.5 * math.pi) + i * 3.7) *
          (availableWidth * 0.1);
      final midFreqY = math.cos((animationValue * 1.3 * math.pi) + i * 2.9) *
          (availableHeight * 0.1);

      // 高频移动 - 添加小的随机性波动
      final highFreqX = math.sin((animationValue * 5.0 * math.pi) + i * 7.3) *
          (availableWidth * 0.02);
      final highFreqY = math.cos((animationValue * 4.7 * math.pi) + i * 6.5) *
          (availableHeight * 0.02);

      // 应用噪声扰动 - 使用不同相位的正弦函数，创造更不规则的运动
      // 以不同速率移动的噪声
      final noiseX = (math.sin(animationValue * 3.1 + i) * 0.3 +
              math.sin(animationValue * 1.7 + i * 2.3) * 0.4 +
              math.sin(animationValue * 0.5 + i * 3.7) * 0.3) *
          (availableWidth * 0.1);

      final noiseY = (math.cos(animationValue * 2.3 + i * 1.1) * 0.3 +
              math.cos(animationValue * 1.1 + i * 3.1) * 0.4 +
              math.cos(animationValue * 0.7 + i * 2.5) * 0.3) *
          (availableHeight * 0.1);

      // 每个字母有不同的基准位置偏移，使它们分散在屏幕上
      final baseOffsetX = letterRandom.nextDouble() * availableWidth * 0.6 -
          availableWidth * 0.3;
      final baseOffsetY = letterRandom.nextDouble() * availableHeight * 0.6 -
          availableHeight * 0.3;

      // 最终位置计算
      final posX = safeMargin +
          availableWidth * 0.5 +
          baseOffsetX +
          lowFreqX +
          midFreqX +
          highFreqX +
          noiseX;
      final posY = safeMargin +
          availableHeight * 0.5 +
          baseOffsetY +
          lowFreqY +
          midFreqY +
          highFreqY +
          noiseY;

      // 特殊处理字母p和l，避免它们总是在屏幕中心（登录卡片位置）
      final isCardHiddenLetter = letters[i] == 'p' || letters[i] == 'l';

      // 登录卡片通常在屏幕中心，我们避免这些字母靠近屏幕中心
      // 计算到屏幕中心的距离
      final distToCenterX = posX - (size.width / 2);
      final distToCenterY = posY - (size.height / 2);
      final distToCenter = math
          .sqrt(distToCenterX * distToCenterX + distToCenterY * distToCenterY);

      // 如果特殊字母太靠近中心，则推开它们
      double finalX = posX;
      double finalY = posY;

      if (isCardHiddenLetter && distToCenter < availableWidth * 0.2) {
        // 将字母推开，远离中心
        final pushDistance = availableWidth * 0.2 - distToCenter;
        // 如果距离不为0，则正常化矢量
        if (distToCenter > 0) {
          finalX += (distToCenterX / distToCenter) * pushDistance;
          finalY += (distToCenterY / distToCenter) * pushDistance;
        } else {
          // 如果正好在中心，随机选择一个方向推开
          final randomAngle = letterRandom.nextDouble() * 2 * math.pi;
          finalX += math.cos(randomAngle) * availableWidth * 0.2;
          finalY += math.sin(randomAngle) * availableWidth * 0.2;
        }
      }

      // 字母大小随动画变化，增加基础大小使字母更清晰
      final baseSize = 50.0 + letterRandom.nextDouble() * 40.0; // 增加基础大小
      final letterSize = baseSize * (0.9 + floatingValue * 0.2);

      // 颜色随机选择
      final color = i % 3 == 0
          ? tertiaryColor
          : (i % 3 == 1 ? primaryColor : secondaryColor);

      // 透明度变化，增加最小透明度以提高清晰度
      final opacity = 0.8 + math.sin((animationValue * 2 * math.pi) + i) * 0.2;

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill
        ..strokeWidth = letterSize * 0.1
        ..strokeCap = StrokeCap.round;

      canvas.save();

      // 应用最终位置
      canvas.translate(finalX, finalY);

      // 随机旋转效果，结合多个频率使旋转不那么规则
      final angle = math.sin(animationValue * 1.5 * math.pi + i * 0.7) * 0.15 +
          math.sin(animationValue * 0.7 * math.pi + i * 1.3) * 0.05;
      canvas.rotate(angle);

      // 绘制相应的字母
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
        _drawLetterO(canvas, size, paint); // 默认为'o'
    }
  }

  void _drawLetterA(Canvas canvas, double size, Paint paint) {
    final strokePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.1 // 增加笔画粗细
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true; // 启用抗锯齿

    final path = Path();
    // 绘制字母'a'的主要部分
    path.moveTo(-size * 0.3, size * 0.4); // 左下角起点
    path.lineTo(0, -size * 0.4); // 顶点
    path.lineTo(size * 0.3, size * 0.4); // 右下角

    // 绘制横线
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
      ..strokeWidth = size * 0.1 // 增加笔画粗细
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true; // 启用抗锯齿

    final path = Path();
    // 绘制字母'p'的竖线
    path.moveTo(-size * 0.2, size * 0.4); // 左下角
    path.lineTo(-size * 0.2, -size * 0.4); // 竖线到顶部

    // 绘制p的环形部分
    final arcRect = Rect.fromLTRB(
      -size * 0.2,
      -size * 0.4,
      size * 0.2,
      0, // 调整闭合位置，使弧线更加明显
    );
    path.addArc(arcRect, -math.pi / 2, math.pi);
    path.lineTo(-size * 0.2, 0); // 闭合环形

    canvas.drawPath(path, strokePaint);
  }

  void _drawLetterE(Canvas canvas, double size, Paint paint) {
    final strokePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.1 // 增加笔画粗细
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true; // 启用抗锯齿

    final path = Path();
    // 绘制字母'e'的竖线
    path.moveTo(-size * 0.2, size * 0.4); // 左下角
    path.lineTo(-size * 0.2, -size * 0.4); // 竖线到顶部

    // 绘制e的三条横线
    // 顶部横线
    path.moveTo(-size * 0.2, -size * 0.4);
    path.lineTo(size * 0.2, -size * 0.4);

    // 中间横线
    final middlePath = Path();
    middlePath.moveTo(-size * 0.2, 0);
    middlePath.lineTo(size * 0.2, 0); // 延长中间横线

    // 底部横线
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
      ..strokeWidth = size * 0.1 // 增加笔画粗细
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true; // 启用抗锯齿

    final path = Path();
    // 绘制字母'v'的两条线
    path.moveTo(-size * 0.3, -size * 0.4); // 左上角
    path.lineTo(0, size * 0.4); // 底部中点
    path.lineTo(size * 0.3, -size * 0.4); // 右上角

    canvas.drawPath(path, strokePaint);
  }

  void _drawLetterO(Canvas canvas, double size, Paint paint) {
    final strokePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.1 // 增加笔画粗细
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true; // 启用抗锯齿

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
      ..strokeWidth = size * 0.1 // 增加笔画粗细
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true; // 启用抗锯齿

    final path = Path();
    // 绘制字母'L'的竖线
    path.moveTo(-size * 0.2, -size * 0.4); // 左上角
    path.lineTo(-size * 0.2, size * 0.4); // 竖线到底部

    // 绘制底部横线
    path.lineTo(size * 0.2, size * 0.4); // 右下角

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
      oldDelegate.rotationValue != rotationValue;
}
