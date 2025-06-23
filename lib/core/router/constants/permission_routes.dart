/// 权限管理相关路由常量
/// 包含权限设置、角色管理、部门管理等功能的路由路径
class PermissionRoutes {
  /// 权限管理主页面
  static const String management = '/permission';

  /// 角色管理页面
  static const String roles = '/permission/roles';

  /// 部门管理页面（预留）
  static const String departments = '/permission/departments';

  /// 权限分配页面（预留）
  static const String assignment = '/permission/assignment';

  /// 角色详情页面
  /// 使用方法：PermissionRoutes.roleDetail('123') => '/permission/roles/123'
  static String roleDetail(String roleId) => '/permission/roles/$roleId';

  /// 角色编辑页面
  /// 使用方法：PermissionRoutes.roleEdit('123') => '/permission/roles/123/edit'
  static String roleEdit(String roleId) => '/permission/roles/$roleId/edit';

  /// 部门详情页面
  /// 使用方法：PermissionRoutes.departmentDetail('123') => '/permission/departments/123'
  static String departmentDetail(String deptId) =>
      '/permission/departments/$deptId';

  /// 获取所有权限管理相关路由列表（不包含动态路由）
  static List<String> get all => [
        management,
        roles,
        departments,
        assignment,
      ];
}
