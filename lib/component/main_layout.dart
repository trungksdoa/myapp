import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/component/app_bar.dart';
import 'package:myapp/component/bottom_bar.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(), // Sử dụng AppBar chung
      body: navigationShell,
      bottomNavigationBar: BottomBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _goBranch,
      ),
    );
  }

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // Navigate to initial location when tapping the same tab
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
