# ApeVolo Flutter

一个基于Flutter的跨平台桌面+Web应用，用于ApeVolo企业管理系统。

> **注意：** 本项目目前处于开发阶段，功能可能不完整且存在变动。最后更新日期：2025年4月25日

<div align="center">
  <img src="assets/image/logo.png" alt="Logo" width="80" height="80">
</div>

简体中文 | [English](./README_EN.md)

## 📱 项目简介

ApeVolo Flutter是ApeVolo企业管理系统的移动端应用，支持Web、Windows、Mac、Linux等多个平台。该应用提供了企业管理所需的各种功能，包括用户管理、权限控制、数据分析等。

## ✨ 功能特点

- 🔐 完善的用户认证与权限控制
- 🌐 跨平台支持（Web、Windows、Mac、Linux）
- 🔄 与ApeVolo后端系统无缝集成
- 🎨 现代化UI设计
- 🌙 支持深色模式
- 📊 数据可视化

## 🛠️ 环境要求

- Flutter SDK 3.0.0 或更高版本
- Dart 2.17.0 或更高版本
- 开发IDE：推荐使用Android Studio或VS Code

## 🚀 快速开始

### 1. 环境设置

确保已安装Flutter SDK和Dart。如果尚未安装，请按照[Flutter官方文档](https://docs.flutter.dev/get-started/install)进行安装。

### 2. 克隆项目

```bash
git clone https://github.com/alook123/apevolo_flutter.git
cd apevolo_flutter
```

### 3. 安装依赖并生成代码

```bash
flutter pub get
flutter pub run build_runner build
```

这些命令将：

1. 获取项目所需的所有依赖包
2. 为使用 json_annotation 框架的模型类生成序列化/反序列化代码
3. 为 retrofit 接口生成网络请求代码
4. 为其他注解生成相应的代码文件

### 4. 运行应用

```bash
flutter run
```

## 💻 开发指南

### 代码生成

如果你正在进行开发，可以使用以下命令启动监视模式，它会在检测到相关文件变化时自动重新生成代码：

```bash
flutter pub run build_runner watch
```

如果在监视模式下遇到冲突错误，也可以添加参数强制覆盖旧文件：

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

注意：每次修改带有 `@JsonSerializable()` 或其他注解的模型类后，都需要重新生成代码。使用 watch 命令可以避免手动运行这个步骤。

如果遇到冲突错误，可以使用以下命令强制覆盖旧的生成文件：

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 项目结构

```
lib/
├── app/
│   ├── data/               # 数据层
│   │   ├── models/         # 数据模型
│   │   └── repositories/   # 数据仓库
│   ├── modules/            # 功能模块
│   ├── provider/           # API提供者
│   ├── routes/             # 路由配置
│   ├── theme/              # 主题配置
│   └── utils/              # 工具类
└── main.dart               # 应用入口
```

## 📄 版权信息

ApeVolo Flutter 版权所有 © 2025 ApeVolo Team

## 🔗 相关链接

- [ApeVolo 后端项目](https://github.com/xianhc/ApeVolo.Admin)
- [Flutter 官方文档](https://docs.flutter.dev/)
- [Dart 官方文档](https://dart.dev/guides)
