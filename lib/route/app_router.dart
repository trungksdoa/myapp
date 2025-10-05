// lib/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/utils/logger_service.dart';
import 'package:myapp/features/chat/screen/chat_box.dart';
import 'package:myapp/features/personal/screen/account_profile.dart';
import 'package:myapp/features/personal/screen/appintment_detail.dart';
import 'package:myapp/features/personal/screen/bank_link.dart';
import 'package:myapp/features/personal/screen/bank_selection.dart';
import 'package:myapp/features/personal/screen/bank_success.dart';
import 'package:myapp/features/personal/screen/bank_verify_otp.dart';
import 'package:myapp/features/personal/screen/change_password.dart';
import 'package:myapp/features/personal/screen/home.dart';
import 'package:myapp/features/personal/screen/notification_screen.dart';
import 'package:myapp/features/personal/screen/pet_personal.dart';
import 'package:myapp/features/personal/screen/pet_personal_form.dart';
import 'package:myapp/features/personal/screen/product_order.dart';
import 'package:myapp/features/personal/screen/services_order.dart';
import 'package:myapp/features/personal/screen/services_package.dart';
import 'package:myapp/features/shop/screen/detail_product.dart';
import 'package:myapp/features/family/screen/family_blog.dart';
import 'package:myapp/features/family/screen/group.dart';
import 'package:myapp/features/family/screen/group_setting.dart';
import 'package:myapp/features/family/screen/group_setting_members.dart';
import 'package:myapp/features/cart/screen/cart_screen.dart';
import 'package:myapp/features/shop/screen/order_detail.dart';
import 'package:myapp/features/shop/screen/order_success.dart';
import 'package:myapp/features/shop/screen/service_order_screen.dart';
import 'package:myapp/features/shop/screen/shop_detail_screen.dart';
import 'package:myapp/features/shop/screen/shop_product_screen.dart';
import 'package:myapp/features/shop/screen/shop_routing.dart';
import 'package:myapp/features/home/screen/home.dart';
import 'package:myapp/features/family/screen/group_create.dart';
import 'package:myapp/features/chat/screen/chat_screen.dart';
// Auth screens
import 'package:myapp/features/auth/screen/login.dart';
import 'package:myapp/features/auth/screen/register.dart';
import 'package:myapp/features/other/screen/registration_success.dart';
import 'package:myapp/features/auth/screen/forgot_password.dart';
import 'package:myapp/features/auth/screen/otp_verification.dart';
import 'package:myapp/features/other/screen/reset_password.dart';
import 'package:myapp/features/auth/screen/password_reset_success.dart';
import 'package:myapp/features/other/screen/splash_screen.dart';
// Services
import 'package:myapp/features/auth/service/auth_service.dart';
import 'package:myapp/features/shop/widgets/shop_map.dart';
import 'package:myapp/shared/widgets/common/main_layout.dart';
import 'package:myapp/shared/model/pet.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shopNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shop');
final _aiNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'ai');
final _familyNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'family');
final _personalNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'personal');

class AppRouter {
  // Use AuthService instance
  static final AuthService _authService = AuthService();
  static final logger = LoggerService.instance;

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) async {
      final isAuthenticated = await _authService.isAuthenticated();
      final isLoggingIn = state.matchedLocation.startsWith('/auth/login');
      final isOnSplash = state.matchedLocation == '/splash';

      // Routes that require authentication. Keep product browsing and home open for anonymous users.
      final protectedRoutes = [
        '/cart',
        '/order',
        '/personal',
        '/ai/chat',
        '/family',
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
                    child: const ShopRoutingScreen(),
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
                      return ShopServiceScreen(shopId: shopId);
                    },
                  ),

                  GoRoute(
                    path: 'products',
                    name: 'shop-products',
                    builder: (context, state) {
                      final params = state.extra as Map<String, dynamic>?;
                      final searchValue = params?['searchValue'] as String?;
                      return ShopProductScreen(
                        searchValue: searchValue,
                        title: '',
                      );
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
                builder: (context, state) => const PersonalHomeWidget(),
                routes: [
                  // Sub-routes cho Personal
                  GoRoute(
                    path: 'orders',
                    name: 'personal-orders-products',
                    builder: (context, state) => const OrdersBodyWidget(),
                  ),
                  GoRoute(
                    path: 'products',
                    name: 'personal-appointment-booking',
                    builder: (context, state) =>
                        const ServiceBookingBodyWidget(),
                    routes: [
                      GoRoute(
                        path: 'orders',
                        name: 'personal-appointment-detail',
                        builder: (context, state) =>
                            const AppointmentDetailsBodyWidget(),
                      ),
                    ],
                  ),
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

                  GoRoute(
                    path: 'service-packages',
                    name: 'personal-packages',
                    builder: (context, state) =>
                        const ServicePackagesBodyWidget(),
                    routes: [
                      GoRoute(
                        path: 'link-bank',
                        name: 'personal-packages-link-bank',
                        builder: (context, state) =>
                            const BankSelectionBodyWidget(),
                        routes: [
                          GoRoute(
                            path: 'link-bank-form',
                            name: 'personal-packages-link-bank-form',
                            builder: (context, state) =>
                                const BankAccountLinkingBodyWidget(
                                  bankName: 'Vietcombank',
                                ),
                            routes: [
                              GoRoute(
                                path: 'verify-otp',
                                name:
                                    'personal-packages-link-bank-form-verify-otp',
                                builder: (context, state) =>
                                    const OTPVerificationBodyWidget(),
                              ),

                              GoRoute(
                                path: 'verify-otp-success',
                                name:
                                    'personal-packages-link-bank-form-verify-otp-success',
                                builder: (context, state) =>
                                    const SuccessBodyWidget(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  //Router for personal pet , subrouter with add pet form , pet detail
                  GoRoute(
                    path: 'pets',
                    name: 'personal-pets',
                    builder: (context, state) =>
                        const PetsScreen(), // Replace with actual pet list screen
                    routes: [
                      GoRoute(
                        path: 'add',
                        name: 'personal-pets-add',
                        builder: (context, state) {
                          final arg = state.extra;
                          return PetFormScreen(pet: arg is Pet ? arg : null);
                        },
                      ),
                      // GoRoute(
                      //   path: 'detail',
                      //   name: 'personal-pets-detail',
                      //   builder: (context, state) {
                      //     final params = state.extra as Map<String, String>?;
                      //     final petId = params?['petId'];
                      //     return PetDetailCard(petId: petId);
                      //   },
                      // ),
                    ],
                  ),

                  //Router for personal notification
                  GoRoute(
                    path: 'notifications',
                    name: 'personal-notifications',
                    builder: (context, state) =>
                        const NotificationsScreen(), // Replace with actual notification screen
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
