import 'package:apevolo_flutter/app/components/captcha/views/captcha_view.dart';
import 'package:apevolo_flutter/app/components/theme_mode/views/theme_mode_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
      floatingActionButton: const ThemeModeView(),
      body: Center(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/image/logo.png', width: 30),
                      const Text(
                        'ApeVolo 后台管理系统',
                        style: TextStyle(
                          fontSize: 26,
                        ),
                      ),
                    ],
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
                              if (event.logicalKey == LogicalKeyboardKey.tab) {
                                // Tab键：清除建议而不接受它，然后移动到密码框
                                controller.clearSuggestionWithoutAccepting();
                                FocusScope.of(context).nextFocus();
                                return KeyEventResult.handled;
                              } else if (event.logicalKey ==
                                  LogicalKeyboardKey.enter) {
                                // Enter键：接受建议后移动到密码框
                                if (controller
                                    .currentSuggestion.value.isNotEmpty) {
                                  controller.acceptSuggestion();
                                }
                                FocusScope.of(context).nextFocus();
                                return KeyEventResult.handled;
                              }
                            }
                            return KeyEventResult.ignored;
                          },
                          child: TextFormField(
                            controller: controller.usernameTextController,
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
                          obscureText: !controller.isPasswordVisible.value,
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
                      visible: controller.captchaController.isShowing.value,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.captchaTextController,
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
                              IconButton.outlined(
                                onPressed: () {
                                  controller.onRefresh();
                                },
                                icon: const Icon(Icons.refresh),
                              ),
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
                          visible:
                              controller.loginFailedText.value?.isNotEmpty !=
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
                    icon: const Icon(
                      Icons.login,
                    ),
                    label: const Text(
                      "登录",
                    ),
                  ),
                ],
              ),
            ),
          ),
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
