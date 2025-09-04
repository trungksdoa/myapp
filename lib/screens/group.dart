import 'package:flutter/material.dart';
import 'package:myapp/core/utils/logger_service.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/widget/boxContainer.dart';
import 'package:myapp/model/models.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key, required this.title});

  final String title;

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final List<Group> familyGroups = [
    Group(
      id: 1,
      name: 'Nhóm yêu mèo 🐱',
      memberCount: 452,
      imgUrl: 'assets/images/Home1.png',
      createdById: 'user1',
    ),
    Group(
      id: 2,
      name: 'Nhóm yêu chuột 🐭',
      memberCount: 452,
      imgUrl: 'assets/images/Home2.png',
      createdById: 'user1',
    ),
    Group(
      id: 3,
      name: 'Nhóm yêu gà 🐔',
      memberCount: 452,
      imgUrl: 'assets/images/Home3.png',
      createdById: 'user1',
    ),
    Group(
      id: 4,
      name: 'Nhóm yêu heo 🐖',
      memberCount: 452,
      imgUrl: 'assets/images/Home4.png',
      createdById: 'user1',
    ),
    Group(
      id: 5,
      name: 'Nhóm yêu tom & jerry 🐕 & 🐱',
      memberCount: 452,
      imgUrl: 'assets/images/Home5.png',
      createdById: 'user1',
    ),
  ];

  // Color mapping for groups
  final List<Color> groupColors = [
    Colors.blue.shade50,
    Colors.green.shade50,
    Colors.orange.shade50,
    Colors.purple.shade50,
    Colors.pink.shade50,
  ];

  void _navigateToFamilyBlog(
    BuildContext context,
    String groupId,
    String groupName,
    String groupSize,
    String groupAvatar,
  ) {
    LoggerService.instance.d('Navigating to family blog with params:');
    LoggerService.instance.d(
      'groupId: $groupId, groupName: $groupName, groupSize: $groupSize, groupAvatar: $groupAvatar',
    );
    NavigateHelper.goToFamilyBlog(
      context,
      groupId: groupId,
      groupName: groupName,
      groupSize: groupSize,
      groupAvatar: groupAvatar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar với header
          SliverAppBar(
            expandedHeight: 90.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.teal,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Nhóm gia đình',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.tealAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          // SliverPadding cho search bar
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: BoxContainerShadow(
                padding: 16,
                borderRadius: 25,
                backgroundColor: Colors.grey.shade200,
                hasShadow: false,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // SliverList cho danh sách nhóm
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final group = familyGroups[index];
                final groupColor = groupColors[index % groupColors.length];

                return BoxContainerShadow.groupCard(
                  backgroundColor: groupColor,
                  margin: 0,
                  customMargin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          group.imgUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.pets,
                              size: 30,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),
                    title: Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${group.memberCount} thành viên',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () {
                      _navigateToFamilyBlog(
                        context,
                        group.id.toString(),
                        group.name,
                        group.memberCount.toString(),
                        group.imgUrl,
                      );
                    },
                  ),
                );
              }, childCount: familyGroups.length),
            ),
          ),

          // SliverToBoxAdapter cho khoảng trống cuối
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.teal, Colors.tealAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withValues(alpha: 0.4),
              spreadRadius: 0,
              blurRadius: 35,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            NavigateHelper.goToGroupCreate(context);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.group_add, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
