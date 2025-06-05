import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/captcha_provider.dart';

/// 验证码显示组件
///
/// 负责显示验证码图片，处理加载、错误状态
/// 属于 Auth 功能模块的 UI 组件
class CaptchaView extends ConsumerWidget {
  const CaptchaView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CaptchaState> state = ref.watch(captchaNotifierProvider);
    final CaptchaNotifier notifier = ref.read(captchaNotifierProvider.notifier);

    return state.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
          if (scaffoldMessenger != null) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text('验证码获取失败: ${err.toString()}',
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        });
        return IconButton(
          icon: Icon(Icons.error, color: Colors.red[700]),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('错误'),
                content: Text('验证码获取失败: ${err.toString()}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('关闭'),
                  ),
                ],
              ),
            );
          },
          tooltip: '点击查看错误详情',
        );
      },
      data: (data) {
        // 错误和 loading 状态始终显示，只有 data 且 isShowing=false 时才隐藏
        if (!data.isShowing) return const SizedBox.shrink();
        if (data.img == null) return const Text('验证码为空！');
        return GestureDetector(
          onTap: notifier.refresh,
          child: Image.memory(
            data.img!,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}
