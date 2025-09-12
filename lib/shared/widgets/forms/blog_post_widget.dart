import 'package:flutter/material.dart';
import 'package:myapp/shared/model/blog.dart';
import 'package:myapp/shared/widgets/common/box_container.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/core/utils/image_cache.dart';

class BlogPostWidget extends StatelessWidget {
  final Blog blog;
  final Function(Blog)? onEditPressed;
  final Function(Blog)? onDeletePressed;
  final String currentUserId;

  const BlogPostWidget({
    super.key,
    required this.blog,
    this.onEditPressed,
    this.onDeletePressed,
    required this.currentUserId,
  });

  List<String> _getImageList(dynamic imgUrls) {
    if (imgUrls == null) return [];

    if (imgUrls is List<ImgUrl>) {
      return imgUrls.map((imgUrl) => imgUrl.url).toList();
    }

    if (imgUrls is List) {
      return imgUrls.map((item) => item['url'] as String).toList();
    }

    if (imgUrls is String && imgUrls.isNotEmpty) {
      return imgUrls.split(',').where((url) => url.isNotEmpty).toList();
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final images = _getImageList(blog.imgUrls);

    return BoxContainerShadow.blogCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar and name
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
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
                            blog.account.fullName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Pet tag
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
                                color: Colors.teal.withValues(alpha: 0.3),
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
                                blog.pets.petName,
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
                          '6 phút trước',
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
              // Edit/Delete menu
              if (blog.account.accountId == currentUserId)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit' && onEditPressed != null) {
                      onEditPressed!(blog);
                    } else if (value == 'delete' && onDeletePressed != null) {
                      onDeletePressed!(blog);
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Chỉnh sửa'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Xóa'),
                        ],
                      ),
                    ),
                  ],
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
            ],
          ),

          // Images grid
          if (images.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(15),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = images.length >= 3 ? 3 : images.length;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.teal.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withValues(alpha: 0.2),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
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
            ),

          // Description
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
  }
}
