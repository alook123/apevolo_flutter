# Flutter性能优化检查清单

使用此Prompt来分析Flutter代码并获取性能优化建议。

## 参数

- `filePath`: 需要分析的文件路径
- `focusAreas`: 优化重点领域，可选: ["rendering", "memory", "startup", "network", "state_management"]

## 分析内容

此工具将分析以下方面:

1. **渲染性能**
   - 不必要的重建
   - 缺少const构造函数
   - List/Grid优化问题
   - 缺少RepaintBoundary

2. **内存使用**
   - 资源泄漏
   - 大图片处理
   - 缓存策略

3. **启动时间**
   - 初始化优化
   - 延迟加载
   - 代码拆分

4. **网络性能**
   - API调用优化
   - 数据缓存策略
   - 图像加载策略

5. **状态管理**
   - 状态管理效率
   - 更新粒度
   - Context使用

## 输出格式

分析结果将包括:

1. **性能问题概述**
2. **按严重程度排序的问题列表**
3. **每个问题的修复建议**
4. **代码示例**
5. **性能测量方法建议**

## 示例使用

```
文件路径: lib/app/presentation/pages/home/home_page.dart
优化重点: rendering, memory
```

----

现在请提供以上参数，我将为您分析代码并提供性能优化建议。
