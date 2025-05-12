---
applyTo: '**/models/**/*.dart'
---

# Freezed Model Templates

## 什么是 Freezed？

Freezed 是一个 Dart 代码生成库，帮助我们轻松创建不可变（immutable）对象。它提供了以下主要功能：

- 自动生成不可变对象和构造函数
- 支持 `copyWith` 方法进行对象拷贝和修改
- 实现 `==` 操作符和 `hashCode` 进行对象比较
- 与 JSON 序列化无缝集成
- 支持联合类型（union types）和模式匹配

## Basic Freezed Model

用于创建基本的 freezed 模型类。包含标准序列化、反序列化支持。

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part '{{filename}}.freezed.dart';
part '{{filename}}.g.dart';

@freezed
abstract class {{className}} with _${{className}} {
  const factory {{className}}({
    required String id,
    required String name,
    String? description,
    @Default(false) bool isActive,
  }) = _{{className}};

  factory {{className}}.fromJson(Map<String, dynamic> json) => 
      _${{className}}FromJson(json);
}
```

## 带自定义JSON键名的Model

用于自定义JSON键名与Dart属性名不一致的情况。

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part '{{filename}}.freezed.dart';
part '{{filename}}.g.dart';

@freezed
abstract class {{className}} with _${{className}} {
  const factory {{className}}({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'is_active') @Default(false) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _{{className}};

  factory {{className}}.fromJson(Map<String, dynamic> json) => 
      _${{className}}FromJson(json);
}
```

## 带嵌套对象的Model

当模型包含其他模型对象作为属性时使用。项目实例如 `AuthUser` 嵌套 `UserDetail`。

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'address.dart'; // 导入嵌套的模型

part '{{filename}}.freezed.dart';
part '{{filename}}.g.dart';

@freezed
abstract class {{className}} with _${{className}} {
  const factory {{className}}({
    required String id,
    required String name,
    required Address address,
    @Default([]) List<Address> additionalAddresses,
  }) = _{{className}};

  factory {{className}}.fromJson(Map<String, dynamic> json) => 
      _${{className}}FromJson(json);
}
```

## 带自定义方法的Model

当需要在freezed类中添加自定义方法时使用。

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part '{{filename}}.freezed.dart';
part '{{filename}}.g.dart';

@freezed
abstract class {{className}} with _${{className}} {
  // 添加私有构造函数以支持自定义方法
  const {{className}}._(); 

  const factory {{className}}({
    required String id,
    required double price,
    @Default(0) int quantity,
  }) = _{{className}};

  // 自定义方法
  double get totalPrice => price * quantity;
  
  bool isExpensive() => price > 1000;

  factory {{className}}.fromJson(Map<String, dynamic> json) => 
      _${{className}}FromJson(json);
}
```

## 项目实例：AuthUser 模型

以下是项目中 AuthUser 模型的实现示例，展示了多层嵌套对象的处理方式：

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required UserDetail user,
    required List<String> roles,
    required List<String> dataScopes,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) => 
      _$AuthUserFromJson(json);
}

@freezed
abstract class UserDetail with _$UserDetail {
  const factory UserDetail({
    required String username,
    required String nickName,
    required String email,
    required bool isAdmin,
    required bool enabled,
    required String password,
    required int deptId,
    required String phone,
    required String avatarPath,
    required String gender,
    String? passwordReSetTime,
    required List<Role> roles,
    required Dept dept,
    required List<Job> jobs,
    required int tenantId,
    String? tenant,
    required int id,
    required String createBy,
    required String createTime,
    String? updateBy,
    String? updateTime,
  }) = _UserDetail;

  factory UserDetail.fromJson(Map<String, dynamic> json) => 
      _$UserDetailFromJson(json);
}

