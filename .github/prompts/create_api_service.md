# 创建新API服务

使用此Prompt来创建一个新的API服务类，用于处理与特定API端点的通信。

## 参数

- `serviceName`: 服务名称，如"User"、"Product"等
- `baseEndpoint`: API基础端点，如"/api/users"
- `methods`: 需要实现的方法，可选值: ["GET", "POST", "PUT", "DELETE", "PATCH"]
- `requiresAuth`: 是否需要身份验证令牌 (true/false)
- `dataModel`: 关联的数据模型名称
- `pagination`: 是否支持分页 (true/false)

## 生成的文件

此模板将生成以下文件:

1. API服务文件: `lib/app/data/providers/api/{{service_name_lowercase}}_api.dart`
2. 如果没有指定的数据模型，还会生成数据模型文件: `lib/app/data/models/{{service_name_lowercase}}.dart`

## 示例使用

```
服务名称: UserService
基础端点: /api/users
方法: GET, POST, PUT, DELETE
需要身份验证: 是
数据模型: User
支持分页: 是
```

## 命名约定

- 服务类命名: `{{ServiceName}}Api`
- 模型类命名: `{{ModelName}}`
- 方法命名:
  - GET列表: `getAll{{ServiceName}}s`
  - GET单个: `get{{ServiceName}}ById`
  - POST: `create{{ServiceName}}`
  - PUT: `update{{ServiceName}}`
  - DELETE: `delete{{ServiceName}}`
  - PATCH: `patch{{ServiceName}}`

----

现在请提供以上参数，我将为您生成完整的API服务代码。
