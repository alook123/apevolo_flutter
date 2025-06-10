import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// SVG图片显示组件
/// 用于显示SVG格式的图标，支持错误处理和占位符
class SvgPictureView extends StatelessWidget {
  const SvgPictureView(
    this.assetPath, {
    super.key,
    this.width = 24,
    this.height = 24,
    this.color,
    this.fit = BoxFit.contain,
  });

  final String? assetPath;
  final double width;
  final double height;
  final Color? color;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (assetPath == null || assetPath!.isEmpty) {
      return _buildPlaceholder(context);
    }

    // 处理不同的图标路径格式
    String iconPath = _getIconPath(assetPath!);

    return SvgPicture.asset(
      iconPath,
      width: width,
      height: height,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      fit: fit,
      placeholderBuilder: (context) => _buildPlaceholder(context),
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(context),
    );
  }

  /// 获取图标路径
  String _getIconPath(String iconName) {
    // 如果已经是完整路径，直接返回
    if (iconName.startsWith('assets/')) {
      return iconName;
    }

    // 根据图标名称映射到具体路径
    final iconMappings = {
      'dashboard': 'assets/svg/dashboard.svg',
      'system': 'assets/svg/system.svg',
      'user': 'assets/svg/user.svg',
      'role': 'assets/svg/role.svg',
      'menu': 'assets/svg/menu.svg',
      'settings': 'assets/svg/settings.svg',
      'permission': 'assets/svg/permission.svg',
    };

    return iconMappings[iconName] ?? 'assets/svg/default.svg';
  }

  /// 构建占位符
  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        Icons.image_outlined,
        size: width * 0.6,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// 构建错误显示组件
  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        Icons.broken_image_outlined,
        size: width * 0.6,
        color: Theme.of(context).colorScheme.onErrorContainer,
      ),
    );
  }
}
