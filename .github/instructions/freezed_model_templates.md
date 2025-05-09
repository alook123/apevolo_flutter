---
applyTo: '**/models/**/*.dart'
---

# Freezed Model Templates

## Basic Freezed Model

用于创建基本的freezed模型类。包含标准序列化、反序列化支持。

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

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

当模型包含其他模型对象作为属性时使用。

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'address.dart'; // 导入嵌套的模型

part '{{filename}}.freezed.dart';
part '{{filename}}.g.dart';

@freezed
abstract class {{className}} with _${{className}} {
  const factory {{className}}({
    required String id,
    required String name,
    required Address address,
    @Default([]) List<String> tags,
  }) = _{{className}};

  factory {{className}}.fromJson(Map<String, dynamic> json) => 
      _${{className}}FromJson(json);
}
```

## 带自定义方法的Model

当需要在freezed类中添加自定义方法时使用。

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{filename}}.freezed.dart';
part '{{filename}}.g.dart';

@freezed
abstract class {{className}} with _${{className}} {
  const {{className}}._(); // 添加私有构造函数以支持自定义方法

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

## Union Types (密封类/联合类型)

用于表示可以是多种不同类型的数据，类似枚举但更强大。

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

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

## 使用说明

1. 创建模型文件后，需要运行代码生成命令：

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. 修改模型后重新生成代码：

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. 在开发过程中使用观察模式自动生成：

   ```bash
   flutter pub run build_runner watch --delete-conflicting-outputs
   ```

## Freezed最佳实践

1. **使用const构造函数**: 所有freezed模型都应使用const构造函数
2. **使用@Default注解**: 为可选参数提供默认值
3. **添加自定义方法**: 对于需要计算属性或业务逻辑，添加自定义方法
4. **使用密封类/联合类型**: 对于有多种状态的数据，使用union types
5. **命名规范**: 主类名应为名词，union types的工厂构造函数应为动词或状态名

## 常见错误处理

1. **缺少生成文件**: 确保运行了build_runner命令
2. **命名冲突**: 确保没有方法名与属性名相同
3. **JSON序列化错误**: 对于复杂类型，确保提供了正确的fromJson/toJson转换
