import 'package:apevolo_flutter/app/modules/widget/captcha/views/captcha_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  TextFormField(
                    controller: controller.usernameTextController,
                    decoration: const InputDecoration(
                      labelText: '用户名',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入用户名！ ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: controller.passwordTextController,
                    decoration: const InputDecoration(
                      labelText: '密码',
                      prefixIcon: Icon(Icons.password),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入密码! ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
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
                          IconButton.filled(
                            onPressed: () {
                              controller.onRefresh();
                            },
                            color: Theme.of(context).primaryColor,
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    ],
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
                        controller.onLogin();
                      }
                    },
                    icon: const Icon(
                      Icons.login,
                    ),
                    label: const Text(
                      "login",
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
