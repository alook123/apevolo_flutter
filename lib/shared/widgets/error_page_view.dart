import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apevolo_flutter/core/router/constants/route_constants.dart';

/// 统一的错误页面组件
/// 可用于路由错误、页面未找到、标签页错误等场景
class ErrorPageView extends StatelessWidget {
  /// 路由状态信息（可选，用于路由错误）
  final GoRouterState? routerState;

  /// 标签页ID（可选，用于标签页错误）
  final String? tabId;

  /// 自定义错误信息（可选）
  final String? customMessage;

  /// 自定义标题（可选）
  final String? customTitle;

  const ErrorPageView({
    super.key,
    this.routerState,
    this.tabId,
    this.customMessage,
    this.customTitle,
  });

  /// 创建路由错误页面
  const ErrorPageView.router({
    super.key,
    required this.routerState,
  })  : tabId = null,
        customMessage = null,
        customTitle = null;

  /// 创建标签页错误页面
  const ErrorPageView.tab({
    super.key,
    required this.tabId,
  })  : routerState = null,
        customMessage = null,
        customTitle = null;

  /// 创建自定义错误页面
  const ErrorPageView.custom({
    super.key,
    this.customTitle,
    this.customMessage,
  })  : routerState = null,
        tabId = null;

  @override
  Widget build(BuildContext context) {
    final isRouterError = routerState != null;
    final isTabError = tabId != null;

    // 确定标题
    String title = customTitle ?? '页面未找到';

    // 确定主要错误信息
    String mainMessage = customMessage ?? (isTabError ? '标签页未找到' : '页面未找到');

    return Scaffold(
      appBar: isRouterError
          ? AppBar(
              title: Text(title),
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            )
          : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                mainMessage,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // 显示详细信息
              if (isRouterError) ..._buildRouterErrorDetails(context),
              if (isTabError) ..._buildTabErrorDetails(context),
              if (customMessage != null && !isRouterError && !isTabError)
                _buildCustomErrorDetails(context),

              const SizedBox(height: 32),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建路由错误详情
  List<Widget> _buildRouterErrorDetails(BuildContext context) {
    final state = routerState!;
    return [
      if (state.error != null) ...[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '错误详情:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${state.error}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '请求路径:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                state.matchedLocation,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                    ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  /// 构建标签页错误详情
  List<Widget> _buildTabErrorDetails(BuildContext context) {
    return [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '标签页ID:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                tabId!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                    ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  /// 构建自定义错误详情
  Widget _buildCustomErrorDetails(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          customMessage!,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons(BuildContext context) {
    if (routerState != null) {
      // 路由错误的按钮
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () => context.go(AuthRoutes.login),
            icon: const Icon(Icons.home),
            label: const Text('返回登录'),
          ),
          const SizedBox(width: 16),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('返回上页'),
          ),
        ],
      );
    } else {
      // 标签页错误或自定义错误的按钮
      return ElevatedButton.icon(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back),
        label: const Text('返回'),
      );
    }
  }
}
