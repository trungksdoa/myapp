import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/auth_factory.dart';
import 'package:myapp/core/RoleManage.dart';
import 'package:myapp/core/utils/logger_service.dart';
import 'package:myapp/core/utils/security_storage.dart';
import 'package:myapp/service/interface/auth_repository.dart';

class GroupSetting extends StatefulWidget {
  const GroupSetting({super.key});

  @override
  State<GroupSetting> createState() => _GroupSettingState();
}

List<dynamic> listMenu = [
  {'icon': Icons.group, 'title': 'Danh sách thành viên', 'type': 'members'},
  {'icon': Icons.person_add, 'title': 'Mời thành viên', 'type': 'invite'},
  {'icon': Icons.edit, 'title': 'Chỉnh sửa thông tin nhóm', 'type': 'edit'},
  {
    'icon': Icons.settings,
    'title': 'Cài đặt quyền riêng tư',
    'type': 'settings',
  },
  {
    'icon': Icons.notifications,
    'title': 'Thông báo nhóm',
    'type': 'notifications',
  },
];

class _GroupSettingState extends State<GroupSetting> {
  AuthRepository get _authService => AuthFactory.instance;

  /// Check if user is authenticated
  bool get isAuthenticated => _authService.isAuthenticated;

  /// Get current user info
  String? get currentUsername => _authService.username;
  String? get currentUserEmail => _authService.email;
  String? get currentUserId => _authService.userId;

  bool isAdmin = false;
  // Future<bool> isGroupAdmin = RoleManager.hasRole("BOSS");

  isAdminCheck() async {
    bool admin = await RoleManager.hasRole("BOSS");

    LoggerService.instance.d("Admin status: $admin");
    setState(() {
      // Cập nhật trạng thái isAdmin
      isAdmin = admin;
    });
  }

  void checkRoleStatus() async {
    final authRole = _authService.role;
    final storedRole = await SecureStorageService.getUserRole();
    LoggerService.instance.d(
      'Auth service role: $authRole, Stored role: $storedRole',
    );

    final hasRole = await RoleManager.hasRole("BOSS");
    LoggerService.instance.d('RoleManager.hasRole("BOSS") returned: $hasRole');
  }

  @override
  void initState() {
    super.initState();
    isAdminCheck(); // Call the check when screen initializes
  }

  /// Check if can navigate back
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 40.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
              onPressed: () => context.pop(),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 1,
                padding: const EdgeInsets.all(8),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Cài đặt nhóm',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),
              ...listMenu.map((item) {
                return ListTile(
                  leading: Icon(item['icon'] as IconData, color: Colors.teal),
                  title: Text(
                    item['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    // Xử lý sự kiện khi nhấn vào từng mục
                  },
                );
              }),

              if (isAdmin) const SizedBox(height: 32),
              if (isAdmin)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Xóa nhóm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    // Xử lý sự kiện xóa nhóm
                  },
                ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text(
                  'Rời nhóm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  // Xử lý sự kiện rời nhóm
                },
              ),

              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }
}
