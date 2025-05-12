# API Client 与 模型生成模板

本文档提供了在 Apevolo Flutter 项目中创建 API Client 和相关模型的标准模板和最佳实践。

## 目录

1. [工作流程](#工作流程)
2. [命名规范](#命名规范)
3. [模型模板](#模型模板)
4. [Provider 模板](#provider-模板)
5. [常见请求类型](#常见请求类型)
6. [代码生成](#代码生成)
7. [最佳实践](#最佳实践)

## 工作流程

创建新的 API Provider 和模型的标准流程：

1. **分析 Swagger 文档**: 检查 API 端点、请求参数和响应类型。
2. **创建模型类**: 为请求体和响应创建具体的实体类。
3. **实现 API Provider**: 使用 Retrofit 定义 API 方法。
4. **生成代码**: 运行代码生成器生成相关的 `.g.dart` 文件。
5. **测试 API**: 验证 API 调用是否正常工作。

## 命名规范

### 模型类

```
models/apevolo_models/{entity_name}/{specific_model_name}.dart
```

- 请求模型: `create_update_{entity_name}_model.dart`
- 响应模型: `{entity_name}_response_model.dart`
- 查询模型: `{entity_name}_query_model.dart`
- 子模型组件: `{entity_name}_{component}_model.dart`

### API Provider

```
providers/apevolo_com/modules/{entity_name}_provider.dart
```

类名: `{Entity}Provider`

## 模型模板

### 基本响应模型

```dart
// filepath: /lib/app/data/models/apevolo_models/{entity_name}/{entity_name}_response_model.dart
import 'package:json_annotation/json_annotation.dart';

part '{entity_name}_response_model.g.dart';

/// {Entity} 操作响应模型
@JsonSerializable()
class {Entity}ResponseModel {
  int? id;
  String? name;
  // 其他属性...

  {Entity}ResponseModel({
    this.id,
    this.name,
    // 其他属性...
  });

  factory {Entity}ResponseModel.fromJson(Map<String, dynamic> json) =>
      _${Entity}ResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _${Entity}ResponseModelToJson(this);
}
```

### 创建/更新模型

```dart
// filepath: /lib/app/data/models/apevolo_models/{entity_name}/create_update_{entity_name}_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'create_update_{entity_name}_model.g.dart';

/// 创建或更新{Entity}的数据传输对象
@JsonSerializable()
class CreateUpdate{Entity}Model {
  int? id;
  
  @JsonKey(required: true)
  String name;
  
  // 其他属性...
  
  // 关联对象示例
  @JsonKey(required: true)
  {Related}Model related;
  
  // 关联集合示例
  @JsonKey(required: true)
  List<{Item}Model> items;

  CreateUpdate{Entity}Model({
    this.id,
    required this.name,
    required this.related,
    required this.items,
    // 其他属性...
  });

  factory CreateUpdate{Entity}Model.fromJson(Map<String, dynamic> json) =>
      _$CreateUpdate{Entity}ModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUpdate{Entity}ModelToJson(this);
}

/// 关联模型示例
@JsonSerializable()
class {Related}Model {
  int? id;
  
  @JsonKey(required: true)
  String name;

  {Related}Model({
    this.id,
    required this.name,
  });

  factory {Related}Model.fromJson(Map<String, dynamic> json) =>
      _${Related}ModelFromJson(json);

  Map<String, dynamic> toJson() => _${Related}ModelToJson(this);
}

/// 项目模型示例
@JsonSerializable()
class {Item}Model {
  int? id;
  
  @JsonKey(required: true)
  String name;

  {Item}Model({
    this.id,
    required this.name,
  });

  factory {Item}Model.fromJson(Map<String, dynamic> json) =>
      _${Item}ModelFromJson(json);

  Map<String, dynamic> toJson() => _${Item}ModelToJson(this);
}
```

### 查询模型

```dart
// filepath: /lib/app/data/models/apevolo_models/{entity_name}/{entity_name}_query_model.dart
import 'package:apevolo_flutter/app/data/models/apevolo_models/model_base.dart';
import 'package:json_annotation/json_annotation.dart';

part '{entity_name}_query_model.g.dart';

@JsonSerializable()
class {Entity}Query extends ModelBase {
  List<{Entity}Content>? content;
  int? totalElements;
  int? totalPages;

  {Entity}Query({this.content, this.totalElements, this.totalPages});

  factory {Entity}Query.fromJson(Map<String, dynamic> json) =>
      _${Entity}QueryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _${Entity}QueryToJson(this);
}

@JsonSerializable()
class {Entity}Content {
  int? id;
  String? name;
  // 其他属性...
  
  {Entity}Content({
    this.id,
    this.name,
    // 其他属性...
  });

  factory {Entity}Content.fromJson(Map<String, dynamic> json) =>
      _${Entity}ContentFromJson(json);

  Map<String, dynamic> toJson() => _${Entity}ContentToJson(this);
}
```

## Provider 模板

### 基本 Provider

```dart
// filepath: /lib/app/data/providers/apevolo_com/modules/{entity_name}_provider.dart
import 'package:apevolo_flutter/app/data/models/apevolo_models/common/action_result_vm.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/common/id_collection.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/{entity_name}/create_update_{entity_name}_model.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/{entity_name}/{entity_name}_query_model.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/{entity_name}/{entity_name}_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part '{entity_name}_provider.g.dart';

@RestApi(baseUrl: '/api/{entity_path}')
abstract class {Entity}Provider {
  factory {Entity}Provider(Dio dio, {String baseUrl}) = _{Entity}Provider;

  /// 查询{entity}列表
  @GET('/query')
  Future<{Entity}Query> query(
    @Query('id') int? id,
    @Query('pageIndex') int? pageIndex,
    @Query('pageSize') int? pageSize,
    @Query('sortFields') List<String>? sortFields,
    @Query('totalElements') int? totalElements,
    // 其他查询参数...
  );

  /// 创建{entity}
  @POST('/create')
  Future<ActionResultVm<{Entity}ResponseModel>> create(
    @Body() CreateUpdate{Entity}Model {entity},
  );

  /// 更新{entity}
  @PUT('/edit')
  Future<void> edit(
    @Body() CreateUpdate{Entity}Model {entity},
  );

  /// 删除{entity}
  @DELETE('/delete')
  Future<ActionResultVm<{Entity}ResponseModel>> delete(
    @Body() IdCollection ids,
  );
  
  /// 导出{entity}列表
  @GET('/download')
  Future<List<int>> download(
    @Query('id') int? id,
    // 其他查询参数...
  );
}
```

## 常见请求类型

### GET 请求

```dart
@GET('/{path}')
Future<ActionResultVm<{ResponseType}>> get{Method}(
  @Query('param1') Type param1,
  @Query('param2') Type param2,
);
```

### 带路径参数的 GET 请求

```dart
@GET('/{pathParam}')
Future<ActionResultVm<{ResponseType}>> get{Method}ById(
  @Path('pathParam') Type pathParam,
);
```

### POST 请求

```dart
@POST('/{path}')
Future<ActionResultVm<{ResponseType}>> create(
  @Body() CreateUpdate{Entity}Model entity,
);
```

### PUT 请求

```dart
@PUT('/{path}')
Future<void> update(
  @Body() CreateUpdate{Entity}Model entity,
);
```

### DELETE 请求

```dart
@DELETE('/{path}')
Future<ActionResultVm<{ResponseType}>> delete(
  @Body() IdCollection ids,
);
```

### 文件上传

```dart
@POST('/{path}')
@MultiPart()
Future<ActionResultVm<{ResponseType}>> upload{Item}(
  @Part() File file,
);
```

## 代码生成

生成与模型和 API 相关的代码文件:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

持续监听变更:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## 最佳实践

1. **避免使用 `dynamic` 类型**：始终为 API 响应定义具体的模型类。

   ```dart
   // 不推荐
   Future<ActionResultVm<dynamic>> create(@Body() Map<String, dynamic> entity);
   
   // 推荐
   Future<ActionResultVm<{Entity}ResponseModel>> create(@Body() CreateUpdate{Entity}Model entity);
   ```

2. **明确的参数命名**：使用明确的参数名称，避免使用通用名称。

   ```dart
   // 不推荐
   @Query('q') String query
   
   // 推荐
   @Query('keyWords') String keyWords
   ```

3. **文档注释**：为每个 API 方法添加清晰的文档注释。

   ```dart
   /// 根据部门ID查询用户列表
   /// [deptId] 部门ID
   @GET('/by-dept')
   Future<List<UserResponseModel>> getUsersByDept(@Query('deptId') int deptId);
   ```

4. **分页参数**：统一使用 `pageIndex` 和 `pageSize` 作为分页参数。

   ```dart
   @Query('pageIndex') int pageIndex = 0,
   @Query('pageSize') int pageSize = 10,
   ```

5. **错误处理**：在 Repository 层处理 API 调用的错误，而不是在 Provider 层。

6. **按功能组织**：按照功能领域组织模型和 Provider，而不是按照技术层组织。

7. **使用适当的 HTTP 方法**：
   - GET: 获取资源
   - POST: 创建资源
   - PUT: 更新资源
   - DELETE: 删除资源

8. **文件组织**：相关的模型文件应该放在同一个目录中。

## 示例：用户模块

### 用户响应模型

```dart
// user_response_model.dart
@JsonSerializable()
class UserResponseModel {
  int? id;
  String? username;
  String? nickName;
  String? email;
  bool? enabled;
  String? phone;
  String? avatarPath;
  String? gender;

  UserResponseModel({
    this.id,
    this.username,
    this.nickName,
    this.email,
    this.enabled,
    this.phone,
    this.avatarPath,
    this.gender,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseModelToJson(this);
}
```

### 用户 Provider

```dart
// user_provider.dart
@RestApi(baseUrl: '/api/user')
abstract class UserProvider {
  factory UserProvider(Dio dio, {String baseUrl}) = _UserProvider;

  /// 创建用户
  @POST('/create')
  Future<ActionResultVm<UserResponseModel>> create(
    @Body() CreateUpdateUserModel user,
  );

  /// 更新用户
  @PUT('/edit')
  Future<void> edit(
    @Body() CreateUpdateUserModel user,
  );

  /// 删除用户
  @DELETE('/delete')
  Future<ActionResultVm<UserResponseModel>> delete(
    @Body() IdCollection ids,
  );

  /// 更新用户个人中心信息
  @PUT('/update/center')
  Future<void> updateCenter(
    @Body() UpdateUserCenterModel userCenter,
  );

  /// 更新用户密码
  @POST('/update/password')
  Future<ActionResultVm<UserResponseModel>> updatePassword(
    @Body() UpdatePasswordModel passwordInfo,
  );

  /// 更新用户邮箱
  @POST('/update/email')
  Future<ActionResultVm<UserResponseModel>> updateEmail(
    @Body() UpdateEmailModel emailInfo,
  );

  /// 更新用户头像
  @POST('/update/avatar')
  @MultiPart()
  Future<ActionResultVm<UserResponseModel>> updateAvatar(
    @Part() File avatar,
  );

  /// 查询用户列表
  @GET('/query')
  Future<UserQuery> query(
    @Query('id') int? id,
    @Query('deptId') int? deptId,
    @Query('deptIds') List<int>? deptIds,
    @Query('keyWords') String? keyWords,
    @Query('enabled') bool? enabled,
    @Query('pageIndex') int? pageIndex,
    @Query('pageSize') int? pageSize,
    @Query('sortFields') List<String>? sortFields,
    @Query('totalElements') int? totalElements,
  );

  /// 导出用户列表
  @GET('/download')
  Future<List<int>> download(
    @Query('id') int? id,
    @Query('keyWords') String? keyWords,
    @Query('enabled') bool? enabled,
    @Query('deptId') int? deptId,
    @Query('deptIdItems') String? deptIdItems,
    @Query('createTime') List<DateTime>? createTime,
  );
}
```
