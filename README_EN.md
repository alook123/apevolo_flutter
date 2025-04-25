# ApeVolo Flutter

A cross-platform desktop + web application based on Flutter for the ApeVolo Enterprise Management System.

> **Note:** This project is currently in the development phase. Features may be incomplete and subject to change. Last updated: April 26, 2025

<div align="center">
  <img src="assets/image/logo.png" alt="Logo" width="80" height="80">
</div>

[简体中文](./README.md) | English

## 📱 Project Overview

ApeVolo Flutter is the mobile client application for the ApeVolo Enterprise Management System, supporting multiple platforms including Web, Windows, Mac, and Linux. This application provides various functions needed for enterprise management, including user management, permission control, data analysis, and more.

## ✨ Features

- 🔐 Comprehensive user authentication and permission control
- 🌐 Cross-platform support (Web, Windows, Mac, Linux)
- 🔄 Seamless integration with ApeVolo backend system
- 🎨 Modern UI design
- 🌙 Dark mode support
- 📊 Data visualization

## 🛠️ Requirements

- Flutter SDK 3.0.0 or higher
- Dart 2.17.0 or higher
- Development IDE: Android Studio or VS Code recommended

## 🚀 Quick Start

### 1. Environment Setup

Ensure Flutter SDK and Dart are installed. If not, follow the [Flutter official documentation](https://docs.flutter.dev/get-started/install) for installation.

### 2. Clone the Project

```bash
git clone https://github.com/alook123/apevolo_flutter.git
cd apevolo_flutter
```

### 3. Install Dependencies and Generate Code

```bash
flutter pub get
flutter pub run build_runner build
```

These commands will:

1. Get all required dependency packages
2. Generate serialization/deserialization code for model classes using the json_annotation framework
3. Generate network request code for retrofit interfaces
4. Generate corresponding code files for other annotations

### 4. Run the Application

```bash
flutter run
```

## 💻 Development Guide

### Code Generation

If you're developing, you can use the following command to start watch mode, which will automatically regenerate code when detecting changes in relevant files:

```bash
flutter pub run build_runner watch
```

If you encounter conflict errors in watch mode, you can add parameters to force overwrite of old files:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

Note: Each time you modify a model class with `@JsonSerializable()` or other annotations, you need to regenerate the code. Using the watch command can avoid manually running this step.

If you encounter conflict errors, you can use the following command to force overwrite of old generated files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Project Structure

```
lib/
├── app/
│   ├── components/         # Common components
│   ├── data/               # Data layer
│   │   ├── models/         # Data models
│   │   ├── providers/      # API providers
│   │   └── repositories/   # Data repositories
│   ├── modules/            # Feature modules
│   │   ├── home/           # Home module
│   │   ├── login/          # Login module
│   │   ├── permission/     # Permission module
│   │   ├── setting/        # Settings module
│   │   └── shell/          # Shell module
│   ├── routes/             # Route configuration
│   ├── service/            # Global services
│   ├── theme/              # Theme configuration
│   └── utilities/          # Utility classes
└── main.dart               # Application entry
```

## 🧰 Technology Stack

The following are the main technology frameworks and libraries used in this project:

- **Flutter**: Cross-platform UI framework
- **GetX**: State management, routing, and dependency injection framework
- **Dio**: HTTP client
- **Retrofit**: Type-safe REST API client generator
- **json_serializable**: JSON serialization/deserialization
- **Get Storage**: Local storage solution
- **Flutter SVG**: SVG icon support
- **encrypt**: Data encryption library
- **Flutter Localizations**: Internationalization support
- **Material Design 3**: Modern UI design
- **FluentUI System Icons**: Icon system
- **UUID**: Universal unique identifier generation

## 📄 Copyright

ApeVolo Flutter Copyright © 2025 ApeVolo Team

## 🔗 Related Links

- [ApeVolo Backend Project](https://github.com/xianhc/ApeVolo.Admin)
- [Flutter Official Documentation](https://docs.flutter.dev/)
- [Dart Official Documentation](https://dart.dev/guides)
- [GetX Documentation](https://pub.dev/packages/get)
- [Retrofit Documentation](https://pub.dev/packages/retrofit)
