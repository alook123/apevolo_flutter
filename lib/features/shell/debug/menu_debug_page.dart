import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/shell_provider.dart';

/// 菜单调试页面，用于测试菜单Provider是否正常工作
class MenuDebugPage extends ConsumerWidget {
  const MenuDebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsyncValue = ref.watch(shellMenuProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('菜单调试页面'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(shellMenuProvider.notifier).refresh();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: menuAsyncValue.when(
        data: (menuState) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '菜单数量: ${menuState.menus.length}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: menuState.menus.length,
                  itemBuilder: (context, index) {
                    final menu = menuState.menus[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(menu.meta?.title ?? menu.name ?? '无标题'),
                        subtitle: Text('子菜单数量: ${menu.children?.length ?? 0}'),
                        leading: const Icon(Icons.menu),
                        trailing: Text(menu.expanded == true ? '展开' : '收起'),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('正在加载菜单...'),
            ],
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                '菜单加载失败',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(shellMenuProvider.notifier).refresh();
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
