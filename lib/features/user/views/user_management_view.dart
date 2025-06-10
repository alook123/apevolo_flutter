import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 用户管理页面 - 作为Shell内容的示例
class UserManagementView extends ConsumerWidget {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 页面标题
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  '用户管理',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 操作按钮栏
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showAddUserDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('添加用户'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => _refreshUsers(ref),
                  icon: const Icon(Icons.refresh),
                  label: const Text('刷新'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => _exportUsers(),
                  icon: const Icon(Icons.download),
                  label: const Text('导出'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 搜索栏
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: '搜索用户名、邮箱或部门...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _searchUsers(value),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: '全部部门',
                  items: const [
                    DropdownMenuItem(value: '全部部门', child: Text('全部部门')),
                    DropdownMenuItem(value: '技术部', child: Text('技术部')),
                    DropdownMenuItem(value: '市场部', child: Text('市场部')),
                    DropdownMenuItem(value: '人事部', child: Text('人事部')),
                  ],
                  onChanged: (value) => _filterByDepartment(value),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 用户列表
            Expanded(
              child: Card(
                child: _buildUserTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTable() {
    final mockUsers = [
      {
        'id': 1,
        'username': 'admin',
        'name': '管理员',
        'email': 'admin@apevolo.com',
        'department': '技术部',
        'role': '系统管理员',
        'status': '启用',
        'lastLogin': '2024-01-15 10:30:00',
      },
      {
        'id': 2,
        'username': 'john_doe',
        'name': '张三',
        'email': 'john@apevolo.com',
        'department': '技术部',
        'role': '开发工程师',
        'status': '启用',
        'lastLogin': '2024-01-15 09:15:00',
      },
      {
        'id': 3,
        'username': 'jane_smith',
        'name': '李四',
        'email': 'jane@apevolo.com',
        'department': '市场部',
        'role': '市场专员',
        'status': '禁用',
        'lastLogin': '2024-01-14 16:45:00',
      },
    ];

    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('用户名')),
          DataColumn(label: Text('姓名')),
          DataColumn(label: Text('邮箱')),
          DataColumn(label: Text('部门')),
          DataColumn(label: Text('角色')),
          DataColumn(label: Text('状态')),
          DataColumn(label: Text('最后登录')),
          DataColumn(label: Text('操作')),
        ],
        rows: mockUsers.map((user) {
          return DataRow(
            cells: [
              DataCell(Text(user['username'] as String)),
              DataCell(Text(user['name'] as String)),
              DataCell(Text(user['email'] as String)),
              DataCell(Text(user['department'] as String)),
              DataCell(Text(user['role'] as String)),
              DataCell(
                Chip(
                  label: Text(user['status'] as String),
                  backgroundColor: user['status'] == '启用'
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                ),
              ),
              DataCell(Text(user['lastLogin'] as String)),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () => _editUser(user['id'] as int),
                      tooltip: '编辑',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18),
                      onPressed: () => _deleteUser(user['id'] as int),
                      tooltip: '删除',
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, size: 18),
                      onPressed: () => _showUserMenu(user['id'] as int),
                      tooltip: '更多',
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加用户'),
        content: const SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: '用户名',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: '姓名',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: '邮箱',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 实现添加用户逻辑
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _refreshUsers(WidgetRef ref) {
    // TODO: 实现刷新用户列表逻辑
    debugPrint('刷新用户列表');
  }

  void _exportUsers() {
    // TODO: 实现导出用户数据逻辑
    debugPrint('导出用户数据');
  }

  void _searchUsers(String query) {
    // TODO: 实现搜索用户逻辑
    debugPrint('搜索用户: $query');
  }

  void _filterByDepartment(String? department) {
    // TODO: 实现按部门筛选逻辑
    debugPrint('按部门筛选: $department');
  }

  void _editUser(int userId) {
    // TODO: 实现编辑用户逻辑
    debugPrint('编辑用户: $userId');
  }

  void _deleteUser(int userId) {
    // TODO: 实现删除用户逻辑
    debugPrint('删除用户: $userId');
  }

  void _showUserMenu(int userId) {
    // TODO: 实现显示用户菜单逻辑
    debugPrint('显示用户菜单: $userId');
  }
}
