import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/apevolo_com/models/menu/menu_build_model.dart';
import '../../../shared/providers/api/menu_rest_client_provider.dart';
import '../models/shell_state.dart';

part 'shell_provider.g.dart';

/// Shell 主要状态管理
@riverpod
class Shell extends _$Shell {
  @override
  ShellState build() {
    return const ShellState();
  }

  /// 切换菜单展开状态
  void toggleMenu() {
    state = state.copyWith(menuOpen: !state.menuOpen);
  }

  /// 设置垂直菜单宽度
  void setVerticalMenuWidth(double width) {
    if (width < 250 || width > 800) return;
    state = state.copyWith(verticalMenuWidth: width);
  }

  /// 设置鼠标调整大小状态
  void setResizeMouse(bool value) {
    state = state.copyWith(resizeMouse: value);
  }

  /// 设置当前菜单
  void setCurrentMenu(MenuBuild? menu) {
    state = state.copyWith(currentMenu: menu);
  }

  /// 设置当前子菜单
  void setCurrentChildMenu(ChildrenMenu? childMenu) {
    state = state.copyWith(currentChildMenu: childMenu);
  }

  /// 导航到指定路由
  void navigateToRoute(String routeName) {
    // TODO: 实现路由导航逻辑
    // 这里可以集成你的路由系统
    debugPrint('Navigate to route: $routeName');
  }
}

/// 菜单状态管理
@riverpod
class ShellMenu extends _$ShellMenu {
  @override
  Future<MenuState> build() async {
    // 直接返回加载的菜单数据
    return await _loadMenu();
  }

  /// 加载菜单数据
  Future<MenuState> _loadMenu() async {
    if (kDebugMode) {
      print('ShellMenu: 开始加载菜单数据...');
    }

    try {
      // 获取菜单REST客户端
      final menuRestClient = ref.read(menuRestClientProvider);

      if (kDebugMode) {
        print('ShellMenu: 获取到MenuRestClient，准备调用API...');
      }

      // 调用API获取菜单数据
      final menus = await menuRestClient.build();

      if (kDebugMode) {
        print('ShellMenu: API调用成功，获取到 ${menus.length} 个菜单');
      }

      return MenuState(menus: menus);
    } catch (error) {
      // 如果API调用失败，使用模拟数据进行测试
      if (kDebugMode) {
        print('ShellMenu: 菜单API调用失败，使用模拟数据: $error');
      }

      // 创建模拟菜单数据
      final mockMenus = _createMockMenus();

      if (kDebugMode) {
        print('ShellMenu: 使用模拟数据，创建了 ${mockMenus.length} 个菜单');
      }

      return MenuState(menus: mockMenus);
    }
  }

  /// 创建模拟菜单数据用于测试
  List<MenuBuild> _createMockMenus() {
    return [
      MenuBuild(
        name: 'dashboard',
        meta: const Meta(title: '仪表盘', icon: 'dashboard'),
        children: [],
        expanded: false,
      ),
      MenuBuild(
        name: 'system',
        meta: const Meta(title: '系统管理', icon: 'system'),
        expanded: false,
        children: [
          ChildrenMenu(
            name: 'user',
            meta: const Meta(title: '用户管理', icon: 'user'),
            path: '/system/user',
            component: 'user',
          ),
          ChildrenMenu(
            name: 'role',
            meta: const Meta(title: '角色管理', icon: 'role'),
            path: '/system/role',
            component: 'role',
          ),
          ChildrenMenu(
            name: 'menu',
            meta: const Meta(title: '菜单管理', icon: 'menu'),
            path: '/system/menu',
            component: 'menu',
          ),
        ],
      ),
      MenuBuild(
        name: 'settings',
        meta: const Meta(title: '系统设置', icon: 'settings'),
        children: [],
        expanded: false,
      ),
    ];
  }

  /// 刷新菜单
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadMenu());
  }

  /// 切换菜单展开状态
  void toggleMenuExpansion(MenuBuild menu, bool expanded) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final menuIndex = currentState.menus.indexWhere((m) => m == menu);
    if (menuIndex == -1) return;

    final updatedMenus = List<MenuBuild>.from(currentState.menus);
    updatedMenus[menuIndex] = menu.copyWith(expanded: expanded);

    state = AsyncValue.data(
      currentState.copyWith(menus: updatedMenus),
    );
  }

  /// 添加标签页
  void addTab(String tabId) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    if (!currentState.openTabs.contains(tabId)) {
      final updatedTabs = [...currentState.openTabs, tabId];
      state = AsyncValue.data(
        currentState.copyWith(
          openTabs: updatedTabs,
          activeTab: tabId,
        ),
      );
    } else {
      // 如果标签页已存在，只需要激活它
      state = AsyncValue.data(
        currentState.copyWith(activeTab: tabId),
      );
    }
  }

  /// 关闭标签页
  void closeTab(String tabId) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final updatedTabs =
        currentState.openTabs.where((id) => id != tabId).toList();
    String? newActiveTab = currentState.activeTab;

    // 如果关闭的是当前激活的标签页，需要选择新的激活标签页
    if (currentState.activeTab == tabId) {
      newActiveTab = updatedTabs.isNotEmpty ? updatedTabs.last : null;
    }

    state = AsyncValue.data(
      currentState.copyWith(
        openTabs: updatedTabs,
        activeTab: newActiveTab,
      ),
    );
  }

  /// 设置激活的标签页
  void setActiveTab(String tabId) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    state = AsyncValue.data(
      currentState.copyWith(activeTab: tabId),
    );
  }
}
