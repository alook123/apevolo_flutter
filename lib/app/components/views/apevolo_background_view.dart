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

  // 存储每个字母的初始位置和种子，避免UI重建时位置跳变
  static final Map<int, Map<String, double>> _letterBasePositions = {};
  static bool _positionsInitialized = false;

  // 修改为静态方法，这样可以从ApeVoloBackgroundPainter静态访问
  static void initializeLetterPositions(Size size, math.Random globalRandom) {
    if (_positionsInitialized) return;

    final safeMargin = size.width * 0.1;
    final availableWidth = size.width - safeMargin * 2;
    final availableHeight = size.height - safeMargin * 2;

    // 为每个字母生成固定的初始位置
    for (int i = 0; i < 7; i++) {
      // 为每个字母创建一个确定性随机数生成器
      final letterRandom = math.Random(42 + i * 10);

      // 生成一个基础位置，这在整个应用生命周期内保持不变
      _letterBasePositions[i] = {
        'baseX': safeMargin + letterRandom.nextDouble() * availableWidth,
        'baseY': safeMargin + letterRandom.nextDouble() * availableHeight,
        'seed1': letterRandom.nextDouble() * 10,
        'seed2': letterRandom.nextDouble() * 10,
        'seed3': letterRandom.nextDouble() * 10,
        'baseSize': 50.0 + letterRandom.nextDouble() * 40.0,
      };
    }

    _positionsInitialized = true;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60), // 增加动画持续时间，使运动更加平缓
    );

    // 使用循环动画，但添加重复回调以确保平滑过渡
    _animationController.repeat();

    // 创建浮动动画效果，使用更平滑的曲线
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

    // 创建旋转动画，使用更平滑的过渡
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
    // 初始化字母位置
    _initializeLetterPositions(size, math.Random(42));

    // 绘制Apevolo字母风格背景
    _drawApeVoloBackground(canvas, size);
  }

  void _initializeLetterPositions(Size size, math.Random random) {
    // 静态变量，确保在ApeVoloBackgroundState类中已初始化
    _ApeVoloBackgroundState.initializeLetterPositions(size, random);
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
      // 使用预先存储的基础位置和种子值，确保每次UI重建时保持相同的起始位置
      final baseX = _ApeVoloBackgroundState._letterBasePositions[i]!['baseX']!;
      final baseY = _ApeVoloBackgroundState._letterBasePositions[i]!['baseY']!;
      final seed1 = _ApeVoloBackgroundState._letterBasePositions[i]!['seed1']!;
      final seed2 = _ApeVoloBackgroundState._letterBasePositions[i]!['seed2']!;
      final seed3 = _ApeVoloBackgroundState._letterBasePositions[i]!['seed3']!;
      final baseSize =
          _ApeVoloBackgroundState._letterBasePositions[i]!['baseSize']!;

      // 使用佩林噪声(Perlin noise)的思想，结合多个不同频率的正弦/余弦波
      // 这会产生看起来更加随机但仍然平滑的运动

      // 基础移动 - 低频
      final lowFreqX = math.sin((animationValue * 0.7 * math.pi) + seed1) *
          (availableWidth * 0.3);
      final lowFreqY = math.cos((animationValue * 0.5 * math.pi) + seed2) *
          (availableHeight * 0.3);

      // 中频移动 - 添加变化
      final midFreqX = math.sin((animationValue * 1.5 * math.pi) + seed3) *
          (availableWidth * 0.1);
      final midFreqY = math.cos((animationValue * 1.3 * math.pi) + seed1) *
          (availableHeight * 0.1);

      // 高频移动 - 添加小的随机性波动
      final highFreqX = math.sin((animationValue * 5.0 * math.pi) + seed2) *
          (availableWidth * 0.02);
      final highFreqY = math.cos((animationValue * 4.7 * math.pi) + seed3) *
          (availableHeight * 0.02);

      // 最终位置计算 - 使用固定的基础位置加上动画位移
      final posX = baseX + lowFreqX + midFreqX + highFreqX;
      final posY = baseY + lowFreqY + midFreqY + highFreqY;

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
          // 如果正好在中心，使用确定性随机方向推开（而不是每次重建UI都变化）
          final pushAngle = seed1 * math.pi * 2; // 用种子值创建固定的角度
          finalX += math.cos(pushAngle) * availableWidth * 0.2;
          finalY += math.sin(pushAngle) * availableWidth * 0.2;
        }
      }

      // 字母大小随动画变化，使用固定的基础大小
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
      // 使用种子值确保旋转角度的变化是确定性的
      final angle = math.sin(animationValue * 1.5 * math.pi + seed1) * 0.15 +
          math.sin(animationValue * 0.7 * math.pi + seed2) * 0.05;
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