@freezed
abstract class Role with _$Role {
  const factory Role({
    required int id,
    required String name,
    required String permission,
    required int level,
    required int dataScopeType,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}
```

## Union Types (密封类/联合类型)

用于表示可以是多种不同类型的数据，类似枚举但更强大。

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part '{{filename}}.freezed.dart';
part '{{filename}}.g.dart';

@freezed
abstract class {{className}} with _${{className}} {
  // 定义不同的状态/类型
  const factory {{className}}.initial() = _Initial;
  const factory {{className}}.loading() = _Loading;
  const factory {{className}}.success(dynamic data) = _Success;
  const factory {{className}}.error(String message) = _Error;

  factory {{className}}.fromJson(Map<String, dynamic> json) => 
      _${{className}}FromJson(json);
}
```

## 使用 copyWith 方法

Freezed 自动生成的 `copyWith` 方法非常有用，可以创建对象的新实例同时只修改需要的属性：

```dart
// 原始对象
final user = UserDetail(
  username: 'john_doe',
  email: 'john@example.com',
  // ... 其他必要属性
);

// 创建新实例，只修改 email 属性
final updatedUser = user.copyWith(email: 'john.doe@company.com');
```

对于嵌套对象，可以使用级联 copyWith 方法：

```dart
final authUser = AuthUser(
  user: userDetail,
  roles: ['admin'],
  dataScopes: ['ALL'],
);

// 修改嵌套对象中的属性
final updatedAuthUser = authUser.copyWith(
  user: authUser.user.copyWith(
    email: 'new.email@example.com'
  )
);
```

## 使用说明

### 代码生成命令

1. 创建模型文件后，需要运行代码生成命令：

   ```bash
   # 旧命令，仍然可用
   flutter pub run build_runner build --delete-conflicting-outputs
   
   # 推荐的新命令 (Flutter 3.3.0+)
   dart run build_runner build --delete-conflicting-outputs
   ```

2. 修改模型后重新生成代码：

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. 在开发过程中使用观察模式自动生成：

   ```bash
   dart run build_runner watch --delete-conflicting-outputs
   ```

### 配置 build.yaml

对于 Freezed 相关配置，可以在项目根目录下创建或修改 `build.yaml` 文件：

```yaml
targets:
  $default:
    builders:
      freezed:
        generate_for:
          include:
            - lib/app/data/models/**/*.dart
      json_serializable:
        options:
          explicit_to_json: true
          create_factory: true
        generate_for:
          include:
            - lib/app/data/models/**/*.dart
```

这个配置确保：

- 只为指定目录下的文件生成代码
- JSON 序列化时启用 `explicit_to_json` 选项，确保嵌套对象正确序列化

## Freezed最佳实践

1. **使用 abstract class**: 所有 Freezed 类应声明为 `abstract class` 并添加 `with _$ClassName`
2. **使用 const 构造函数**: 所有 Freezed 模型都应使用 const 构造函数提高性能
3. **使用 @Default 注解**: 为可选参数提供默认值，避免 null 检查
4. **添加自定义方法**: 对于需要计算属性或业务逻辑，添加私有构造函数并在类中定义方法
5. **使用 union types**: 对于有多种状态的数据（如网络请求结果、状态管理），使用联合类型
6. **命名规范**: 主类名应为名词，union types 的工厂构造函数应为动词或状态名
7. **JSON 序列化**: 对于嵌套对象，确保在 `build.yaml` 中设置 `explicit_to_json: true`

## 从普通类转换为 Freezed 类的步骤

将现有的普通类转换为 Freezed 类的步骤：

1. 引入必要的包：

   ```dart
   import 'package:freezed_annotation/freezed_annotation.dart';
   import 'package:json_annotation/json_annotation.dart';
   
   part '{{filename}}.freezed.dart';
   part '{{filename}}.g.dart';
   ```

2. 添加 `@freezed` 注解并修改类声明：

   ```dart
   @freezed
   abstract class MyClass with _$MyClass {
     // ...
   }
   ```

3. 将字段转换为工厂构造函数参数：

   ```dart
   // 原代码
   class MyClass {
     final String name;
     final int age;
     
     MyClass({required this.name, required this.age});
   }
   
   // 转换后
   @freezed
   abstract class MyClass with _$MyClass {
     const factory MyClass({
       required String name,
       required int age,
     }) = _MyClass;
   }
   ```

4. 添加 JSON 序列化支持：

   ```dart
   factory MyClass.fromJson(Map<String, dynamic> json) => 
       _$MyClassFromJson(json);
   ```

5. 运行代码生成命令：

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

## 常见错误处理

1. **缺少生成文件**: 确保运行了 build_runner 命令并检查 `part` 语句路径是否正确
2. **命名冲突**: 确保没有方法名与属性名相同
3. **JSON 序列化错误**: 对于复杂类型，确保提供了正确的 fromJson/toJson 转换
4. **嵌套对象序列化错误**: 确保在 `build.yaml` 中设置了 `explicit_to_json: true`
5. **"Missing concrete implementations"**: 确保添加了 `abstract` 关键字到类声明中
6. **"Classes can only mix in mixins and classes"**: 检查 `part` 语句是否正确，确保生成的 `.freezed.dart` 文件存在

## 与 retrofit 集成

如果项目使用 retrofit 进行网络请求，可能会遇到与 Freezed 模型集成的问题。确保：

1. 所有用于请求/响应的模型类都实现了 `fromJson` 和 `toJson` 方法
2. retrofit_generator 与 json_serializable 版本兼容
3. 处理 retrofit 错误时，使用具体的错误信息进行调试

## 高级功能

### 泛型支持

Freezed 支持泛型类型，例如：

```dart
@freezed
abstract class Result<T> with _$Result<T> {
  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(String message) = Failure<T>;
  
  factory Result.fromJson(Map<String, dynamic> json) => 
      _$ResultFromJson(json);
}
```

### when 方法使用

对于联合类型，可以使用自动生成的 `when` 方法进行模式匹配：

```dart
final result = Result.success('数据');

// 处理所有可能的状态
final message = result.when(
  success: (value) => '成功: $value',
  failure: (message) => '失败: $message',
);

// 或者使用 maybeWhen 只处理部分状态
final messageAlt = result.maybeWhen(
  success: (value) => '成功: $value',
  orElse: () => '其他状态',
);
```

## 参考资源

- [Freezed 官方文档](https://pub.dev/packages/freezed)
- [JSON Serializable 文档](https://pub.dev/packages/json_serializable)
- [Flutter Riverpod 与 Freezed 集成示例](https://riverpod.dev/docs/cookbooks/testing)
