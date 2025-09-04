import 'package:flutter/material.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/performance_monitor.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/widget/boxContainer.dart';
import 'package:myapp/model/models.dart';
import 'package:myapp/core/utils/image_cache.dart';

class FamilyBlog extends StatefulWidget {
  final String? groupId;
  final String? groupName;
  final String? groupAvatar;
  final String? groupSize;

  const FamilyBlog({
    super.key,
    this.groupId,
    this.groupName,
    this.groupAvatar,
    this.groupSize,
  });

  List<GroupMember> get members {
    List<GroupMember> allMembers = [];
    for (int groupId = 1; groupId <= 4; groupId++) {
      if (groupId == 4) continue; // Group cuối (4) không có members
      for (int i = 1; i <= 5; i++) {
        allMembers.add(
          GroupMember(
            id: (groupId - 1) * 5 + i,
            accountId: 'user${(groupId - 1) * 5 + i}',
            groupId: groupId,
          ),
        );
      }
    }
    return allMembers;
  }

  @override
  State<FamilyBlog> createState() => _FamilyBlogState();
}

class _FamilyBlogState extends State<FamilyBlog> {
  // Mock data using Blog model
  final List<Blog> familyBlogs = [
    Blog(
      id: 1,
      description: "Cháu lì lắm",
      imgUrls:
          "assets/images/Home1.png,assets/images/Home2.png,assets/images/Home3.png",
      account: Account(
        accountId: 'user1',
        fullName: 'Huỳnh Gia Bảo',
        imgUrl: 'assets/images/home1.png',
      ),
      pets: Pet(
        petId: 1,
        accountId: 'user1',
        petName: 'Tini',
        dateOfBirth: DateTime(2020, 5, 20),
        petImage: 'assets/images/pet1.png',
        petType: 'Dog',
        size: 'Small',
        gender: 'Female',
      ),
    ),
    Blog(
      id: 2,
      description: "Cháu biết ăn lắm",
      imgUrls:
          "assets/images/Home4.png,assets/images/Home5.png,assets/images/Home1.png",
      account: Account(
        accountId: 'user2',
        fullName: 'Nguyễn Thị Thùy Dương',
        imgUrl: 'assets/images/home2.png',
      ),
      pets: Pet(
        petId: 2,
        accountId: 'user2',
        petName: 'Lulu',
        dateOfBirth: DateTime(2019, 3, 15),
        petImage: 'assets/images/pet2.png',
        petType: 'Cat',
        size: 'Medium',
        gender: 'Male',
      ),
    ),
    Blog(
      id: 3,
      description: "Hôm nay cháu vui lắm",
      imgUrls:
          "assets/images/Home4.png,assets/images/Home5.png,assets/images/Home1.png",
      account: Account(
        accountId: 'user3',
        fullName: 'Trần Minh Tuấn',
        imgUrl: 'assets/images/home3.png',
      ),
      pets: Pet(
        petId: 3,
        accountId: 'user3',
        petName: 'Milo',
        dateOfBirth: DateTime(2021, 7, 10),
        petImage: 'assets/images/pet3.png',
        petType: 'Dog',
        size: 'Large',
        gender: 'Male',
      ),
    ),
    Blog(
      id: 4,
      description: "Hôm nay cháu vui lắm",
      imgUrls:
          "assets/images/Home5.png,assets/images/Home1.png,assets/images/Home2.png",
      account: Account(
        accountId: 'user4',
        fullName: 'Lê Thị Mỹ Linh',
        imgUrl: 'assets/images/home4.png',
      ),
      pets: Pet(
        petId: 4,
        accountId: 'user4',
        petName: 'Mimi',
        dateOfBirth: DateTime(2018, 12, 5),
        petImage: 'assets/images/pet4.png',
        petType: 'Cat',
        size: 'Small',
        gender: 'Female',
      ),
    ),
    Blog(
      id: 5,
      description: "Hôm nay cháu vui lắm",
      imgUrls:
          "assets/images/Home5.png,assets/images/Home1.png,assets/images/Home2.png",
      account: Account(
        accountId: 'user5',
        fullName: 'Nguyễn Văn Nam',
        imgUrl: 'assets/images/home5.png',
      ),
      pets: Pet(
        petId: 5,
        accountId: 'user5',
        petName: 'Tom',
        dateOfBirth: DateTime(2022, 1, 30),
        petImage: 'assets/images/pet5.png',
        petType: 'Dog',
        size: 'Medium',
        gender: 'Male',
      ),
    ),
  ];

