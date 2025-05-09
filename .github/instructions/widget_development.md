---
applyTo: '**/lib/app/presentation/widgets/**/*.dart'
---

# 小部件开发指南

## 基本原则

1. **组件化设计**：将UI拆分为小而可重用的组件
2. **单一职责**：每个组件只负责一个功能
3. **参数化配置**：使用参数配置UI样式和行为，而不是硬编码
4. **无状态优先**：优先使用StatelessWidget，除非必须管理状态
5. **一致的命名**：组件名称应反映其功能，并以"Widget"结尾

## 小部件结构模板

```dart
/// 描述小部件功能的文档注释
class {{WidgetName}}Widget extends StatelessWidget {
  /// 创建一个{{WidgetName}}Widget实例
  const {{WidgetName}}Widget({
    super.key,
    required this.requiredParam,
    this.optionalParam = defaultValue,
  });

  /// 必需参数的文档注释
  final Type requiredParam;
  
  /// 可选参数的文档注释
  final Type optionalParam;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 实现小部件UI
    );
  }
}
```

## StatefulWidget 结构模板

```dart
/// 描述小部件功能的文档注释
class {{WidgetName}}Widget extends StatefulWidget {
  /// 创建一个{{WidgetName}}Widget实例
  const {{WidgetName}}Widget({
    super.key,
    required this.requiredParam,
    this.optionalParam = defaultValue,
  });

  /// 必需参数的文档注释
  final Type requiredParam;
  
  /// 可选参数的文档注释
  final Type optionalParam;

  @override
  State<{{WidgetName}}Widget> createState() => _{{WidgetName}}WidgetState();
}

class _{{WidgetName}}WidgetState extends State<{{WidgetName}}Widget> {
  // 状态变量

  @override
  void initState() {
    super.initState();
    // 初始化代码
  }

  @override
  void dispose() {
    // 清理代码
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // 实现小部件UI
    );
  }
}
```

## 最佳实践

1. **惰性加载**：使用延迟初始化和懒加载优化性能
2. **键值管理**：对列表项目使用唯一键值
3. **分离逻辑与UI**：业务逻辑应当与UI分离
4. **响应式设计**：使用MediaQuery和LayoutBuilder实现响应式布局
5. **可访问性**：支持屏幕阅读器和高对比度模式
6. **本地化**：使用AppLocalizations支持多语言
7. **主题化**：使用Theme.of(context)获取主题数据，避免硬编码颜色和样式

## 性能优化

1. **const构造函数**：尽可能使用const构造函数
2. **缓存小部件**：缓存不经常变化的小部件实例
3. **使用构建器**：对大型列表使用ListView.builder而不是Column
4. **避免重建**：最小化setState()的范围，避免不必要的重建
5. **使用RepaintBoundary**：隔离频繁重绘的UI部分

## 测试指南

1. **Widget测试**：为每个小部件编写widget_test
2. **黄金测试**：使用黄金测试验证UI外观
3. **集成测试**：编写集成测试验证小部件交互
