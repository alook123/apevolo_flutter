---
applyTo: '**/lib/app/data/repositories/**/*.dart'
---

# 数据仓库层规范

## 仓库类结构

所有仓库类应遵循以下结构：

```dart
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:apevolo_flutter/app/data/models/{{entity_name_lowercase}}.dart';

/// {{EntityName}}仓库，负责{{EntityName}}数据的获取和处理
class {{EntityName}}Repository {
  /// 创建一个{{EntityName}}仓库实例
  const {{EntityName}}Repository({
    required this.apiClient,
    required this.localStorageClient,
  });

  /// API客户端
  final ApiClient apiClient;
  
  /// 本地存储客户端
  final LocalStorageClient localStorageClient;

  /// 获取{{EntityName}}列表
  Future<List<{{EntityName}}>> get{{EntityName}}List() async {
    // 实现获取数据逻辑
  }

  /// 获取{{EntityName}}详情
  Future<{{EntityName}}> get{{EntityName}}(String id) async {
    // 实现获取数据逻辑
  }

  /// 创建{{EntityName}}
  Future<{{EntityName}}> create{{EntityName}}({{EntityName}} {{entity_name_lowercase}}) async {
    // 实现创建数据逻辑
  }

  /// 更新{{EntityName}}
  Future<{{EntityName}}> update{{EntityName}}({{EntityName}} {{entity_name_lowercase}}) async {
    // 实现更新数据逻辑
  }

  /// 删除{{EntityName}}
  Future<void> delete{{EntityName}}(String id) async {
    // 实现删除数据逻辑
  }
}
```

## 最佳实践

1. **依赖注入**：通过构造函数注入依赖，便于测试和解耦
2. **关注点分离**：仓库只负责数据获取和处理，不包含业务逻辑
3. **统一错误处理**：使用统一的错误处理机制，如自定义Exception类
4. **缓存策略**：对频繁访问的数据实现适当的缓存策略
5. **日志记录**：为关键操作添加日志记录
6. **重试机制**：为不稳定的网络请求添加重试机制
7. **分页处理**：对大量数据实现分页加载

## 错误处理

仓库应当捕获并转换所有异常，确保上层组件能够接收到统一的错误类型：

```dart
try {
  // 尝试获取数据
  final response = await apiClient.get('/endpoint');
  return {{EntityName}}.fromJson(response);
} on ApiException catch (e) {
  // API异常处理
  throw {{EntityName}}RepositoryException('获取数据失败', cause: e);
} on CacheException catch (e) {
  // 缓存异常处理
  throw {{EntityName}}RepositoryException('读取缓存失败', cause: e);
} catch (e) {
  // 其他异常处理
  throw {{EntityName}}RepositoryException('未知错误', cause: e);
}
```

## 单元测试

每个仓库类都应该有相应的单元测试，测试所有公开方法：

```dart
void main() {
  group('{{EntityName}}Repository', () {
    late {{EntityName}}Repository repository;
    late MockApiClient mockApiClient;
    late MockLocalStorageClient mockLocalStorageClient;

    setUp(() {
      mockApiClient = MockApiClient();
      mockLocalStorageClient = MockLocalStorageClient();
      repository = {{EntityName}}Repository(
        apiClient: mockApiClient,
        localStorageClient: mockLocalStorageClient,
      );
    });

    test('get{{EntityName}}List returns list of {{EntityName}}s', () async {
      // 设置模拟行为
      // 执行测试
      // 验证结果
    });

    // 更多测试...
  });
}
```