  // Helper method to get images from imgUrls
  List<String> getImageList(String imgUrls) {
    if (imgUrls.isEmpty) return [];
    return imgUrls.split(',').where((url) => url.isNotEmpty).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildCustomTitle(double fontSize) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Kiểm tra trạng thái collapsed/expanded dựa vào constraint
        final bool isCollapsed = constraints.maxHeight <= 56;

        return Row(
          children: [
            CircleAvatar(
              radius: isCollapsed ? 18 : 20, // Tăng từ 16 lên 18
              backgroundImage: widget.groupAvatar != null
                  ? AssetImage(widget.groupAvatar!)
                  : const AssetImage('assets/images/default_group_avatar.png'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: isCollapsed ? 140 : 150, // Tăng từ 120 lên 140
                    ),
                    child: Text(
                      widget.groupName ?? 'Nhóm gia đình',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: isCollapsed ? fontSize - 1 : fontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  // Sửa lại phần này
                  const SizedBox(height: 2),
                  Text(
                    widget.groupSize != null
                        ? '${widget.groupSize} thành viên'
                        : '0 thành viên',
                    style: TextStyle(
                      color: AppColors.textPrimary.withValues(alpha: 0.9),
                      fontSize: fontSize - 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.start('FamilyBlog build');

    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = DeviceSize.getResponsiveFontSize(screenWidth);

    final scaffoldWidget = Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80.0,
            floating: false,
            pinned: true,
            clipBehavior: Clip.antiAlias,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
              onPressed: () => Navigator.of(context).pop(),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 1,
                padding: const EdgeInsets.all(
                  8,
                ), // Thêm padding để fit khi collapsed
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: _buildCustomTitle(fontSize),
              background: Container(
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ),
            actions: [
              PopupMenuButton(
                borderRadius: BorderRadius.circular(12),
                onSelected: (value) {
                  NavigateHelper.goToSettingGroup(context, value.toString());
                },
                itemBuilder: (BuildContext bc) {
                  return const [
                    PopupMenuItem(
                      value: 'group-settings',
                      child: Text("Cài đặt"), // child phải ở cuối
                    ),
                  ];
                },
                clipBehavior: Clip.antiAlias,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(Icons.more_vert, color: Colors.black54, size: 24),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final blog = familyBlogs[index];
                final images = getImageList(blog.imgUrls);
                String userName;
                try {
                  userName = blog.account.fullName;
                } catch (e) {
                  userName = 'Unknown User';
                }
                String petName;
                try {
                  petName = blog.pets.petName.isNotEmpty
                      ? blog.pets.petName
                      : 'Anonymous Pet';
                } catch (e) {
                  petName = 'Anonymous Pet';
                }

                return BoxContainerShadow.blogCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(12),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: widget.groupAvatar != null
                                  ? AssetImage(widget.groupAvatar!)
                                  : const AssetImage(
                                      'assets/images/default_group_avatar.png',
                                    ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        userName,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      margin: const EdgeInsets.all(4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.teal.shade100,
                                            Colors.teal.shade200,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.teal.shade400,
                                          width: 1.2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.teal.withValues(
                                              alpha: 0.3,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.pets,
                                            size: 12,
                                            color: Colors.teal.shade800,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            petName,
                                            style: TextStyle(
                                              color: Colors.teal.shade800,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 12,
                                      color: Colors.teal.shade400,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '6 phút trước', // You can make this dynamic later
                                      style: TextStyle(
                                        color: Colors.teal.shade600,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      images.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.all(15),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final crossAxisCount = images.length >= 3
                                      ? 3
                                      : images.length;

                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: crossAxisCount,
                                          crossAxisSpacing: 6,
                                          mainAxisSpacing: 6,
                                          childAspectRatio: 1.2,
                                        ),
                                    itemCount: images.length,
                                    itemBuilder: (context, imageIndex) {
                                      final imgPath = images[imageIndex];
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.teal.withValues(
                                              alpha: 0.3,
                                            ),
                                            width: 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.teal.withValues(
                                                alpha: 0.2,
                                              ),
                                              spreadRadius: 1,
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          // filepath: lib/screens/family_blog.dart
                                          child: CachedImage(
                                            assetPath: imgPath,
                                            fit: BoxFit.scaleDown,
                                            errorWidget: Container(
                                              color: Colors.grey.shade200,
                                              child: const Icon(
                                                Icons.broken_image,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                      BoxContainerShadow.comment(
                        child: Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 16,
                              color: Colors.teal.shade600,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                blog.description,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }, childCount: familyBlogs.length),
            ),
          ),
          // Thay thế SizedBox bằng SliverToBoxAdapter
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigate(context);
        },
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.edit, size: 24),
      ),
    );

    PerformanceMonitor.stop('FamilyBlog build');
    return scaffoldWidget;
  }

  void _navigate(BuildContext context) {
    NavigateHelper.goToBlogCreate(context);
  }
}
