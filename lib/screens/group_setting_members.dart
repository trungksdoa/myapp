import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/auth_factory.dart';
import 'package:myapp/core/RoleManage.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/logger_service.dart';
import 'package:myapp/service/interface/auth_repository.dart';

class GroupSettingMembers extends StatefulWidget {
  final String? groupId;
  const GroupSettingMembers({super.key, this.groupId});

  @override
  State<GroupSettingMembers> createState() => _GroupSettingMembersState();
}

// Mock data for members
List<Map<String, dynamic>> members = [
  {
    'name': 'Admin',
    'avatar': 'assets/images/home1.jpg',
    'role': 'admin',
    'id': '1',
  },
  {
    'name': 'Michel',
    'avatar': 'assets/images/home1.jpg',
    'role': 'member',
    'id': '2',
  },
  {
    'name': 'Michel',
    'avatar': 'assets/images/home1.jpg',
    'role': 'member',
    'id': '3',
  },
  {
    'name': 'Michel',
    'avatar': 'assets/images/home1.jpg',
    'role': 'member',
    'id': '4',
  },
];

class _GroupSettingMembersState extends State<GroupSettingMembers> {
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

  @override
  void initState() {
    super.initState();
    isAdminCheck();
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
              title: const Text(
                'Danh sách thành viên',
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

                // Info section
                Container(
                  margin: EdgeInsets.only(bottom: responsivePadding * 2),
                  padding: EdgeInsets.all(responsivePadding),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(responsiveBorderRadius),
                    border: Border.all(
                      color: Colors.teal.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.teal.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Nhấn giữ tên thành viên để xem thêm tùy chọn',
                          style: TextStyle(
                            color: Colors.teal.shade700,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Members list
                ...members.map((member) {
                  return Container(
                    margin: EdgeInsets.only(bottom: responsivePadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        responsiveBorderRadius,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: responsivePadding * 1.5,
                        vertical: responsivePadding * 0.5,
                      ),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(member['avatar'] as String),
                      ),
                      title: Row(
                        children: [
                          Text(
                            member['name'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (member['role'] == 'admin')
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.teal.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Quản trị viên',
                                style: TextStyle(
                                  color: Colors.teal.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      trailing: member['role'] == 'admin'
                          ? null
                          : TextButton(
                              onPressed: () {
                                // Show remove member confirmation
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Xóa thành viên',
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                      content: Text(
                                        'Bạn có chắc chắn muốn xóa ${member['name']} khỏi nhóm không?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Hủy'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // TODO: Implement remove member
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Đã xóa thành viên',
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Xóa',
                                            style: TextStyle(
                                              color: Colors.red.shade700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                minimumSize: const Size(40, 40),
                                padding: const EdgeInsets.all(0),
                              ),
                              child: const Text(
                                'Xoá',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                      onLongPress: () {
                        // Show member actions
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: EdgeInsets.all(responsivePadding),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.admin_panel_settings,
                                    ),
                                    title: const Text('Chuyển quyền quản trị'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      // TODO: Implement transfer admin
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.block),
                                    title: const Text('Chặn thành viên'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      // TODO: Implement block member
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }).toList(),

                // Invite button
                Container(
                  margin: EdgeInsets.symmetric(vertical: responsivePadding),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (!isAdmin) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Chỉ quản trị viên mới có thể mời thêm thành viên',
                            ),
                          ),
                        );
                        return;
                      }

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController dialogController =
                              TextEditingController();
                          bool isLoading = false;

                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    responsiveBorderRadius * 1.5,
                                  ),
                                ),
                                elevation: 8,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 400,
                                  ),
                                  padding: EdgeInsets.all(
                                    responsivePadding * 1.5,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Header với icon
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.teal.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.person_add,
                                              color: Colors.teal.shade700,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Mời thành viên mới',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Nhập email hoặc tên người dùng để gửi lời mời',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 24),

                                      // Input field với validation
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                            width: 1,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: dialogController,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            hintText:
                                                'Nhập email hoặc tên người dùng',
                                            hintStyle: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 16,
                                            ),
                                            prefixIcon: Icon(
                                              Icons.alternate_email,
                                              color: Colors.teal.shade400,
                                              size: 20,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: responsivePadding,
                                                  vertical: responsivePadding,
                                                ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          onChanged: (value) {
                                            // Có thể thêm validation real-time ở đây
                                          },
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      // Helper text
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 16,
                                            color: Colors.grey.shade500,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Người dùng sẽ nhận được thông báo mời tham gia nhóm',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 24),

                                      // Buttons
                                      Row(
                                        children: [
                                          // Cancel button
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: responsivePadding,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                'Hủy',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          // Send invite button
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: isLoading
                                                  ? null
                                                  : () async {
                                                      String inviteText =
                                                          dialogController.text
                                                              .trim();

                                                      if (inviteText.isEmpty) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              'Vui lòng nhập email hoặc tên người dùng',
                                                            ),
                                                            backgroundColor:
                                                                Colors.orange,
                                                          ),
                                                        );
                                                        return;
                                                      }

                                                      // Basic email validation
                                                      if (!inviteText.contains(
                                                            '@',
                                                          ) &&
                                                          !inviteText.contains(
                                                            ' ',
                                                          )) {
                                                        // Có thể là username, cho phép
                                                      } else if (inviteText
                                                              .contains('@') &&
                                                          !RegExp(
                                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                                          ).hasMatch(
                                                            inviteText,
                                                          )) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              'Email không hợp lệ',
                                                            ),
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                        );
                                                        return;
                                                      }

                                                      setState(
                                                        () => isLoading = true,
                                                      );

                                                      try {
                                                        // TODO: Implement actual invite logic
                                                        await Future.delayed(
                                                          const Duration(
                                                            seconds: 1,
                                                          ),
                                                        ); // Simulate API call

                                                        if (mounted) {
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              content: Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      'Đã gửi lời mời đến: $inviteText',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              backgroundColor:
                                                                  Colors.green,
                                                              duration:
                                                                  const Duration(
                                                                    seconds: 3,
                                                                  ),
                                                            ),
                                                          );
                                                        }
                                                      } catch (e) {
                                                        if (mounted) {
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                'Có lỗi xảy ra. Vui lòng thử lại.',
                                                              ),
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ),
                                                          );
                                                        }
                                                      } finally {
                                                        if (mounted) {
                                                          setState(
                                                            () => isLoading =
                                                                false,
                                                          );
                                                        }
                                                      }
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.teal,
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: responsivePadding,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                elevation: 0,
                                              ),
                                              child: isLoading
                                                  ? const SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                              Color
                                                            >(Colors.white),
                                                      ),
                                                    )
                                                  : const Text(
                                                      'Gửi lời mời',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(responsivePadding),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          responsiveBorderRadius,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.person_add),
                    label: const Text(
                      'Mời thêm thành viên',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
