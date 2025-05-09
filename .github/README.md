# 如何使用Instructions和Prompts文件

## Instructions文件

Instructions文件用于为AI助手提供长期有效的项目规范和编码指南。这些文件会自动应用于匹配路径的文件，无需显式引用。

### 已创建的Instructions文件

1. **flutter_code_style.md**
   - 适用于: 所有Dart文件
   - 功能: 提供Flutter/Dart代码的格式和风格指南
   - 位置: `.github/instructions/flutter_code_style.md`

2. **repository_pattern.md**
   - 适用于: 数据仓库层相关文件
   - 功能: 提供仓库模式的实现指南和标准结构
   - 位置: `.github/instructions/repository_pattern.md`

3. **widget_development.md**
   - 适用于: 小部件相关文件
   - 功能: 提供小部件开发的最佳实践和标准结构
   - 位置: `.github/instructions/widget_development.md`

4. **freezed_model_templates.md**
   - 适用于: 模型相关文件
   - 功能: 提供使用freezed创建模型类的模板和指南
   - 位置: `.github/instructions/freezed_model_templates.md`

### 如何使用Instructions文件

这些文件会自动应用于匹配的文件路径。例如，当你在编辑models目录下的文件时，freezed_model_templates.md中的指南会自动应用，AI助手会根据这些指南提供建议。

## Prompt文件

Prompt文件用于执行特定任务，需要用户明确引用才能使用。这些文件适合用于一次性或临时任务。

### 已创建的Prompt文件

1. **create_page.md**
   - 功能: 创建新页面，包括视图、控制器和绑定文件
   - 位置: `.github/prompts/create_page.md`

2. **create_api_service.md**
   - 功能: 创建新的API服务类
   - 位置: `.github/prompts/create_api_service.md`

3. **generate_tests.md**
   - 功能: 为现有类生成单元测试
   - 位置: `.github/prompts/generate_tests.md`

4. **performance_analysis.md**
   - 功能: 分析代码并提供性能优化建议
   - 位置: `.github/prompts/performance_analysis.md`

### 如何使用Prompt文件

在VSCode中，你可以使用以下步骤使用Prompt文件:

1. 打开命令面板 (Cmd+Shift+P)
2. 输入 `/prompt`
3. 选择相应的Prompt文件
4. 按照提示填写所需参数

或者，你可以直接在聊天中引用Prompt文件，例如:

```
/prompt .github/prompts/create_page.md
```

然后按照提示填写参数。

## 定制和维护

你可以根据项目需求随时修改现有的Instructions和Prompt文件，或创建新的文件。保持这些文件的更新将帮助确保代码质量和一致性。
