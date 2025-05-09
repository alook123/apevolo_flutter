# 生成单元测试

使用此Prompt来为现有类生成单元测试。

## 参数

- `className`: 要测试的类名，如"UserRepository"、"AuthController"等
- `filePath`: 类文件的路径
- `testType`: 测试类型，可选: ["unit", "widget", "integration"]
- `mockDependencies`: 需要模拟的依赖项列表
- `testCases`: 需要测试的用例描述列表

## 生成的文件

此模板将生成以下文件:

1. 测试文件: `test/{{test_type}}/{{class_name_lowercase}}_test.dart`
2. 如果需要，还会生成模拟文件: `test/mocks/mock_{{dependency_name_lowercase}}.dart`

## 示例使用

```
类名: UserRepository
文件路径: lib/app/data/repositories/user_repository.dart
测试类型: unit
需要模拟的依赖: ApiClient, LocalStorage
测试用例:
- getUserList应该返回用户列表
- getUserById应该返回单个用户
- getUserById在用户不存在时应该抛出异常
- createUser应该返回新创建的用户
- updateUser应该返回更新后的用户
- deleteUser应该返回true
```

## 测试结构

```dart
void main() {
  group('{{ClassName}} Tests', () {
    late {{ClassName}} {{classNameLowerCase}};
    late Mock{{Dependency1}} mock{{Dependency1}};
    late Mock{{Dependency2}} mock{{Dependency2}};

    setUp(() {
      mock{{Dependency1}} = Mock{{Dependency1}}();
      mock{{Dependency2}} = Mock{{Dependency2}}();
      {{classNameLowerCase}} = {{ClassName}}(
        {{dependency1}}: mock{{Dependency1}},
        {{dependency2}}: mock{{Dependency2}},
      );
    });

    test('{{testCase1}}', () async {
      // Arrange
      // ...

      // Act
      // ...

      // Assert
      // ...
    });
    
    // More tests...
  });
}
```

----

现在请提供以上参数，我将为您生成完整的测试代码。
