// lib/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/utils/logger_service.dart';
import 'package:myapp/features/personal/screen/account_profile.dart';
import 'package:myapp/features/personal/screen/change_password.dart';
import 'package:myapp/features/personal/screen/home.dart';
import 'package:myapp/features/cart/screen/cart_screen.dart';
import 'package:myapp/features/shop/screen/order_detail.dart';
import 'package:myapp/features/shop/screen/order_success.dart';
import 'package:myapp/features/shop/screen/service_order_screen.dart';
import 'package:myapp/features/shop/screen/shop_detail_screen.dart';
import 'package:myapp/features/shop/screen/shop_screen.dart';
import 'package:myapp/features/shop/screen/detail_product.dart';
import 'package:myapp/features/home/screen/home.dart';
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

      // Routes that require authentication. Keep product browsing and home open for anonymous users.
      final protectedRoutes = [
        '/cart',
        '/order',
        '/personal',
        '/shop/map', // keep map protected if you want to restrict it, otherwise remove
        // '/shop/products' removed so users can browse products without logging in
      ];

      if (!isAuthenticated &&
          !isLoggingIn &&
          !isOnSplash &&
          !state.matchedLocation.startsWith('/auth/register') &&
          !state.matchedLocation.startsWith('/auth/otp-verification') &&
          !state.matchedLocation.startsWith('/auth/forgot-password') &&
          !state.matchedLocation.startsWith('/auth/reset-password') &&
          protectedRoutes.any(
            (route) => state.matchedLocation.startsWith(route),
          )) {
        logger.d('Redirecting to login from ${state.matchedLocation}');
        // Preserve the original destination so we can return after login
        final original = state.fullPath ?? state.uri.path;
        final encoded = Uri.encodeComponent(original);
        return '/auth/login?from=$encoded';
      }

      if (isAuthenticated && isLoggingIn) {
        // If user successfully logged in and there is a 'from' param, go back there.
        final from = state.uri.queryParameters['from'];
        if (from != null && from.isNotEmpty) {
          try {
            final decoded = Uri.decodeComponent(from);
            return decoded;
          } catch (_) {
            return '/home';
          }
        }
        return '/home';
      }

      if (isAuthenticated && isOnSplash) {
        return '/home';
      }

      return null;
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
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: const ShopScreen(title: "shop"),
                    transitionDuration: const Duration(milliseconds: 300),
                    reverseTransitionDuration: const Duration(
                      milliseconds: 300,
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          // Slide from right to left (Shopee style)
                          const begin = Offset(
                            1.0,
                            0.0,
                          ); // Start from right edge
                          const end = Offset.zero; // End at center
                          const curve = Curves.easeOutCubic;

                          var tween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                  );
                },
                routes: [
                  GoRoute(
                    path: 'map',
                    name: 'shop-map',
                    builder: (context, state) => const ShopMap(),
                  ),

                  GoRoute(
                    path: 'products',
                    name: 'detail-product',
                    pageBuilder: (context, state) {
                      final params = state.extra as Map<String, dynamic>?;
                      final category = params?['category'];
                      final productId = params?['productId'];
                      print(params);
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: DetailProductScreen(
                          productId: productId,
                          category: category,
                        ),
                        transitionDuration: const Duration(milliseconds: 500),
                        reverseTransitionDuration: const Duration(
                          milliseconds: 300,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              // Slide from right to left for push, left to right for pop
                              return SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                child: SlideTransition(
                                  position:
                                      Tween<Offset>(
                                        begin: Offset.zero,
                                        end: const Offset(-1.0, 0.0),
                                      ).animate(
                                        CurvedAnimation(
                                          parent: secondaryAnimation,
                                          curve: Curves.easeOutCubic,
                                        ),
                                      ),
                                  child: child,
                                ),
                              );
                            },
                      );
                    },
                  ),

                  GoRoute(
                    path: 'services',
                    name: 'shop-services',
                    builder: (context, state) {
                      final params = state.extra as Map<String, dynamic>?;
                      final shopId = params?['shopId'];
                      return ShopDetailScreen(shopId: shopId);
                    },
                  ),

                  // GoRoute(
                  //   path: '/order',
                  //   name: 'order_screen',
                  //   pageBuilder: (context, state) {
                  //     final params = state.extra as Map<String, dynamic>?;
                  //     final directBuy = params?['directBuy'] as bool? ?? false;
                  //     final product = params?['product'];
                  //     final dateTime = params?['dateTime'] as String?;
                  //     logger.d('Order params: $params, product: $product');
                  //     return CustomTransitionPage(
                  //       key: state.pageKey,
                  //       child: ServiceOrderScreen(
                  //         directBuy: directBuy,
                  //         product: product,
                  //         datetime: dateTime,
                  //       ),
                  //       transitionDuration: const Duration(milliseconds: 300),
                  //       reverseTransitionDuration: const Duration(
                  //         milliseconds: 300,
                  //       ),
                  //       transitionsBuilder:
                  //           (context, animation, secondaryAnimation, child) {
                  //             // Slide from right to left (Shopee style)
                  //             const begin = Offset(
                  //               1.0,
                  //               0.0,
                  //             ); // Start from right edge
                  //             const end = Offset.zero; // End at center
                  //             const curve = Curves.easeOutCubic;

                  //             var tween = Tween(
                  //               begin: begin,
                  //               end: end,
                  //             ).chain(CurveTween(curve: curve));

                  //             return SlideTransition(
                  //               position: animation.drive(tween),
                  //               child: child,
                  //             );
                  //           },
                  //     );
                  //   },
                  // ),
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
                builder: (context, state) => const PersonalHomeWidget(),
                routes: [
                  // Sub-routes cho Personal - chỉ giữ lại account/profile
                  GoRoute(
                    path: 'accounts',
                    name: 'personal-account',
                    builder: (context, state) =>
                        const AccountProfileBodyWidget(),
                    routes: [
                      GoRoute(
                        path: 'change-password',
                        name: 'personal-account-change-password',
                        builder: (context, state) =>
                            const ChangePasswordBodyWidget(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/order-success',
        name: 'order-success',
        pageBuilder: (context, state) {
          final params = state.extra as Map<String, dynamic>?; // nhận extra
          final orderId = params?['orderId'] as String? ?? 'N/A';
          return CustomTransitionPage(
            key: state.pageKey,
            child: OrderSuccessScreen(orderId: orderId),
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeOutCubic;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/order-detail',
        name: 'order-detail',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          final orderId = extra?['orderId'] as String? ?? 'N/A';
          final isService = extra?['isService'] as bool? ?? false;

          return CustomTransitionPage(
            key: state.pageKey,
            child: OrderDetailScreen(orderId: orderId, isService: isService),
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeOutCubic;
                  final tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
      // Full Screen Routes (without bottom nav)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey, // Quan trọng!
        path: '/order',
        name: 'order_screen',
        pageBuilder: (context, state) {
          final params = state.extra as Map<String, dynamic>?;
          final directBuy = params?['directBuy'] as bool? ?? false;
          final product = params?['product'];
          final dateTime = params?['dateTime'] as String?;
          final note = params?['note'] as String?;
          logger.d('Order params: $params, product: $product');
          return CustomTransitionPage(
            key: state.pageKey,
            child: ServiceOrderScreen(
              directBuy: directBuy,
              product: product,
              datetime: dateTime,
              note: note,
            ),
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeOutCubic;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      // Cart Screen Route
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/cart',
        name: 'cart',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const CartScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeOutCubic;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
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
          // No redirect needed
          return null;
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
    ],
  );
}
