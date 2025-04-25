// 基础网络组件导出
export 'base/api_client.dart';
export 'base/dio_service.dart';
export 'base/error_handler.dart';
export 'base/dio_transform.dart';
export 'base/interceptors/auth_interceptor.dart';
export 'base/interceptors/response_interceptor.dart';

// 服务导出
export 'services/token_service.dart';

// API提供者导出
export 'modules/auth_provider.dart';
export 'modules/menu_provider.dart';
export 'modules/user_provider.dart';

/// apevolo_com API模块
/// 
/// 此文件作为统一的入口点，简化导入过程。
/// 使用示例：import 'package:apevolo_flutter/app/data/providers/apevolo_com/index.dart';
/// 
/// 本模块负责处理与apevolo.com网站相关的所有API通信：
/// - base: 包含基础网络组件(dio服务、API客户端、错误处理等)
/// - services: 包含通用服务(令牌服务等)
/// - modules: 包含按功能模块组织的API提供者(认证、菜单、用户等)