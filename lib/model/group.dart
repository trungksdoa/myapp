import 'groupMember.dart';
import 'blog.dart';

class Group {
  final int id;
  final String name;
  final int memberCount;
  final String imgUrl;
  final String createdById;
  final List<GroupMember> groupMembers;
  final List<Blog> groupBlogs;

  Group({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.imgUrl,
    required this.createdById,
    this.groupMembers = const [],
    this.groupBlogs = const [],
  });
}
