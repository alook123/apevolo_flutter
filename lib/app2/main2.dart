import 'package:apevolo_flutter/app2/storage/hive_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'view/login_view.dart';

Future<void> main() async {
  // 初始化Hive存储服务
  final storageService = HiveStorageService();
  await storageService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginView(),
      supportedLocales: const [
        Locale('zh', 'CN'), // 添加中文支持
      ],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
