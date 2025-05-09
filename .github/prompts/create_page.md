# 创建新页面模板

使用此Prompt来创建一个新的页面，包括所有必要的文件和结构。

## 参数

- `pageName`: 页面名称，如"Login"、"UserDetail"等
- `description`: 页面功能描述
- `hasForm`: 是否包含表单 (true/false)
- `requiresAuth`: 是否需要身份验证 (true/false)
- `usesApi`: 是否使用API (true/false)

## 生成的文件

此模板将生成以下文件:

1. 页面视图文件: `lib/app/presentation/pages/{{page_name_lowercase}}/{{page_name_lowercase}}_page.dart`
2. 控制器文件: `lib/app/controllers/{{page_name_lowercase}}_controller.dart`
3. 绑定文件: `lib/app/bindings/{{page_name_lowercase}}_binding.dart`
4. 路由定义: 添加到 `lib/app/routes/app_pages.dart`

## 示例使用

```
页面名称: UserProfile
描述: 用户个人资料页面，显示用户信息并允许编辑
是否包含表单: 是
是否需要身份验证: 是
是否使用API: 是
```

## 命名约定

- 页面类命名: `{{PageName}}Page`
- 控制器命名: `{{PageName}}Controller`
- 绑定类命名: `{{PageName}}Binding`
- 路由名称: `/{{page_name_kebab}}` (如 `/user-profile`)

----

现在请提供以上参数，我将为您生成完整的页面代码。
