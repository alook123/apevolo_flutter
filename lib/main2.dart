import 'package:apevolo_flutter/shared/providers/theme_provider.dart';
import 'package:apevolo_flutter/shared/storage/hive_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared/view/login_view.dart';

Future<void> main() async {
  // 初始化Hive存储服务
  final storageService = HiveStorageService();
  await storageService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Riverpod Demo',
      themeMode: themeMode,
      theme: ThemeData.light(), // 明亮主题
      darkTheme: ThemeData.dark(),
      home: const LoginView(),
      supportedLocales: const [
        Locale('zh', 'CN'), // 添加中文支持
      ],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
