// lib/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/component/main_layout.dart';
import 'package:myapp/screens/chat_box.dart';
import 'package:myapp/screens/group.dart';
import 'package:myapp/screens/personal.dart';

import 'package:myapp/screens/shop_screen.dart';
import '../screens/home.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shopNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shop');
final _aiNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'ai');
final _familyNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'family');
final _personalNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'personal');

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      // Main Shell Route with Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayout(navigationShell: navigationShell);
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const Home(title: "home"),
              ),
            ],
          ),

          // Shop Branch
          StatefulShellBranch(
            navigatorKey: _shopNavigatorKey,
            routes: [
              GoRoute(
                path: '/shop',
                name: 'shop',
                builder: (context, state) => const ShopScreen(title: "shop"),
              ),
            ],
          ),

          // AI Branch
          StatefulShellBranch(
            navigatorKey: _aiNavigatorKey,
            routes: [
              GoRoute(
                path: '/ai',
                name: 'ai',
                builder: (context, state) => const ChatBox(),
              ),
            ],
          ),

          // Family Branch
          StatefulShellBranch(
            navigatorKey: _familyNavigatorKey,
            routes: [
              GoRoute(
                path: '/family',
                name: 'family',
                builder: (context, state) => const GroupScreen(title: "group"),
              ),
            ],
          ),

          // Personal Branch
          StatefulShellBranch(
            navigatorKey: _personalNavigatorKey,
            routes: [
              GoRoute(
                path: '/personal',
                name: 'personal',
                builder: (context, state) =>
                    const PersonalScreen(title: "personal"),
              ),
            ],
          ),
        ],
      ),

      // Full Screen Routes (without bottom nav)
      // GoRoute(
      //   parentNavigatorKey: _rootNavigatorKey,
      //   path: '/login',
      //   name: 'login',
      //   builder: (context, state) => const LoginPage(),
      // ),
      // GoRoute(
      //   parentNavigatorKey: _rootNavigatorKey,
      //   path: '/onboarding',
      //   name: 'onboarding',
      //   builder: (context, state) => const OnboardingPage(),
      // ),
    ],
  );

  // Helper methods for navigation
  static void goToHome(BuildContext context) => context.go('/home');
  static void goToShop(BuildContext context) => context.go('/shop');
  static void gotoAI(BuildContext context) => context.go('/ai');
  static void goToFamily(BuildContext context) => context.go('/family');
  static void goToPersonal(BuildContext context) => context.go('/personal');
}
