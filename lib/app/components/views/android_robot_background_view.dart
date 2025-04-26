import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Android机器人风格的Material 3动态背景组件
class AndroidRobotBackground extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color? tertiaryColor;

  const AndroidRobotBackground({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    this.tertiaryColor,
  }) : super(key: key);

  @override
  State<AndroidRobotBackground> createState() => _AndroidRobotBackgroundState();
}

class _AndroidRobotBackgroundState extends State<AndroidRobotBackground>
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
          painter: AndroidRobotBackgroundPainter(
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

class AndroidRobotBackgroundPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color backgroundColor;
  final bool isDarkMode;
  final double animationValue; // 0.0 到 1.0 的动画进度值
  final double floatingValue; // 浮动值
  final double rotationValue; // 旋转角度

  AndroidRobotBackgroundPainter({
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
    // 绘制Android机器人风格背景
    _drawAndroidRobotBackground(canvas, size);
  }

  void _drawAndroidRobotBackground(Canvas canvas, Size size) {
    // 保存当前绘制状态
    canvas.save();

    // 绘制Android机器人色块
    _drawRobotShapes(canvas, size);

    // 恢复绘制状态
    canvas.restore();
  }

  void _drawRobotShapes(Canvas canvas, Size size) {
    // 创建随机数生成器，但与动画值相关联以确保确定性
    final random = math.Random(42);

    // 绘制各种形状
    _drawFloatingCircles(canvas, size, random);
    _drawFloatingRectangles(canvas, size, random);
    _drawAndroidRobots(canvas, size, random);
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

  void _drawAndroidRobots(Canvas canvas, Size size, math.Random random) {
    final robotCount = 5;

    for (int i = 0; i < robotCount; i++) {
      final randomX = size.width * (0.1 + random.nextDouble() * 0.8);
      final randomY = size.height * (0.1 + random.nextDouble() * 0.8);

      final floatOffsetX =
          math.sin((animationValue * 2 * math.pi) + i * 1.3) * 30.0;
      final floatOffsetY =
          math.cos((animationValue * 2 * math.pi) + i * 0.9) * 30.0;

      // 机器人大小随动画变化
      final baseSize = 30.0 + random.nextDouble() * 40.0;
      final robotSize = baseSize * (0.9 + floatingValue * 0.2);

      // 颜色随机选择
      final color = i % 3 == 0
          ? tertiaryColor
          : (i % 3 == 1 ? primaryColor : secondaryColor);

      // 透明度变化
      final opacity = 0.7 + math.sin((animationValue * 2 * math.pi) + i) * 0.3;

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.save();

      // 应用位置和旋转
      final centerX = randomX + floatOffsetX;
      final centerY = randomY + floatOffsetY;
      canvas.translate(centerX, centerY);

      // 轻微的旋转效果
      final angle = (math.sin(animationValue * 2 * math.pi + i) * 0.15);
      canvas.rotate(angle);

      // 绘制Android机器人
      _drawRobot(canvas, robotSize, paint);

      canvas.restore();
    }
  }

  void _drawRobot(Canvas canvas, double size, Paint paint) {
    // 简化的Android机器人形状
    final bodyWidth = size * 0.8;
    final bodyHeight = size;
    final headRadius = size * 0.4;

    // 绘制身体（圆角矩形）
    final bodyRect = Rect.fromCenter(
      center: Offset(0, headRadius + bodyHeight * 0.5),
      width: bodyWidth,
      height: bodyHeight,
    );

    canvas.drawRRect(
        RRect.fromRectAndRadius(bodyRect, Radius.circular(bodyWidth * 0.2)),
        paint);

    // 绘制头部（圆形）
    canvas.drawCircle(Offset(0, 0), headRadius, paint);

    // 绘制天线
    final antennaWidth = size * 0.05;
    final antennaHeight = size * 0.2;
    final antennaSpacing = size * 0.2;

    // 左天线
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(-antennaSpacing, -headRadius - antennaHeight,
                antennaWidth, antennaHeight),
            Radius.circular(antennaWidth * 0.5)),
        paint);

    // 右天线
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(antennaSpacing - antennaWidth,
                -headRadius - antennaHeight, antennaWidth, antennaHeight),
            Radius.circular(antennaWidth * 0.5)),
        paint);

    // 绘制手臂
    final armWidth = size * 0.15;
    final armHeight = size * 0.6;
    final armOffset = bodyWidth * 0.5 + armWidth * 0.5;

    // 添加手臂浮动动画
    final leftArmAngle = math.sin(animationValue * 2 * math.pi) * 0.15;
    final rightArmAngle = math.cos(animationValue * 2 * math.pi) * 0.15;

    // 左手臂
    canvas.save();
    canvas.translate(-armOffset, headRadius + bodyHeight * 0.3);
    canvas.rotate(leftArmAngle);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset.zero, width: armWidth, height: armHeight),
            Radius.circular(armWidth * 0.5)),
        paint);
    canvas.restore();

    // 右手臂
    canvas.save();
    canvas.translate(armOffset, headRadius + bodyHeight * 0.3);
    canvas.rotate(rightArmAngle);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset.zero, width: armWidth, height: armHeight),
            Radius.circular(armWidth * 0.5)),
        paint);
    canvas.restore();

    // 绘制腿
    final legWidth = size * 0.15;
    final legHeight = size * 0.4;
    final legOffset = bodyWidth * 0.25;
    final legY = headRadius + bodyHeight;

    // 添加腿部浮动动画
    final leftLegAngle = math.cos(animationValue * 2 * math.pi) * 0.1;
    final rightLegAngle = math.sin(animationValue * 2 * math.pi) * 0.1;

    // 左腿
    canvas.save();
    canvas.translate(-legOffset, legY);
    canvas.rotate(leftLegAngle);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset.zero, width: legWidth, height: legHeight),
            Radius.circular(legWidth * 0.5)),
        paint);
    canvas.restore();

    // 右腿
    canvas.save();
    canvas.translate(legOffset, legY);
    canvas.rotate(rightLegAngle);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset.zero, width: legWidth, height: legHeight),
            Radius.circular(legWidth * 0.5)),
        paint);
    canvas.restore();

    // 绘制眼睛
    final eyeRadius = size * 0.08;
    final eyeOffset = size * 0.15;
    final eyeY = -size * 0.05;

    // 眼睛使用相反的颜色，使用白色眼睛
    final eyePaint = Paint()
      ..color = isDarkMode ? Colors.white60 : Colors.white70
      ..style = PaintingStyle.fill;

    // 左眼
    canvas.drawCircle(Offset(-eyeOffset, eyeY), eyeRadius, eyePaint);

    // 右眼
    canvas.drawCircle(Offset(eyeOffset, eyeY), eyeRadius, eyePaint);
  }

  @override
  bool shouldRepaint(AndroidRobotBackgroundPainter oldDelegate) =>
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.tertiaryColor != tertiaryColor ||
      oldDelegate.isDarkMode != isDarkMode ||
      oldDelegate.animationValue != animationValue ||
      oldDelegate.floatingValue != floatingValue ||
      oldDelegate.rotationValue != rotationValue;
}
