import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'captcha_provider.dart';

class CaptchaView extends ConsumerWidget {
  const CaptchaView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(captchaProvider);
    final notifier = ref.read(captchaProvider.notifier);
    if (!state.isShowing) return const SizedBox.shrink();
    if (state.isLoading) return const CircularProgressIndicator();
    if (state.error != null) {
      return Text('获取失败: ${state.error!}',
          style: const TextStyle(color: Colors.red));
    }
    if (state.image == null) return const Text('验证码为空！');
    return GestureDetector(
      onTap: notifier.fetchCaptcha,
      child: Image.memory(state.image!,
          width: 80, height: 32, fit: BoxFit.contain),
    );
  }
}
