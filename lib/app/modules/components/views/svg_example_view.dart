import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgExampleView extends GetView {
  const SvgExampleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SvgPicture.asset Example')),
      body: Center(
        child: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 2), () {
            // 模拟网络请求
            return true;
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // 如果加载失败，显示默认的 SVG
                return SvgPicture.asset('assets/images/default.svg');
              }
              return SvgPicture.asset('assets/images/non_existent.svg');
            }
            return const CircularProgressIndicator(); // 显示加载中指示器
          },
        ),
      ),
    );
  }
}
