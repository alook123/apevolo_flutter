# 路由常量重构迁移指南

## 📋 重构概览

原有的 `AppRoutes` 类已经重构为模块化的路由常量，提供更好的组织性和可维护性。

## 🏗️ 新的文件结构

```
lib/core/router/constants/
├── auth_routes.dart         # 认证相关路由
├── user_routes.dart         # 用户管理相关路由
├── system_routes.dart       # 系统管理相关路由
├── permission_routes.dart   # 权限管理相关路由
├── common_routes.dart       # 通用路由（主页、错误页等）
└── route_constants.dart     # 统一导出文件
```

## 🔄 迁移对照表

### 认证路由

| 旧路由 | 新路由 |
|--------|--------|
| `AppRoutes.login` | `AuthRoutes.login` |
| `AppRoutes.logout` | `AuthRoutes.logout` |

### 用户管理路由

| 旧路由 | 新路由 |
|--------|--------|
| `AppRoutes.users` | `UserRoutes.management` |
| `AppRoutes.userProfile` | `UserRoutes.profile` |

### 系统管理路由

| 旧路由 | 新路由 |
|--------|--------|
| `AppRoutes.settings` | `SystemRoutes.settings` |
| `AppRoutes.systemConfig` | `SystemRoutes.config` |
| `AppRoutes.menus` | `SystemRoutes.menus` |

### 权限管理路由

| 旧路由 | 新路由 |
|--------|--------|
| `AppRoutes.permissions` | `PermissionRoutes.management` |
| `AppRoutes.roles` | `PermissionRoutes.roles` |

### 通用路由

| 旧路由 | 新路由 |
|--------|--------|
| `AppRoutes.shell` | `CommonRoutes.shell` |
| `AppRoutes.dashboard` | `CommonRoutes.dashboard` |
| `AppRoutes.notFound` | `CommonRoutes.notFound` |
| `AppRoutes.serverError` | `CommonRoutes.serverError` |

## 📦 导入方式

### 方式1：统一导入（推荐）

```dart
import 'package:apevolo_flutter/core/router/constants/route_constants.dart';

// 使用
context.go(AuthRoutes.login);
context.go(UserRoutes.management);
context.go(SystemRoutes.settings);
```

### 方式2：单独导入

```dart
import 'package:apevolo_flutter/core/router/constants/auth_routes.dart';
import 'package:apevolo_flutter/core/router/constants/user_routes.dart';

// 使用
context.go(AuthRoutes.login);
context.go(UserRoutes.management);
```

## 🆕 新增功能

### 动态路由支持

```dart
// 用户详情页面
context.go(UserRoutes.detail('user123'));  // -> '/users/user123'

// 用户编辑页面
context.go(UserRoutes.edit('user123'));    // -> '/users/user123/edit'

// 角色详情页面
context.go(PermissionRoutes.roleDetail('role456')); // -> '/permission/roles/role456'
```

### 路由验证工具

```dart
// 检查是否为有效的静态路由
bool isValid = RouteConstants.isValidStaticRoute('/users');

// 检查是否为错误页面路由
bool isError = RouteConstants.isErrorRoute('/404');

// 获取所有静态路由
List<String> allRoutes = RouteConstants.allStaticRoutes;
```

## ⚠️ 向后兼容

旧的 `AppRoutes` 类仍然保留，但已标记为废弃：

```dart
@Deprecated('使用 AuthRoutes, UserRoutes, SystemRoutes, PermissionRoutes, CommonRoutes 替代')
class AppRoutes {
  // 旧的路由常量...
}
```

## 🚀 迁移步骤

1. **更新导入语句**

   ```dart
   // 旧方式
   import 'package:apevolo_flutter/core/router/app_routes.dart';
   
   // 新方式
   import 'package:apevolo_flutter/core/router/constants/route_constants.dart';
   ```

2. **更新路由引用**

   ```dart
   // 旧方式
   context.go(AppRoutes.login);
   
   // 新方式
   context.go(AuthRoutes.login);
   ```

3. **利用新功能**

   ```dart
   // 使用动态路由
   context.go(UserRoutes.detail(userId));
   
   // 使用路由验证
   if (RouteConstants.isValidStaticRoute(path)) {
     // 处理有效路由
   }
   ```

## 📝 待完成的迁移

以下文件仍需要更新（已标记为待迁移）：

- [ ] `lib/core/router/routes/auth_routes.dart`
- [ ] `lib/core/router/routes/shell_routes.dart`
- [ ] 其他引用旧 `AppRoutes` 的文件

## 🎯 迁移的好处

1. **命名空间清晰** - 避免路由名称冲突
2. **模块化管理** - 每个功能模块独立管理自己的路由
3. **团队协作友好** - 减少文件冲突，提高开发效率
4. **扩展性强** - 添加新路由时不会影响其他模块
5. **动态路由支持** - 提供带参数的路由生成方法
6. **工具方法** - 提供路由验证和管理工具
