import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/service/auth_factory.dart';
import 'package:myapp/core/RoleManage.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/logger_service.dart';
import 'package:myapp/service/interface/auth_repository.dart';
import 'package:myapp/shared/widgets/common/custom_card.dart';
import 'package:myapp/shared/widgets/common/custom_elevated_button.dart';
import 'package:myapp/shared/widgets/common/custom_text.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:myapp/features/family/widgets/member_card_widget.dart';
class GroupSettingMembers extends StatefulWidget{
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

  void _handleRemoveMember(Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText.subtitle(
            text: 'Xóa thành viên',
            color: Colors.red.shade700,
          ),
          content: CustomText.body(
            text:
                'Bạn có chắc chắn muốn xóa ${member['name']} khỏi nhóm không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: CustomText.button(text: 'Hủy'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement remove member
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa thành viên')),
                );
              },
              child: CustomText.button(text: 'Xóa', color: Colors.red.shade700),
            ),
          ],
        );
      },
    );
  }

  void _handleMemberLongPress(Map<String, dynamic> member) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: CustomText.body(text: 'Chuyển quyền quản trị'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement transfer admin
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: CustomText.body(text: 'Chặn thành viên'),
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
  }

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
              title: CustomText.title(
                text: 'Danh sách thành viên',
                color: Colors.black,
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
                  margin: EdgeInsets.only(bottom: AppSpacing.lg),
                  child: CustomCard.service(
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.teal.shade700,
                          size: 20,
                        ),
                        AppSpacing.horizontal(12),
                        Expanded(
                          child: CustomText.body(
                            text:
                                'Nhấn giữ tên thành viên để xem thêm tùy chọn',
                            color: Colors.teal.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Members list
                ...members.map((member) {
                  return MemberCard(
                    member: member,
                    isAdmin: isAdmin,
                    onRemovePressed: member['role'] != 'admin'
                        ? () => _handleRemoveMember(member)
                        : null,
                    onLongPress: () => _handleMemberLongPress(member),
                  );
                }),

                // Invite button
                Container(
                  margin: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: CustomElevatedButton.primary(
                    text: 'Mời thêm thành viên',
                    onPressed: () {
                      // TODO: Implement invite member
                    },
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
