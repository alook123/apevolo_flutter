import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apevolo_flutter/features/setting/provides/setting_provide.dart';

class LanguageSettingView extends ConsumerWidget {
  const LanguageSettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingState = ref.watch(settingProvider);
    final settingNotifier = ref.read(settingProvider.notifier);

    final languages = [
      {'code': 'zh', 'name': '中文'},
      {'code': 'en', 'name': 'English'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('语言设置'),
        centerTitle: true,
      ),
      body: ListView(
        children: languages.map((language) {
          final isSelected = settingState.language == language['name'];
          return ListTile(
            title: Text(language['name']!),
            trailing: isSelected
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              settingNotifier.changeLanguage(language['name']!);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('已切换到${language['name']}')),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
