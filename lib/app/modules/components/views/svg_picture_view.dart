import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer' as developer;

class SvgPictureView extends GetView {
  final String? fileName;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit fit;
  final String? semanticsLabel;
  final bool allowDrawingOutsideViewBox;
  final bool excludeFromSemantics;
  final IconData defaultIcon;
  final bool showDefaultIconWhenNull;

  const SvgPictureView(
    this.fileName, {
    super.key,
    this.height = 24,
    this.width = 24,
    this.color,
    this.fit = BoxFit.cover,
    this.semanticsLabel,
    this.allowDrawingOutsideViewBox = false,
    this.excludeFromSemantics = false,
    this.defaultIcon = Icons.error,
    this.showDefaultIconWhenNull = true,
  });

  @override
  Widget build(BuildContext context) {
    // 当fileName为null时，返回空Container或默认图标
    if (fileName == null) {
      if (!showDefaultIconWhenNull) {
        return Container(); // 不显示任何内容
      }
      // 显示默认图标
      return Icon(
        defaultIcon,
        size: height ?? 24,
        color: color ?? Theme.of(context).iconTheme.color,
      );
    }

    // 确保文件路径处理逻辑清晰
    final sanitizedFileName =
        fileName!.startsWith('/') ? fileName!.substring(1) : fileName!;
    final fullPath = 'assets/svg/$sanitizedFileName.svg';

    // 确定图标颜色：优先使用传入的颜色，其次使用主题颜色
    final effectiveColor = color ?? Theme.of(context).iconTheme.color;

    final effectiveHeight = height != null ? height! : 24.0;
    final effectiveWidth = width != null ? width! : 24.0;

    return SvgPicture.asset(
      fullPath,
      height: effectiveHeight,
      width: effectiveWidth,
      colorFilter: effectiveColor != null
          ? ColorFilter.mode(
              effectiveColor,
              BlendMode.srcIn,
            )
          : null,
      fit: fit,
      semanticsLabel:
          semanticsLabel ?? (fileName != null ? 'SVG图标: $fileName' : null),
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      excludeFromSemantics: excludeFromSemantics,
      errorBuilder: (context, error, stackTrace) {
        // 记录错误以便调试
        developer.log(
          'SVG加载错误: $fileName',
          error: error,
          stackTrace: stackTrace,
          name: 'SvgPictureView',
        );
        return Icon(
          defaultIcon,
          color: Colors.red,
          size: effectiveHeight,
        );
      },
      placeholderBuilder: (context) => SizedBox(
        height: effectiveHeight,
        width: effectiveWidth,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
