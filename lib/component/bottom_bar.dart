// lib/widgets/bottom_bar.dart
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomBar({super.key, required this.currentIndex, required this.onTap});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: StylishBottomBar(
        option: AnimatedBarOptions(
          iconSize: 32,
          barAnimation: BarAnimation.liquid,
          iconStyle: IconStyle.animated,
          opacity: 0.85,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.home, color: Colors.white, size: 24),
            ),
            selectedColor: const Color(0xFF4A90E2),
            unSelectedColor: Colors.grey.shade400,
            title: const Text(
              'Trang chủ',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
          BottomBarItem(
            icon: const Icon(Icons.shopping_bag_outlined),
            selectedIcon: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF50C878), Color(0xFF3BA55C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shopping_bag,
                color: Colors.white,
                size: 24,
              ),
            ),
            selectedColor: const Color(0xFF50C878),
            unSelectedColor: Colors.grey.shade400,
            title: const Text(
              'Mua sắm',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
          BottomBarItem(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF4757), Color(0xFFFF3742)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4757).withValues(alpha: 0.4),
                    spreadRadius: 0,
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.psychology_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
            selectedIcon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF4757), Color(0xFFFF6B7A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4757).withValues(alpha: 0.6),
                    spreadRadius: 2,
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 22,
              ),
            ),
            selectedColor: const Color(0xFFFF4757),
            unSelectedColor: Colors.grey.shade400,
            title: const Text(
              'AI',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
          BottomBarItem(
            icon: const Icon(Icons.family_restroom_outlined),
            selectedIcon: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD93D), Color(0xFFFFBF00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.family_restroom,
                color: Colors.white,
                size: 24,
              ),
            ),
            selectedColor: const Color(0xFFFFD93D),
            unSelectedColor: Colors.grey.shade400,
            title: const Text(
              'Gia đình',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
          BottomBarItem(
            icon: const Icon(Icons.person_outlined),
            selectedIcon: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 24),
            ),
            selectedColor: const Color(0xFF9B59B6),
            unSelectedColor: Colors.grey.shade400,
            title: const Text(
              'Cá nhân',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        currentIndex: widget.currentIndex,
        notchStyle: NotchStyle.circle,
        onTap: (index) {
          HapticFeedback.lightImpact();
          widget.onTap(index);
        },
        backgroundColor: Colors.white,
        elevation: 0,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
    );
  }
}
