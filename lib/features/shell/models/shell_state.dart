import '../../../network/apevolo_com/models/menu/menu_build_model.dart';

/// Shell 页面的整体状态
class ShellState {
  /// 当前选中的菜单
  final MenuBuild? currentMenu;

  /// 当前选中的子菜单
  final ChildrenMenu? currentChildMenu;

  /// 左侧菜单是否展开
  final bool menuOpen;

  /// 垂直菜单宽度
  final double verticalMenuWidth;

  /// 鼠标是否在调整大小区域
  final bool resizeMouse;

  /// 菜单加载状态
  final bool isLoading;

  /// 错误信息
  final String? error;

  const ShellState({
    this.currentMenu,
    this.currentChildMenu,
    this.menuOpen = true,
    this.verticalMenuWidth = 280.0,
    this.resizeMouse = false,
    this.isLoading = false,
    this.error,
  });

  ShellState copyWith({
    MenuBuild? currentMenu,
    ChildrenMenu? currentChildMenu,
    bool? menuOpen,
    double? verticalMenuWidth,
    bool? resizeMouse,
    bool? isLoading,
    String? error,
  }) {
    return ShellState(
      currentMenu: currentMenu ?? this.currentMenu,
      currentChildMenu: currentChildMenu ?? this.currentChildMenu,
      menuOpen: menuOpen ?? this.menuOpen,
      verticalMenuWidth: verticalMenuWidth ?? this.verticalMenuWidth,
      resizeMouse: resizeMouse ?? this.resizeMouse,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// 菜单状态
class MenuState {
  /// 菜单列表
  final List<MenuBuild> menus;

  /// 展开的菜单标签页
  final List<String> openTabs;

  /// 当前激活的标签页
  final String? activeTab;

  const MenuState({
    this.menus = const [],
    this.openTabs = const [],
    this.activeTab,
  });

  MenuState copyWith({
    List<MenuBuild>? menus,
    List<String>? openTabs,
    String? activeTab,
  }) {
    return MenuState(
      menus: menus ?? this.menus,
      openTabs: openTabs ?? this.openTabs,
      activeTab: activeTab ?? this.activeTab,
    );
  }
}
