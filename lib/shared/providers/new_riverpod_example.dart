/// 新版 Riverpod 2.0+ 写法示例
///
/// 这个文件展示了新版 Riverpod 的各种用法
library new_riverpod_example;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 必须添加这行用于代码生成
part 'new_riverpod_example.g.dart';

// ============================================================================
// 1. 简单的 Provider（替代旧版的 Provider）
// ============================================================================

/// 旧版写法：
/// final configProvider = Provider<String>((ref) => 'Hello World');
///
/// 新版写法：
@riverpod
String config(Ref ref) {
  return 'Hello World';
}

// ============================================================================
// 2. FutureProvider 的新写法
// ============================================================================

/// 旧版写法：
/// final userProvider = FutureProvider<User>((ref) async {
///   final api = ref.read(apiProvider);
///   return await api.fetchUser();
/// });
///
/// 新版写法：
@riverpod
Future<String> userData(Ref ref) async {
  // 模拟异步数据获取
  await Future.delayed(const Duration(seconds: 1));
  return 'User Data';
}

// ============================================================================
// 3. StateNotifierProvider 的新写法（类似你的 CaptchaNotifier）
// ============================================================================

/// 状态类
class CounterState {
  final int count;
  final bool isLoading;

  const CounterState({
    this.count = 0,
    this.isLoading = false,
  });

  CounterState copyWith({
    int? count,
    bool? isLoading,
  }) {
    return CounterState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 旧版写法：
/// class CounterNotifier extends StateNotifier<CounterState> {
///   CounterNotifier() : super(const CounterState());
///
///   void increment() {
///     state = state.copyWith(count: state.count + 1);
///   }
/// }
///
/// final counterProvider = StateNotifierProvider<CounterNotifier, CounterState>((ref) {
///   return CounterNotifier();
/// });
///
/// 新版写法：
@riverpod
class Counter extends _$Counter {
  @override
  CounterState build() {
    return const CounterState();
  }

  void increment() {
    state = state.copyWith(count: state.count + 1);
  }

  void reset() {
    state = const CounterState();
  }
}

// ============================================================================
// 4. AsyncNotifierProvider 的新写法（异步状态管理，你的验证码就是这种）
// ============================================================================

class UserState {
  final String name;
  final String email;

  const UserState({
    required this.name,
    required this.email,
  });

  UserState copyWith({
    String? name,
    String? email,
  }) {
    return UserState(
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

/// 新版异步状态管理器
@riverpod
class User extends _$User {
  @override
  Future<UserState> build() async {
    // 初始化时自动加载数据
    return await _fetchUser();
  }

  Future<UserState> _fetchUser() async {
    // 模拟 API 调用
    await Future.delayed(const Duration(seconds: 2));
    return const UserState(
      name: 'John Doe',
      email: 'john@example.com',
    );
  }

  /// 刷新用户数据
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchUser());
  }

  /// 更新用户名
  void updateName(String newName) {
    final currentState = state.valueOrNull;
    if (currentState != null) {
      state = AsyncValue.data(currentState.copyWith(name: newName));
    }
  }
}

// ============================================================================
// 5. 带参数的 Provider
// ============================================================================

/// 旧版写法：
/// final userByIdProvider = Provider.family<Future<User>, String>((ref, id) async {
///   final api = ref.read(apiProvider);
///   return await api.fetchUser(id);
/// });
///
/// 新版写法：
@riverpod
Future<String> userById(Ref ref, String id) async {
  // 模拟根据 ID 获取用户
  await Future.delayed(const Duration(milliseconds: 500));
  return 'User with ID: $id';
}

// ============================================================================
// 6. 依赖其他 Provider
// ============================================================================

@riverpod
Future<String> userProfile(Ref ref) async {
  // 依赖其他 provider
  final config = ref.watch(configProvider);
  final userData = await ref.watch(userDataProvider.future);

  return '$config - $userData';
}

// ============================================================================
// 如何在 Widget 中使用
// ============================================================================

/*
class ExampleWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 简单的 Provider
    final config = ref.watch(configProvider);
    
    // 2. Future Provider
    final userDataAsync = ref.watch(userDataProvider);
    
    // 3. State Notifier
    final counterState = ref.watch(counterProvider);
    final counterNotifier = ref.watch(counterProvider.notifier);
    
    // 4. Async Notifier
    final userAsync = ref.watch(userProvider);
    final userNotifier = ref.watch(userProvider.notifier);
    
    // 5. 带参数的 Provider
    final userById = ref.watch(userByIdProvider('123'));
    
    return Column(
      children: [
        Text('Config: $config'),
        
        // 处理 AsyncValue
        userDataAsync.when(
          data: (data) => Text('User Data: $data'),
          loading: () => CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
        
        // State Notifier
        Text('Counter: ${counterState.count}'),
        ElevatedButton(
          onPressed: counterNotifier.increment,
          child: Text('Increment'),
        ),
        
        // Async Notifier
        userAsync.when(
          data: (user) => Text('User: ${user.name}'),
          loading: () => CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
        
        ElevatedButton(
          onPressed: userNotifier.refresh,
          child: Text('Refresh User'),
        ),
      ],
    );
  }
}
*/
