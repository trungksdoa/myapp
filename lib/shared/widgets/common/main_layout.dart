import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/shared/widgets/common/app_bar.dart';

// import 'app_bar.dart';
import 'bottom_bar.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(), // Sử dụng AppBar chung
      body: Container(
        color: Colors.grey[100],
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top * 0.25,
        ),
        child: navigationShell,
      ),
      bottomNavigationBar: SizedBox(
        height:
            kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom,
        child: BottomBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => _goBranch(context, index),
        ),
      ),
    );
  }

  void _goBranch(BuildContext context, int index) {
    // Define the paths for each branch
    const branchPaths = ['/home', '/shop', '/personal'];

    // Use context.go() to clear the entire stack and navigate to the branch's initial route
    context.go(branchPaths[index]);
  }
}
