// lib/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/component/main_layout.dart';
import 'package:myapp/screens/chat_box.dart';
import 'package:myapp/screens/group.dart';
import 'package:myapp/screens/personal.dart';
import 'package:myapp/screens/shop_screen.dart';
import 'package:myapp/screens/home.dart';
import 'package:myapp/screens/group_create.dart';
import 'package:myapp/screens/family_blog.dart';
import 'package:myapp/screens/chat_screen.dart';

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
                routes: [
                  // Sub-routes cho AI chat
                  GoRoute(
                    path: '/chat',
                    name: 'chat-screen',
                    builder: (context, state) {
                      final initialMessage =
                          state.uri.queryParameters['message'];
                      final petName = state.uri.queryParameters['petName'];
                      return ChatScreen(
                        initialMessage: initialMessage,
                        petName: petName,
                      );
                    },
                  ),
                ],
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
                routes: [
                  // Sub-routes cho family branch
                  GoRoute(
                    path: '/create',
                    name: 'group-create',
                    builder: (context, state) => const GroupCreate(),
                  ),
                  GoRoute(
                    path: '/blog/home',
                    name: 'family-blog',
                    builder: (context, state) {
                      final groupId = state.uri.queryParameters['groupId'];
                      final groupName = state.uri.queryParameters['groupName'];
                      final groupMembers =
                          state.uri.queryParameters['groupMembers'];
                      final groupAvatar =
                          state.uri.queryParameters['groupAvatar'];
                      return FamilyBlog(
                        groupId: groupId,
                        groupName: groupName,
                        groupMembers: groupMembers,
                        groupAvatar: groupAvatar,
                      );
                    },
                  ),
                ],
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
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/group-create-fullscreen',
        name: 'group-create-fullscreen',
        builder: (context, state) => const GroupCreate(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/chat-fullscreen',
        name: 'chat-fullscreen',
        builder: (context, state) {
          final initialMessage = state.uri.queryParameters['message'];
          final petName = state.uri.queryParameters['petName'];
          return ChatScreen(initialMessage: initialMessage, petName: petName);
        },
      ),
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

  // =====================================
  // NAVBAR NAVIGATION HELPERS
  // =====================================
  static void goToHome(BuildContext context) => context.go('/home');
  static void goToShop(BuildContext context) => context.go('/shop');
  static void gotoAI(BuildContext context) => context.go('/ai');
  static void goToFamily(BuildContext context) => context.go('/family');
  static void goToPersonal(BuildContext context) => context.go('/personal');

  static void goToGroupCreate(BuildContext context) {
    context.go('/family/create');
  }

  static void goToGroupCreateFullscreen(BuildContext context) {
    context.go('/group-create-fullscreen');
  }

  static void goToFamilyBlog(
    BuildContext context, {
    String? groupId,
    String? groupName,
    String? groupMembers,
    String? groupAvatar,
  }) {
    final params = <String, String>{};
    if (groupId != null) params['groupId'] = groupId;
    if (groupName != null) params['groupName'] = groupName;
    if (groupMembers != null) params['groupMembers'] = groupMembers;
    if (groupAvatar != null) params['groupAvatar'] = groupAvatar;
    context.goNamed('family-blog', queryParameters: params);
  }

  static void goToChat(
    BuildContext context, {
    String? message,
    String? petName,
  }) {
    final params = <String, String>{};
    if (message != null) params['message'] = message;
    if (petName != null) params['petName'] = petName;

    context.goNamed('chat-screen', queryParameters: params);
  }

  static void goToChatFullscreen(
    BuildContext context, {
    String? message,
    String? petName,
  }) {
    final params = <String, String>{};
    if (message != null) params['message'] = message;
    if (petName != null) params['petName'] = petName;

    context.goNamed('chat-fullscreen', queryParameters: params);
  }

  // =====================================
  // GENERAL NAVIGATION HELPERS
  // =====================================

  /// Push một page mới lên stack (có thể back)
  static void push(BuildContext context, String path) {
    context.push(path);
  }

  /// Push với named route
  static void pushNamed(
    BuildContext context,
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    context.pushNamed(
      name,
      pathParameters: pathParameters ?? {},
      queryParameters: queryParameters ?? {},
    );
  }

  /// Replace current route (không thể back)
  static void replace(BuildContext context, String path) {
    context.pushReplacement(path);
  }

  /// Replace với named route
  static void replaceNamed(
    BuildContext context,
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    context.pushReplacementNamed(
      name,
      pathParameters: pathParameters ?? {},
      queryParameters: queryParameters ?? {},
    );
  }

  /// Go to route (clear stack)
  static void go(BuildContext context, String path) {
    context.go(path);
  }

  /// Go với named route
  static void goNamed(
    BuildContext context,
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    context.goNamed(
      name,
      pathParameters: pathParameters ?? {},
      queryParameters: queryParameters ?? {},
    );
  }

  /// Back về page trước
  static void pop(BuildContext context, [dynamic result]) {
    if (context.canPop()) {
      context.pop(result);
    }
  }

  /// Kiểm tra có thể pop không
  static bool canPop(BuildContext context) {
    return context.canPop();
  }

  // =====================================
  // AUTHENTICATION NAVIGATION
  // =====================================

  /// Navigate sau khi login thành công
  static void navigateAfterLogin(BuildContext context, {String? redirectPath}) {
    if (redirectPath != null) {
      context.go(redirectPath);
    } else {
      context.go('/home'); // Default về home
    }
  }

  /// Navigate đến login page
  static void navigateToLogin(BuildContext context, {String? fromPath}) {
    if (fromPath != null) {
      context.push('/login?from=$fromPath');
    } else {
      context.push('/login');
    }
  }

  /// Logout - clear tất cả và về login
  static void logout(BuildContext context) {
    context.go('/login');
  }

  // =====================================
  // MODAL/FULLSCREEN NAVIGATION
  // =====================================

  /// Show page as modal (fullscreen dialog)
  static Future<T?> showModal<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute<T>(builder: (context) => page, fullscreenDialog: true),
    );
  }

  /// Show bottom sheet modal
  static Future<T?> showBottomModal<T>(BuildContext context, Widget child) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => child,
    );
  }

  // =====================================
  // COMMON NAVIGATION PATTERNS
  // =====================================

  /// Navigate và clear toàn bộ stack
  static void navigateAndClearStack(BuildContext context, String path) {
    context.go(path);
  }

  /// Navigate đến page với parameters
  static void navigateWithParams(
    BuildContext context,
    String path,
    Map<String, dynamic> params,
  ) {
    final uri = Uri.parse(path);
    final newUri = uri.replace(
      queryParameters: params.map((k, v) => MapEntry(k, v.toString())),
    );
    context.go(newUri.toString());
  }

  /// Navigate với delay (ví dụ sau khi show dialog)
  static Future<void> navigateWithDelay(
    BuildContext context,
    String path, {
    Duration delay = const Duration(milliseconds: 500),
  }) async {
    await Future.delayed(delay);
    if (context.mounted) {
      context.go(path);
    }
  }

  /// Back multiple times
  static void popMultiple(BuildContext context, int times) {
    for (int i = 0; i < times && context.canPop(); i++) {
      context.pop();
    }
  }
}
