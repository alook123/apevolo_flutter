import 'package:apevolo_flutter/core/router/app_router.dart';
import 'package:apevolo_flutter/shared/providers/theme_provider.dart';
import 'package:apevolo_flutter/shared/storage/hive_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  // 初始化Hive存储服务
  final storageService = HiveStorageService();
  await storageService.init();

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Apevolo Flutter',
      themeMode: themeMode,
      theme: ThemeData.light(), // 明亮主题
      darkTheme: ThemeData.dark(),
      routerConfig: router,
      supportedLocales: const [
        Locale('zh', 'CN'), // 添加中文支持
        Locale('zh', 'TW'), // 添加繁体中文支持
        Locale('en', 'US'), // 添加英文支持
      ],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
