// lib/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/utils/logger_service.dart';
import 'package:myapp/features/chat/screen/chat_box.dart';
import 'package:myapp/features/shop/screen/detail_product.dart';
import 'package:myapp/features/family/screen/family_blog.dart';
import 'package:myapp/features/family/screen/group.dart';
import 'package:myapp/features/family/screen/group_setting.dart';
import 'package:myapp/features/family/screen/group_setting_members.dart';
import 'package:myapp/features/personal/screen/personal.dart';
import 'package:myapp/features/shop/screen/shop_screen.dart';
import 'package:myapp/features/home/screen/home.dart';
import 'package:myapp/features/family/screen/group_create.dart';
import 'package:myapp/features/chat/screen/chat_screen.dart';
// Auth screens
import 'package:myapp/features/other/screen/login.dart';
import 'package:myapp/features/other/screen/register.dart';
import 'package:myapp/features/other/screen/registration_success.dart';
import 'package:myapp/features/other/screen/forgot_password.dart';
import 'package:myapp/features/other/screen/otp_verification.dart';
import 'package:myapp/features/other/screen/reset_password.dart';
import 'package:myapp/features/other/screen/password_reset_success.dart';
import 'package:myapp/features/other/screen/splash_screen.dart';
// Services
import 'package:myapp/service/auth_factory.dart';
import 'package:myapp/features/shop/widgets/shop_map.dart';
import 'package:myapp/shared/widgets/common/main_layout.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shopNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shop');
final _aiNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'ai');
final _familyNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'family');
final _personalNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'personal');

class AppRouter {
  // Use AuthFactory instead of direct AuthService instantiation
  static get _authService => AuthFactory.instance;
  static final logger = LoggerService.instance;

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = _authService.isAuthenticated;
      final isLoggingIn = state.matchedLocation.startsWith('/auth/login');
      final isOnSplash = state.matchedLocation == '/splash';

      if (!isAuthenticated &&
          !isLoggingIn &&
          !isOnSplash &&
          !state.matchedLocation.startsWith('/auth/register') &&
          !state.matchedLocation.startsWith('/auth/otp-verification') &&
          !state.matchedLocation.startsWith('/auth/forgot-password') &&
          !state.matchedLocation.startsWith('/auth/reset-password')) {
        logger.d('Redirecting to login from ${state.matchedLocation}');
        return '/auth/login';
      }

      if (isAuthenticated && isLoggingIn) {
        return '/home';
      }

      if (isAuthenticated && isOnSplash) {
        return '/home';
      }

      return state.fullPath;
    },
    routes: [
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
                routes: [
                  GoRoute(
                    path: 'map',
                    name: 'shop-map',
                    builder: (context, state) => const ShopMap(),
                  ),

                  GoRoute(
                    path: 'products/:id',
                    name: 'detail-product',
                    builder: (context, state) {
                      // logger.d(
                      //   'Building detail product with state: ${state.fullPath}',
                      // );
                      // final params = state.extra as Map<String, String>?;
                      final param = state.pathParameters['id'];
                      return DetailProductScreen(productId: param);
                    },
                  ),
                  // Sub-routes for shop can be added here
                ],
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
                    path: 'chat', // Bỏ dấu / → 'chat'
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
                path: '/family', // Parent
                name: 'family',
                builder: (context, state) => const GroupScreen(title: "group"),
                routes: [
                  GoRoute(
                    path: 'blog/home',
                    name: 'family-blog',
                    builder: (context, state) {
                      logger.d(
                        'Building FamilyBlog with state: ${state.fullPath}',
                      );
                      final params = state.extra as Map<String, String>?;

                      logger.d('Received params: $params');

                      return FamilyBlog(
                        groupId: params?['groupId'],
                        groupName: params?['groupName'],
                        groupAvatar: params?['groupAvatar'],
                        groupSize: params?['groupSize'],
                      );
                    },
                  ),
                  GoRoute(
                    path: 'create',
                    name: 'group-create',
                    builder: (context, state) => const GroupCreate(),
                  ),
                  GoRoute(
                    path: 'settings', // Bỏ dấu / → 'settings'
                    name: 'group-settings',
                    builder: (context, state) {
                      final params = state.extra as Map<String, String>?;
                      final groupId = params?['groupId'];
                      LoggerService.instance.d(
                        'Navigating to GroupSetting with groupId: $groupId',
                      );
                      return GroupSetting(groupId: groupId);
                    },
                    routes: [
                      GoRoute(
                        path: 'members',
                        name: 'group-setting-members',
                        builder: (context, state) {
                          final params = state.extra as Map<String, String>?;
                          final groupId = params?['groupId'];
                          return GroupSettingMembers(groupId: groupId);
                        },
                      ),
                    ],
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

      // Shop Branch
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      // Auth Routes
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/auth',
        redirect: (context, state) {
          // if (state.matchedLocation == '/auth') {
          //   return '/auth/login';
          // }
          return state.fullPath;
        },
        routes: [
          GoRoute(
            path: 'login',
            name: 'login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: 'register',
            name: 'register',
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: 'registration-success', // đã bỏ dấu / ở đầu
            name: 'registration-success',
            builder: (context, state) => const RegistrationSuccessScreen(),
          ),
          GoRoute(
            path: 'forgot-password', // đã bỏ dấu / ở đầu
            name: 'forgot-password',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
          GoRoute(
            path: 'otp-verification', // đã bỏ dấu / ở đầu
            name: 'otp-verification',
            builder: (context, state) {
              final email = state.uri.queryParameters['email'] ?? '';
              return OTPVerificationScreen(email: email);
            },
          ),
          GoRoute(
            path: 'reset-password', // đã bỏ dấu / ở đầu
            name: 'reset-password',
            builder: (context, state) => const ResetPasswordScreen(),
          ),
          GoRoute(
            path: 'password-reset-success', // đã bỏ dấu / ở đầu
            name: 'password-reset-success',
            builder: (context, state) => const PasswordResetSuccessScreen(),
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
    ],
  );
}
