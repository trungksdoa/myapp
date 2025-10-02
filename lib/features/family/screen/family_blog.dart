import 'package:flutter/material.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/performance_monitor.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/features/family/screen/post_composer.dart';
import 'package:myapp/features/family/screen/edit_composer.dart';
import 'package:myapp/shared/model/models.dart';
import 'package:myapp/shared/widgets/forms/blog_post_widget.dart';

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

  @override
  State<FamilyBlog> createState() => _FamilyBlogState();
}

class _FamilyBlogState extends State<FamilyBlog> {
  // Filter state
  bool _showMyPostsOnly = false;

  // Mock current user ID (should be from auth service)
  final String _currentUserId = 'user1'; // Giả lập user hiện tại

  // Mock data using Blog model
  final List<Blog> familyBlogs = [
    Blog(
      id: 1,
      description: "Cháu lì lắm",
      imgUrls: [
        ImgUrl(fileId: 1, url: "assets/images/Home1.png"),
        ImgUrl(fileId: 2, url: "assets/images/Home2.png"),
        ImgUrl(fileId: 3, url: "assets/images/Home3.png"),
      ],
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
      imgUrls: [
        ImgUrl(fileId: 4, url: "assets/images/Home4.png"),
        ImgUrl(fileId: 5, url: "assets/images/Home5.png"),
        ImgUrl(fileId: 6, url: "assets/images/Home1.png"),
      ],
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
        petImage: 'assets/images/Home4.png',
        petType: 'Cat',
        size: 'Medium',
        gender: 'Male',
      ),
    ),
    Blog(
      id: 3,
      description: "Hôm nay cháu vui lắm",
      imgUrls: [
        ImgUrl(fileId: 7, url: "assets/images/Home4.png"),
        ImgUrl(fileId: 8, url: "assets/images/Home5.png"),
        ImgUrl(fileId: 9, url: "assets/images/Home1.png"),
      ],
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
        petImage: 'assets/images/home3.png',
        petType: 'Dog',
        size: 'Large',
        gender: 'Male',
      ),
    ),
    Blog(
      id: 4,
      description: "Hôm nay cháu vui lắm",
      imgUrls: [
        ImgUrl(fileId: 10, url: "assets/images/Home5.png"),
        ImgUrl(fileId: 11, url: "assets/images/Home1.png"),
        ImgUrl(fileId: 12, url: "assets/images/Home2.png"),
      ],
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
        petImage: 'assets/images/Home5.png',
        petType: 'Cat',
        size: 'Small',
        gender: 'Female',
      ),
    ),
    Blog(
      id: 5,
      description: "Hôm nay cháu vui lắm",
      imgUrls: [
        ImgUrl(fileId: 13, url: "assets/images/Home5.png"),
        ImgUrl(fileId: 14, url: "assets/images/Home1.png"),
        ImgUrl(fileId: 15, url: "assets/images/Home2.png"),
      ],
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
  List<String> getImageList(dynamic imgUrls) {
    if (imgUrls == null) return [];

    // Handle new format: List<ImgUrl>
    if (imgUrls is List<ImgUrl>) {
      return imgUrls.map((imgUrl) => imgUrl.url).toList();
    }

    // Handle List<Map<String, dynamic>> for backward compatibility
    if (imgUrls is List) {
      return imgUrls.map((item) => item['url'] as String).toList();
    }

    // Handle old format: String (for backward compatibility)
    if (imgUrls is String && imgUrls.isNotEmpty) {
      return imgUrls.split(',').where((url) => url.isNotEmpty).toList();
    }

    return [];
  }

  // Get filtered blogs based on current filter
  List<Blog> getFilteredBlogs() {
    if (_showMyPostsOnly) {
      return familyBlogs
          .where((blog) => blog.account.accountId == _currentUserId)
          .toList();
    }
    return familyBlogs;
  }

  // Toggle filter
  void _toggleFilter() {
    setState(() {
      _showMyPostsOnly = !_showMyPostsOnly;
    });
  }

  // Handle edit blog
  void _handleEditBlog(Blog blog) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: IntrinsicHeight(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: EditComposer(blogToEdit: blog),
            ),
          ),
        );
      },
    );
  }

  // Handle delete blog
  void _handleDeleteBlog(Blog blog) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Xóa bài viết',
            style: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Bạn có chắc chắn muốn xóa bài viết này không? Hành động này không thể hoàn tác.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Đã xóa bài viết của ${blog.account.fullName}',
                    ),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Xóa',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
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
                      _showMyPostsOnly
                          ? 'Bài viết của bạn'
                          : (widget.groupName ?? 'Nhóm gia đình'),
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
                    _showMyPostsOnly
                        ? '${getFilteredBlogs().length} bài viết của bạn'
                        : '${getFilteredBlogs().length} bài viết',
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
    final responsivePadding = DeviceSize.getResponsivePadding(screenWidth);

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
                padding: EdgeInsets.all(responsivePadding),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: _buildCustomTitle(fontSize),
              background: Container(
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ),
            actions: [
              // Filter button
              IconButton(
                icon: Icon(
                  _showMyPostsOnly ? Icons.person : Icons.group,
                  color: _showMyPostsOnly ? Colors.teal : Colors.black54,
                ),
                onPressed: _toggleFilter,
                tooltip: _showMyPostsOnly
                    ? 'Xem tất cả bài viết'
                    : 'Xem bài viết của tôi',
              ),
              PopupMenuButton(
                borderRadius: BorderRadius.circular(12),
                onSelected: (value) {
                  NavigateHelper.goToSettingGroup(
                    context,
                    value.toString(),
                    widget.groupId!,
                    widget.groupAvatar ?? '',
                  );
                },
                itemBuilder: (BuildContext bc) {
                  return const [
                    PopupMenuItem(
                      value: 'group-settings',
                      child: Text("Cài đặt"),
                    ),
                  ];
                },
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsivePadding * 2,
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.black54,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          // Post composer at the top of the list
          SliverToBoxAdapter(child: PostComposer()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final filteredBlogs = getFilteredBlogs();
                final blog = filteredBlogs[index];

                return BlogPostWidget(
                  blog: blog,
                  currentUserId: _currentUserId,
                  onEditPressed: _handleEditBlog,
                  onDeletePressed: _handleDeleteBlog,
                );
              }, childCount: getFilteredBlogs().length),
            ),
          ),
          // Thay thế SizedBox bằng SliverToBoxAdapter
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );

    PerformanceMonitor.stop('FamilyBlog build');
    return scaffoldWidget;
  }
}
