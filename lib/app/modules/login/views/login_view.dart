import 'package:apevolo_flutter/app/components/apevolo_background/controllers/apevolo_background_controller.dart';
import 'package:apevolo_flutter/app/components/captcha/views/captcha_view.dart';
import 'package:apevolo_flutter/app/components/material_background/views/material_background_view.dart';
import 'package:apevolo_flutter/app/components/theme_mode/views/theme_mode_view.dart';
import 'package:apevolo_flutter/app/components/apevolo_background/views/apevolo_background_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // 监听用户名输入框的焦点变化
    controller.usernameFocusNode.addListener(() {
      // 只有当焦点失去时，且不是通过 Tab 或 Enter 键转移的（这些在 onKeyEvent 中处理）
      if (!controller.usernameFocusNode.hasFocus) {
        // 清除建议而不接受它
        controller.clearSuggestionWithoutAccepting();
      }
    });

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 在调试模式下显示背景选择器
          if (kDebugMode)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildBackgroundSelector(context),
            ),
          // 主题切换按钮
          const ThemeModeView(),
        ],
      ),
      body: Stack(
        children: [
          // 添加背景（基于选择）
          Positioned.fill(
            child: Obx(() {
              switch (controller.backgroundType.value) {
                case BackgroundType.apevolo:
                  return ApeVoloBackgroundView(
                    primaryColor: Theme.of(context).colorScheme.primary,
                    secondaryColor: Theme.of(context).colorScheme.secondary,
                    tertiaryColor: Theme.of(context).colorScheme.tertiary,
                  );
                case BackgroundType.material:
                  return MaterialBackgroundView(
                    primaryColor: Theme.of(context).colorScheme.primary,
                    secondaryColor: Theme.of(context).colorScheme.tertiary,
                  );
                default:
                  return ApeVoloBackgroundView(
                    primaryColor: Theme.of(context).colorScheme.primary,
                    secondaryColor: Theme.of(context).colorScheme.secondary,
                    tertiaryColor: Theme.of(context).colorScheme.tertiary,
                  );
              }
            }),
          ),
          // 登录表单内容
          Center(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: 450,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 300.0,
                  maxWidth: 600,
                ),
                child: Form(
                  key: _formKey,
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
                          // 标题部分
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
                              KeyboardActions(
                                actions: [
                                  KeyboardActionsItem(
                                    focusNode: FocusNode(),
                                    onTapAction: () {},
                                    toolbarButtons: [
                                      (node) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: const SizedBox.shrink(),
                                        );
                                      }
                                    ],
                                  ),
                                ],
                                child: Focus(
                                  onKeyEvent: (FocusNode node, KeyEvent event) {
                                    if (event is KeyDownEvent) {
                                      if (event.logicalKey ==
                                          LogicalKeyboardKey.tab) {
                                        // Tab键：清除建议而不接受它，然后移动到密码框
                                        controller
                                            .clearSuggestionWithoutAccepting();
                                        FocusScope.of(context).nextFocus();
                                        return KeyEventResult.handled;
                                      } else if (event.logicalKey ==
                                          LogicalKeyboardKey.enter) {
                                        // Enter键：接受建议后移动到密码框
                                        if (controller.currentSuggestion.value
                                            .isNotEmpty) {
                                          controller.acceptSuggestion();
                                        }
                                        FocusScope.of(context).nextFocus();
                                        return KeyEventResult.handled;
                                      }
                                    }
                                    return KeyEventResult.ignored;
                                  },
                                  child: TextFormField(
                                    controller:
                                        controller.usernameTextController,
                                    focusNode: controller.usernameFocusNode,
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
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Obx(
                                () => TextFormField(
                                  controller: controller.passwordTextController,
                                  decoration: InputDecoration(
                                    labelText: '密码',
                                    prefixIcon: const Icon(Icons.password),
                                    hintText: '输入密码',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.isPasswordVisible.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        controller.togglePasswordVisibility();
                                      },
                                    ),
                                  ),
                                  obscureText:
                                      !controller.isPasswordVisible.value,
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
                                    if (_formKey.currentState!.validate()) {
                                      controller.onLogin();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => Visibility(
                              visible:
                                  controller.captchaController.isShowing.value,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          controller.captchaTextController,
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
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Row(
                                    children: [
                                      const CaptchaView(),
                                      const SizedBox(width: 16.0),
                                      IconButton(
                                        onPressed: () {
                                          controller.onRefresh();
                                        },
                                        // icon: const Icon(Icons.refresh),
                                        icon: const Icon(Icons.refresh),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Obx(
                            () => Column(
                              children: [
                                Visibility(
                                  visible: controller
                                          .loginFailedText.value?.isNotEmpty !=
                                      false,
                                  child: Text(
                                    controller.loginFailedText.value ?? '',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                controller.onLogin();
                              }
                            },
                            // style: FilledButton.styleFrom(
                            //   minimumSize: const Size.fromHeight(30),
                            // ),
                            icon: const Icon(
                              Icons.login,
                            ),
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

  Widget _buildBackgroundSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Obx(
          () => DropdownButton<BackgroundType>(
            value: controller.backgroundType.value,
            onChanged: (BackgroundType? newValue) {
              if (newValue != null) {
                controller.setBackgroundType(newValue);
              }
            },
            items: BackgroundType.values.map((BackgroundType type) {
              return DropdownMenuItem<BackgroundType>(
                value: type,
                child: Text(type.toString().split('.').last),
              );
            }).toList(),
          ),
        ),
        // 仅当选择了ApeVolo背景时显示速度控制
        if (controller.backgroundType.value == BackgroundType.apevolo)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildSpeedController(context),
          ),
      ],
    );
  }

  // 添加背景动画速度控制器
  Widget _buildSpeedController(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('动画速度控制', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.speed_outlined),
                  tooltip: '加速(2倍)',
                  onPressed: () {
                    // 获取控制器并加速动画
                    final bgController =
                        Get.find<ApeVoloBackgroundController>();
                    bgController.speedUpAnimation(2.0);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.replay),
                  tooltip: '重置到默认速度',
                  onPressed: () {
                    // 获取控制器并重置动画
                    final bgController =
                        Get.find<ApeVoloBackgroundController>();
                    bgController.resetAnimationToDefault();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.slow_motion_video),
                  tooltip: '减速(2倍)',
                  onPressed: () {
                    // 获取控制器并减速动画
                    final bgController =
                        Get.find<ApeVoloBackgroundController>();
                    bgController.slowDownAnimation(2.0);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class KeyboardActions extends StatelessWidget {
  final List<KeyboardActionsItem> actions;
  final Widget child;

  const KeyboardActions({
    Key? key,
    required this.actions,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class KeyboardActionsItem {
  final FocusNode focusNode;
  final VoidCallback onTapAction;
  final List<ToolbarButtonBuilder> toolbarButtons;

  KeyboardActionsItem({
    required this.focusNode,
    required this.onTapAction,
    required this.toolbarButtons,
  });
}

typedef ToolbarButtonBuilder = Widget Function(FocusNode focusNode);
