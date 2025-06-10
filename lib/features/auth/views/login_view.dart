import 'package:apevolo_flutter/shared/components/material_background/views/material_background_view.dart';
import 'package:apevolo_flutter/shared/components/theme_switch_button.dart';
import 'package:apevolo_flutter/shared/components/theme_toggle_icon_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apevolo_flutter/features/auth/providers/login_provider.dart';
import 'package:apevolo_flutter/features/auth/widgets/captcha_view.dart';
import 'package:apevolo_flutter/features/auth/providers/captcha_provider.dart';
import 'package:apevolo_flutter/shared/components/apevolo_background/views/apevolo_background_view.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginNotifierProvider);
    final notifier = ref.read(loginNotifierProvider.notifier);
    final usernameController = useTextEditingController(text: state.username);
    final passwordController = useTextEditingController(text: state.password);
    final captchaController = useTextEditingController(text: state.captchaText);
    final focusNode = useFocusNode();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // 监听登录状态变化，处理导航
    ref.listen(loginNotifierProvider, (previous, current) {
      if (kDebugMode) {
        print(
            'LoginView: 登录状态变化 - previous?.isLoading: ${previous?.isLoading}, current.isLoading: ${current.isLoading}, current.error: ${current.error}');
      }

      // 检查是否登录成功（之前在加载中，现在不在加载且没有错误）
      if (previous?.isLoading == true &&
          !current.isLoading &&
          current.error == null) {
        if (kDebugMode) {
          print('LoginView: 检测到登录成功，准备导航到Shell页面');
        }
        // 使用PostFrameCallback确保在widget构建完成后导航
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            if (kDebugMode) {
              print('LoginView: 执行导航到Shell页面');
            }
            Navigator.of(context).pushReplacementNamed('/shell');
          }
        });
      }
    });

    // // 背景类型
    // final backgroundTypeIndex = state.backgroundTypeIndex;
    // Widget backgroundWidget;
    // if (backgroundTypeIndex == 1) {
    //   backgroundWidget = MaterialBackgroundView(
    //     primaryColor: Theme.of(context).colorScheme.primary,
    //     secondaryColor: Theme.of(context).colorScheme.tertiary,
    //   );
    // } else {
    //   backgroundWidget = ApeVoloBackgroundView(
    //     primaryColor: Theme.of(context).colorScheme.primary,
    //     secondaryColor: Theme.of(context).colorScheme.secondary,
    //     tertiaryColor: Theme.of(context).colorScheme.tertiary,
    //   );
    // }

    // 背景类型
    final backgroundTypeIndex = state.backgroundTypeIndex;
    Widget backgroundWidget;
    if (backgroundTypeIndex == 1) {
      backgroundWidget = MaterialBackgroundView(
        primaryColor: Theme.of(context).colorScheme.primary,
        secondaryColor: Theme.of(context).colorScheme.tertiary,
      );
    } else {
      backgroundWidget = ApeVoloBackgroundView(
        primaryColor: Theme.of(context).colorScheme.primary,
        secondaryColor: Theme.of(context).colorScheme.secondary,
        tertiaryColor: Theme.of(context).colorScheme.tertiary,
      );
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const ThemeToggleIconButton(),
          const ThemeSwitchButton(),
          if (state.showBackgroundSelector)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: DropdownButton<int>(
                value: state.backgroundTypeIndex,
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    notifier.setBackgroundType(newValue);
                  }
                },
                items: const [
                  DropdownMenuItem(value: 0, child: Text('apevolo')),
                  DropdownMenuItem(value: 1, child: Text('material')),
                ],
              ),
            ),
          // 主题切换按钮（如有ThemeModeView可加）
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: backgroundWidget,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: 450,
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(minWidth: 300.0, maxWidth: 600),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Card(
                    elevation: 4.0,
                    shadowColor: Theme.of(context).cardColor,
                    surfaceTintColor:
                        Theme.of(context).cardTheme.surfaceTintColor,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(26.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Hero(
                                  tag: 'logo',
                                  child: Image.asset(
                                    'assets/image/logo.png',
                                    width: 64,
                                    height: 64,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'ApeVolo',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '后台管理系统',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          Column(
                            children: [
                              Focus(
                                onKeyEvent: (FocusNode node, KeyEvent event) {
                                  if (event is KeyDownEvent) {
                                    if (event.logicalKey ==
                                        LogicalKeyboardKey.tab) {
                                      notifier
                                          .clearSuggestionWithoutAccepting();
                                      FocusScope.of(context).nextFocus();
                                      return KeyEventResult.handled;
                                    } else if (event.logicalKey ==
                                        LogicalKeyboardKey.enter) {
                                      if (state.currentSuggestion.isNotEmpty) {
                                        notifier.acceptSuggestion();
                                      }
                                      // 不再调用nextFocus，保持焦点
                                      return KeyEventResult.handled;
                                    }
                                  }
                                  return KeyEventResult.ignored;
                                },
                                child: Stack(
                                  children: [
                                    TextFormField(
                                      controller: usernameController,
                                      focusNode: focusNode,
                                      decoration: const InputDecoration(
                                        labelText: '用户名',
                                        prefixIcon: Icon(Icons.person),
                                        hintText: '输入用户名',
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      autofillHints: const [
                                        AutofillHints.username,
                                        AutofillHints.email,
                                      ],
                                      autocorrect: false,
                                      enableSuggestions: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '请输入用户名！ ';
                                        }
                                        return null;
                                      },
                                      onChanged: (v) =>
                                          notifier.updateUsername(v),
                                    ),
                                    if (state.currentSuggestion.isNotEmpty)
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        top: 48,
                                        child: Material(
                                          elevation: 2,
                                          child: ListTile(
                                            title:
                                                Text(state.currentSuggestion),
                                            onTap: () =>
                                                notifier.acceptSuggestion(),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  labelText: '密码',
                                  prefixIcon: const Icon(Icons.password),
                                  hintText: '输入密码',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      state.isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed:
                                        notifier.togglePasswordVisibility,
                                  ),
                                ),
                                obscureText: !state.isPasswordVisible,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.password],
                                autocorrect: false,
                                enableSuggestions: false,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '请输入密码! ';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  if (formKey.currentState!.validate()) {
                                    notifier.login();
                                  }
                                },
                                onChanged: notifier.updatePassword,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // 验证码区域（只负责输入框，图片/加载/错误交给 CaptchaView）
                          Consumer(
                            builder: (context, ref, _) {
                              final captchaVisible =
                                  ref.watch(captchaNotifierProvider).maybeWhen(
                                        orElse: () => true,
                                        data: (data) => data.isShowing,
                                      );
                              if (!captchaVisible) {
                                return const SizedBox.shrink();
                              }
                              return Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: captchaController,
                                      decoration: const InputDecoration(
                                        labelText: '验证码',
                                        prefixIcon: Icon(Icons.numbers),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '请输入验证码!';
                                        }
                                        return null;
                                      },
                                      onChanged: notifier.updateCaptchaText,
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Row(
                                    children: [
                                      const CaptchaView(),
                                      const SizedBox(width: 8.0),
                                      IconButton(
                                        onPressed: () => ref
                                            .read(captchaNotifierProvider
                                                .notifier)
                                            .refresh(),
                                        tooltip: '刷新验证码',
                                        icon: const Icon(Icons.refresh),
                                      )
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 16.0),
                          if (state.error != null && state.error!.isNotEmpty)
                            Column(
                              children: [
                                Text(
                                  state.error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                          OutlinedButton.icon(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                notifier.login();
                              }
                            },
                            icon: const Icon(Icons.login),
                            label: const Text("登录"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 你需要在app2中实现MaterialBackgroundView和ApeVoloBackgroundView组件，
// 并确保assets/image/logo.png存在。
