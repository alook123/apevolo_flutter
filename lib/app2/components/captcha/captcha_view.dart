import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'captcha_provider.dart';

class CaptchaView extends ConsumerWidget {
  const CaptchaView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(captchaProvider);
    final notifier = ref.read(captchaProvider.notifier);
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
        if (data.image == null) return const Text('验证码为空！');
        return GestureDetector(
          onTap: notifier.fetchCaptcha,
          child: Image.memory(data.image!,
              width: 80, height: 32, fit: BoxFit.contain),
        );
      },
    );
  }
}
