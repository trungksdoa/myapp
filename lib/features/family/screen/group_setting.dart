import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/service/auth_factory.dart';
import 'package:myapp/core/RoleManage.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/logger_service.dart';
import 'package:myapp/core/utils/security_storage.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/service/interface/auth_repository.dart';
import 'package:myapp/service/notification_service.dart';
import 'package:myapp/shared/widgets/dialogs/custom_diaglog.dart';
import 'package:permission_handler/permission_handler.dart';

class GroupSetting extends StatefulWidget {
  final String? groupId;
  const GroupSetting({super.key, this.groupId});

  @override
  State<GroupSetting> createState() => _GroupSettingState();
}

List<dynamic> listMenu = [
  {'icon': Icons.group, 'title': 'Danh sách thành viên', 'type': 'members'},
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

  void checkNotificationPermission() async {
    var notiStatus = await Permission.notification.status;

    if (!notiStatus.isGranted) {
      await Permission.notification.request();
    }
  }

  @override
  void initState() {
    super.initState();
    isAdminCheck(); // Call the check when screen initializes
  }

  void _navigateMembers() {
    NavigateHelper.goToSettingGroupMembers(context, widget.groupId!);
  }

  /// Check if can navigate back
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsivePadding = DeviceSize.getResponsivePadding(screenWidth);
    final responsiveBorderRadius = DeviceSize.getResponsiveBorderRadius(
      screenWidth,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 60.0,
            backgroundColor: Colors.white,
            elevation: 2,
            shadowColor: Colors.black26,
            leading: Padding(
              padding: EdgeInsets.all(responsivePadding),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
                onPressed: () => context.pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(responsiveBorderRadius),
                  ),
                  elevation: 1,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Cài đặt nhóm ${widget.groupId!}',
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
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: responsivePadding * 2,
              vertical: responsivePadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                ...listMenu.map((item) {
                  return Container(
                    margin: EdgeInsets.only(bottom: responsivePadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        responsiveBorderRadius,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        item['icon'] as IconData,
                        color: Colors.teal,
                      ),
                      title: Text(
                        item['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        if (item['type'] == 'members') {
                          _navigateMembers();
                        }

                        if (item['type'] == 'notifications') {
                          checkNotificationPermission();
                          NotificationService().showNotification(
                            title: 'Thông báo từ CareNest',
                            body: 'Bạn đã bật thông báo nhóm thành công!',
                          );
                        }
                      },
                    ),
                  );
                }),
                if (isAdmin)
                  Container(
                    margin: EdgeInsets.only(bottom: responsivePadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        responsiveBorderRadius,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.edit, color: Colors.teal),
                      title: const Text(
                        'Chỉnh sửa thông tin nhóm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        SnackBar snackBar = SnackBar(
                          content: Text(
                            'Chức năng đang phát triển. Vui lòng chờ cập nhật.',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                  ),
                Container(
                  margin: EdgeInsets.only(bottom: responsivePadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(responsiveBorderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
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
                      CustomDialog.showConfirm(
                        context,
                        title: 'Xác nhận rời nhóm',
                        content: 'Bạn có chắc chắn muốn rời nhóm không?',
                        buttonText: 'Rời nhóm',
                        iconData: Icons.exit_to_app,
                        onButtonPressed: () {
                          Navigator.of(context).pop();
                          context.pop();
                        },
                      );
                    },
                  ),
                ),
              ]),
            ),
          ),

          // Thêm SliverFillRemaining để đẩy nội dung xuống cuối
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsivePadding * 2,
                vertical: responsivePadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isAdmin)
                    Container(
                      margin: EdgeInsets.only(bottom: responsivePadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          responsiveBorderRadius,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Xác nhận xóa nhóm'),
                                content: const Text(
                                  'Bạn có chắc chắn muốn xóa nhóm này không? Tất cả dữ liệu nhóm sẽ bị mất và không thể khôi phục.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Hủy'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // TODO: Implement delete group logic here
                                      // For now, just navigate back
                                      Navigator.of(context).pop();
                                      context.pop();
                                    },
                                    child: const Text(
                                      'Xóa nhóm',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
