import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'dart:io';

import 'package:myapp/widget/group/group_app_bar.dart';

class FamilyBlog extends StatefulWidget {
  final String? groupId;
  final String? groupName;
  final String? groupMembers;
  final String? groupAvatar;

  const FamilyBlog({
    super.key,
    this.groupId,
    this.groupName,
    this.groupMembers,
    this.groupAvatar,
  });

  @override
  State<FamilyBlog> createState() => _FamilyBlogState();
}

class _FamilyBlogState extends State<FamilyBlog> {
  // print(widget.groupAvatar);
  final List<Map<String, dynamic>> familyGroups = [
    {
      'id': '1',
      'name': 'Huỳnh Gia Bảo',
      'postTime': "6 phút trước",
      'pet': 'Tini',
      'image': [
        'assets/images/Home1.png',
        'assets/images/Home2.png',
        'assets/images/Home3.png',
      ],
      'comment': "Cháu lì lắm",
    },
    {
      'id': '2',
      'name': 'Nguyễn Thị Thùy Dương',
      'postTime': "6 phút trước",
      'pet': 'Lulu',
      'image': [
        'assets/images/Home4.png',
        'assets/images/Home5.png',
        'assets/images/Home1.png',
      ],
      'comment': "Cháu biến ăn lắm",
    },
    {
      'id': '3',
      'name': 'Trần Minh Tuấn',
      'postTime': "6 phút trước",
      'pet': 'Milo',
      'image': [
        'assets/images/Home4.png',
        'assets/images/Home5.png',
        'assets/images/Home1.png',
      ],
      'comment': "Hôm nay cháu vui lắm",
    },
    {
      'id': '4',
      'name': 'Lê Thị Mỹ Linh',
      'postTime': "6 phút trước",
      'pet': 'Mimi',
      'image': [
        'assets/images/Home2.png',
        'assets/images/Home3.png',
        'assets/images/Home4.png',
      ],
      'comment': "Hôm nay cháu vui lắm",
    },
    {
      'id': '5',
      'name': 'Nguyễn Văn Nam',
      'postTime': "6 phút trước",
      'pet': 'Tom',
      'image': [
        'assets/images/Home5.png',
        'assets/images/Home1.png',
        'assets/images/Home2.png',
      ],
      'comment': "Hôm nay cháu vui lắm",
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget _buildCustomTitle(double fontSize) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: widget.groupAvatar != null
              ? AssetImage(widget.groupAvatar!)
              : const AssetImage('assets/images/default_group_avatar.png'),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: const BoxConstraints(
                maxWidth: 150,
              ), // Giới hạn width
              child: Text(
                widget.groupName ?? 'Nhóm gia đình',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                ),
                overflow: TextOverflow.ellipsis, // Cắt text nếu quá dài
                maxLines: 1, // Giới hạn 1 dòng
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.groupMembers != null
                  ? '${widget.groupMembers} thành viên'
                  : '0 thành viên',
              style: TextStyle(
                color: AppColors.textPrimary.withValues(alpha: 0.9),
                fontSize: fontSize - 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = DeviceSize.getResponsiveFontSize(screenWidth);
    final padding = DeviceSize.getResponsivePadding(screenWidth);
    final imageSize = DeviceSize.getResponsiveImage(screenWidth);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.teal,
            leading: Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(
                    0.2,
                  ), // Background nhẹ
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: _buildCustomTitle(fontSize),
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
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  const snackBar = SnackBar(
                    content: Text('Tính năng đang phát triển'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(16),
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(8),
                      ),
                    ),
                  );
                },
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.navBackground.withValues(
                    alpha: 0.2,
                  ), // Background nhẹ
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final blog = familyGroups[index];
                return Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: widget.groupAvatar != null
                                ? AssetImage(widget.groupAvatar!)
                                : const AssetImage(
                                    'assets/images/default_group_avatar.png',
                                  ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    blog['name'] ?? 'Vô danh',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    margin: const EdgeInsets.all(4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.teal.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      blog['pet'] ?? 'Pet',
                                      style: TextStyle(
                                        color: Colors.teal.shade700,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 2),
                              Text(
                                blog['postTime'] ?? '6 phút trước',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final images = blog['image'] as List<String>;
                            final crossAxisCount = images.length >= 3
                                ? 3
                                : images.length;
                            final itemWidth =
                                (constraints.maxWidth -
                                    (crossAxisCount - 1) * 6) /
                                crossAxisCount;

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 6,
                                    mainAxisSpacing: 6,
                                    childAspectRatio:
                                        1.2, // Điều chỉnh tỷ lệ ở đây
                                  ),
                              itemCount: images.length,
                              itemBuilder: (context, imageIndex) {
                                final imgPath = images[imageIndex];
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withValues(
                                          alpha: 0.2,
                                        ),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      imgPath,
                                      fit: BoxFit
                                          .scaleDown, // scale nhỏ và fit content vùng chứa
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey.shade200,
                                              child: const Icon(
                                                Icons.broken_image,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 12),
                          Icon(
                            Icons.comment,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            blog['comment'] ?? 'No comments',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }, childCount: familyGroups.length),
            ),
          ),
        ],
      ),
    );
  }
}
