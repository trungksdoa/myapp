import 'package:flutter/material.dart';
import 'package:myapp/core/utils/device_size.dart';

import 'package:myapp/widget/group/group_app_bar.dart';

class BlogCreate extends StatefulWidget {
  const BlogCreate({super.key});

  @override
  State<BlogCreate> createState() => _BlogCreateState();
}

class _BlogCreateState extends State<BlogCreate> {
  // print(widget.groupAvatar);
  final List<Map<String, dynamic>> familyGroups = [
    {'id': '1', 'name': 'Milu'},
    {'id': '2', 'name': 'Lulu'},
    {'id': '3', 'name': 'Sakura'},
    {'id': '4', 'name': 'Dodo'},
    {'id': '5', 'name': 'Lufy'},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = DeviceSize.getResponsiveFontSize(screenWidth);
    final padding = DeviceSize.getResponsivePadding(screenWidth);
    final imageSize = DeviceSize.getResponsiveImage(screenWidth);
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: 'Tạo bài viết',
            isUseTextButton: true,
            saveButtonText: 'Đăng',
            onSave: () {
              // Handle post creation logic here
            },
            onReset: () {
              // Handle reset logic here
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                'Chức năng đang được phát triển...',
                style: TextStyle(fontSize: fontSize, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
