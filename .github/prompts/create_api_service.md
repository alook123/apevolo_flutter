# 创建新API服务

使用此Prompt来创建一个新的API服务类，用于处理与特定API端点的通信，以及对应的Repository层实现。

## 参数

- `serviceName`: 服务名称，如"User"、"Product"等
- `baseEndpoint`: API基础端点，如"/api/users"
- `methods`: 需要实现的方法，可选值: ["GET", "POST", "PUT", "DELETE", "PATCH"]
- `requiresAuth`: 是否需要身份验证令牌 (true/false)
- `dataModel`: 关联的数据模型名称
- `pagination`: 是否支持分页 (true/false)
- `caching`: 是否需要本地缓存策略 (true/false)

## 生成的文件

此模板将生成以下文件:

1. API服务文件: `lib/app/data/providers/api/{{service_name_lowercase}}_api.dart`
2. Repository文件: `lib/app/data/repositories/{{service_name_lowercase}}_repository.dart`
3. 如果没有指定的数据模型，还会生成数据模型文件: `lib/app/data/models/{{service_name_lowercase}}.dart`

## 示例使用

```plaintext
服务名称: UserService
基础端点: /api/users
方法: GET, POST, PUT, DELETE
需要身份验证: 是
数据模型: User
支持分页: 是
本地缓存: 是
```

## 命名约定

- 服务类命名: `{{ServiceName}}Api`
- 仓库类命名: `{{ServiceName}}Repository`
- 模型类命名: `{{ModelName}}`
- API方法命名:
  - GET列表: `getAll{{ServiceName}}s`
  - GET单个: `get{{ServiceName}}ById`
  - POST: `create{{ServiceName}}`
  - PUT: `update{{ServiceName}}`
  - DELETE: `delete{{ServiceName}}`
  - PATCH: `patch{{ServiceName}}`
- Repository方法命名:
  - 与API方法相同，但内部实现包含缓存策略和业务逻辑

## Repository层功能

Repository层具有以下职责:

1. **数据整合**: 整合API和本地数据源的数据
2. **缓存策略**: 管理数据缓存，决定何时从网络获取数据，何时使用本地缓存
3. **错误处理**: 统一处理API错误，并提供回退机制
4. **数据转换**: 在数据模型和实体模型之间进行转换
5. **业务逻辑**: 包含简单的业务逻辑处理

## Repository层示例结构

```dart
class UserRepository {
  final UserApi _userApi;
  final GetStorage _storage; // 使用GetX的GetStorage进行缓存
  
  UserRepository(this._userApi)
      : _storage = GetStorage('user_storage');
  
  Future<List<User>> getAllUsers({bool forceRefresh = false}) async {
    final String cacheKey = 'all_users';
    
    // 如果不强制刷新，尝试从缓存获取
    if (!forceRefresh) {
      final List<dynamic>? cachedData = _storage.read<List<dynamic>>(cacheKey);
      if (cachedData != null && cachedData.isNotEmpty) {
        return cachedData.map((json) => User.fromJson(json)).toList();
      }
    }
    
    // 从API获取数据
    try {
      final users = await _userApi.getAllUsers();
      
      // 将数据保存到缓存
      await _storage.write(
        cacheKey, 
        users.map((user) => user.toJson()).toList()
      );
      
      return users;
    } catch (e) {
      // 错误处理
      throw AppException(
        '获取用户列表失败', 
        originalException: e
      );
    }
  }
  
  // 获取单个用户
  Future<User> getUserById(int id, {bool forceRefresh = false}) async {
    final String cacheKey = 'user_$id';
    
    // 尝试从缓存获取
    if (!forceRefresh) {
      final Map<String, dynamic>? userData = _storage.read<Map<String, dynamic>>(cacheKey);
      if (userData != null) {
        return User.fromJson(userData);
      }
    }
    
    // 从API获取
    final user = await _userApi.getUserById(id);
    await _storage.write(cacheKey, user.toJson());
    return user;
  }
}

----

现在请提供以上参数，我将为您生成完整的API服务和Repository代码。
