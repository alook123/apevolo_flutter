import 'package:apevolo_flutter/app/constants/about_constants.dart';
import 'package:apevolo_flutter/features/setting/provides/setting_provide.dart';
import 'package:apevolo_flutter/features/setting/views/language_setting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingView extends ConsumerWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingState = ref.watch(settingProvider);
    final settingNotifier = ref.read(settingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          const Text(
            'APEVOLO',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('语言'),
            subtitle: Text(settingState.language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LanguageSettingView(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('主题'),
            subtitle: Text(settingState.themeModeText),
            onTap: () async {
              await settingNotifier.changeTheme();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('关于应用'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: AboutConstants.appName,
                applicationVersion: AboutConstants.appVersion,
                applicationIcon: const FlutterLogo(size: 64),
                applicationLegalese: AboutConstants.appLegalese,
                children: AboutConstants.appDescription
                    .map((desc) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(desc),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
