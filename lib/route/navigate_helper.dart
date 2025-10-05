// Navigator helper (regenerated) - primary navigation utilities
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/utils/logger_service.dart';
import 'package:myapp/shared/model/product.dart';
import 'package:myapp/features/auth/service/auth_service.dart';

class NavigateHelper {
  // =====================================
  // 🏠 MAIN NAVIGATION (Bottom Tab Navigation)
  // =====================================

  /// Navigate to Home screen (main dashboard)
  static void goToHome(BuildContext context) => context.go('/home');

  /// Navigate to Shop screen (product browsing)
  static void goToShop(BuildContext context) => context.go('/shop');

  /// Navigate to AI Chat screen (AI assistant)
  static void gotoAI(BuildContext context) => context.go('/ai');

  /// Navigate to Family screen (group management)
  static void goToFamily(BuildContext context) => context.go('/family');

  /// Navigate to Personal screen (user profile & settings)
  static void goToPersonal(BuildContext context) => context.go('/personal');

  // =====================================
  // 👨‍👩‍👧‍👦 FAMILY & GROUP NAVIGATION
  // =====================================

  /// Navigate to create new group screen
  static void goToGroupCreate(BuildContext context) {
    context.pushNamed('group-create');
  }

  /// Navigate to create group in fullscreen mode
  static void goToGroupCreateFullscreen(BuildContext context) {
    context.go('/group-create-fullscreen');
  }

  /// Navigate to family blog with group details
  static void goToFamilyBlog(
    BuildContext context, {
    String? groupId,
    String? groupName,
    String? groupSize,
    String? groupAvatar,
  }) {
    final params = <String, String>{};
    if (groupId != null) params['groupId'] = groupId;
    if (groupName != null) params['groupName'] = groupName;
    if (groupSize != null) params['groupSize'] = groupSize;
    if (groupAvatar != null) params['groupAvatar'] = groupAvatar;

    LoggerService.instance.d('Sending params: $params');
    context.pushNamed('family-blog', extra: params);
  }

  /// Navigate to group settings screen
  static void goToSettingGroup(
    BuildContext context,
    String viewName,
    String groupId,
    String avatar,
  ) {
    final params = <String, String>{};
    if (groupId.isNotEmpty) params['groupId'] = groupId;
    if (avatar.isNotEmpty) params['avatar'] = avatar;
    context.pushNamed(viewName, extra: params);
  }

  /// Navigate to group members management screen
  static void goToSettingGroupMembers(BuildContext context, String groupId) {
    final params = <String, String>{};
    if (groupId.isNotEmpty) params['groupId'] = groupId;
    context.pushNamed('group-setting-members', extra: params);
  }

  // =====================================
  // 💬 CHAT & COMMUNICATION NAVIGATION
  // =====================================

  /// Navigate to chat screen with optional initial message
  static void goToChat(
    BuildContext context, {
    String? message,
    String? petName,
  }) {
    final params = <String, String>{};
    if (message != null) params['message'] = message;
    if (petName != null) params['petName'] = petName;
    context.pushNamed('chat-screen', queryParameters: params);
  }

  /// Navigate to fullscreen chat mode
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
  // 🔐 AUTHENTICATION NAVIGATION
  // =====================================

  /// Navigate to login screen
  static void goToLogin(BuildContext context) {
    context.go('/auth/login');
  }

  /// Navigate to register screen
  static void goToRegister(BuildContext context) {
    context.go('/auth/register');
  }

  /// Navigate to registration success screen
  static void goToRegistrationSuccess(BuildContext context) {
    context.go('/auth/registration-success');
  }

  /// Navigate to forgot password screen
  static void goToForgotPassword(BuildContext context) {
    context.go('/auth/forgot-password');
  }

  /// Navigate to OTP verification screen with email
  static void goToOTPVerification(
    BuildContext context, {
    required String email,
  }) {
    context.go('/auth/otp-verification?email=$email');
  }

  /// Navigate to reset password screen
  static void goToResetPassword(BuildContext context) {
    context.go('/auth/reset-password');
  }

  /// Navigate to password reset success screen
  static void goToPasswordResetSuccess(BuildContext context) {
    context.go('/auth/password-reset-success');
  }

  /// Login and navigate to home (async operation)
  static Future<void> loginAndNavigateToHome(BuildContext context) async {
    final authService = AuthService();
    await authService.initialize();
    context.go('/home');
  }

  /// Logout and navigate to login
  static Future<void> logoutAndNavigateToLogin(BuildContext context) async {
    final authService = AuthService();
    await authService.logout();
    context.go('/auth/login');
  }

  /// Navigate after successful login with optional redirect
  static void navigateAfterLogin(BuildContext context, {String? redirectPath}) {
    if (redirectPath != null) {
      context.go(redirectPath);
    } else {
      context.go('/home');
    }
  }

  /// Navigate to login with return path
  static void navigateToLogin(BuildContext context, {String? fromPath}) {
    if (fromPath != null) {
      context.go('/auth/login?from=${Uri.encodeComponent(fromPath)}');
    } else {
      context.go('/auth/login');
    }
  }

  // =====================================
  // 👤 PERSONAL PROFILE NAVIGATION
  // =====================================

  /// Navigate to account profile screen
  static void goToAccountProfile(BuildContext context) {
    context.pushNamed('personal-account');
  }

  /// Navigate to change password screen
  static void goToChangePassword(BuildContext context) {
    context.pushNamed('personal-account-change-password');
  }

  // =====================================
  // 🏦 BANKING & PAYMENT NAVIGATION
  // =====================================

  /// Navigate to bank selection screen
  static void goToBankSelection(BuildContext context) {
    context.pushNamed('personal-bank-selection');
  }

  /// Navigate to bank account linking screen with bank name
  static void goToBankAccountLinking(BuildContext context, String bankName) {
    context.pushNamed('personal-bank-link', extra: {'bankName': bankName});
  }

  /// Navigate to OTP verification for bank linking
  static void goToBankOTPVerification(BuildContext context) {
    context.pushNamed('personal-bank-verify-otp');
  }

  /// Navigate to bank linking success screen
  static void goToBankSuccess(BuildContext context) {
    context.pushNamed('personal-bank-success');
  }

  // =====================================
  // 📦 ORDER MANAGEMENT NAVIGATION
  // =====================================

  /// Navigate to personal orders (products)
  static void goToPersonalOrders(BuildContext context) {
    context.pushNamed('personal-orders-products');
  }

  /// Navigate to personal service bookings
  static void goToPersonalServiceOrders(BuildContext context) {
    context.pushNamed('personal-orders-services');
  }

  /// Navigate to order history screen
  static void goToOrderHistory(BuildContext context) {
    context.pushNamed('personal-order-history');
  }

  /// Navigate to order tracking screen
  static void goToOrderTracking(BuildContext context, String orderId) {
    context.pushNamed('personal-order-tracking', extra: {'orderId': orderId});
  }

  // =====================================
  // 📅 APPOINTMENT MANAGEMENT NAVIGATION
  // =====================================

  /// Navigate to appointment booking screen
  static void goToAppointmentBooking(BuildContext context) {
    context.pushNamed('personal-appointment-booking');
  }

  /// Navigate to appointment calendar view
  static void goToAppointmentCalendar(BuildContext context) {
    context.pushNamed('personal-appointment-calendar');
  }

  /// Navigate to appointment detail screen
  static void goToAppointmentDetail(
    BuildContext context,
    String appointmentId,
  ) {
    context.pushNamed(
      'personal-appointment-detail',
      extra: {'appointmentId': appointmentId},
    );
  }

  // =====================================
  // 🐾 PET MANAGEMENT NAVIGATION
  // =====================================

  /// Navigate to pet list screen
  static void goToPetList(BuildContext context) {
    context.pushNamed('personal-pets');
  }

  /// Navigate to add new pet screen. If `pet` is passed, it will be
  /// forwarded as `extra` so the same form can be used for editing.
  static void goToAddPet(BuildContext context, {Object? pet}) {
    if (pet != null) {
      context.pushNamed('personal-pets-add', extra: pet);
    } else {
      context.pushNamed('personal-pets-add');
    }
  }

  /// Navigate to pet detail screen
  static void goToPetDetail(BuildContext context, String petId) {
    final Map<String, String> params = {};
    params['petId'] = petId;
    context.pushNamed('personal-pets-detail', extra: params);
  }

  // =====================================
  // ORDER SUCCESS NAVIGATION
  // =====================================
  static void goToOrderSuccess(BuildContext context, String orderId) {
    context.goNamed('order-success', extra: {'orderId': orderId});
  }

  // =============================
  // ORDER NAVIGATION
  // =============================
  static void goToOrderDetail(
    BuildContext context, {
    required String orderId,
    bool isService = false,
  }) {
    context.pushNamed(
      'order-detail',
      extra: {'orderId': orderId, 'isService': isService},
    );
  }

  // /// Navigate to pet health records screen
  // static void goToPetHealthRecords(BuildContext context, String petId) {
  //   context.pushNamed('personal-pet-health', extra: {'petId': petId});
  // }

  // =====================================
  // 🛍️ SERVICE MANAGEMENT NAVIGATION
  // =====================================

  /// Navigate to service selection screen
  static void goToServiceSelection(BuildContext context) {
    context.pushNamed('personal-service-selection');
  }

  /// Navigate to service detail screen
  static void goToServiceDetail(BuildContext context, String serviceId) {
    context.pushNamed(
      'personal-service-detail',
      extra: {'serviceId': serviceId},
    );
  }

  /// Navigate to services package screen
  static void goToServicesPackage(BuildContext context) {
    context.pushNamed('personal-packages');
  }

  // =====================================
  // 🔔 NOTIFICATION NAVIGATION
  // =====================================

  /// Navigate to notifications screen
  static void goToNotifications(BuildContext context) {
    context.pushNamed('personal-notifications');
  }

  /// Navigate to notification settings screen
  static void goToNotificationSettings(BuildContext context) {
    context.pushNamed('personal-notification-settings');
  }

  // =====================================
  // 🛒 SHOPPING NAVIGATION
  // =====================================

  /// Navigate to shop map screen
  static void goToShopMap(BuildContext context) {
    context.pushNamed('shop-map');
  }

  /// Navigate to product detail screen
  static void goToDetailProduct(
    BuildContext context,
    String productId, {
    String? category,
  }) {
    final params = <String, String>{};
    if (category == null) return;
    if (productId.isEmpty) return;

    params['category'] = category.toString();
    params['productId'] = productId;
    context.pushNamed('detail-product', extra: params);
  }

  /// Navigate to shop detail screen
  static void goToShopDetailScreen(BuildContext context, {String? shopId}) {
    final params = <String, String>{};
    if (shopId != null) params['shopId'] = shopId;
    context.pushNamed('shop-services', extra: params);
  }

  /// Navigate to order screen with product details
  static void goToOrderScreen(
    BuildContext context, {
    bool directBuy = false,
    Product? product,
    String? dateTime,
    String? note,
  }) {
    final params = <String, dynamic>{};
    if (product != null) params['product'] = product;
    params['directBuy'] = directBuy;
    params['dateTime'] = dateTime;
    if (note != null) params['note'] = note;
    context.pushNamed('order_screen', extra: params);
  }

  /// Navigate to shopping cart screen
  static void goToCart(BuildContext context) {
    context.pushNamed('cart');
  }

  /// Navigate to shop services screen
  static void goToShopServices(BuildContext context) {
    context.pushNamed('shop-services');
  }

  /// Navigate to shop products screen
  static void goToShopProducts(BuildContext context) {
    context.pushNamed('shop-products');
  }

  // =====================================
  // 🔄 GENERAL NAVIGATION UTILITIES
  // =====================================

  /// Push a new page onto the stack (can go back)
  static void push(BuildContext context, String path) {
    context.push(path);
  }

  /// Push with named route
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

  /// Replace current route (cannot go back)
  static void replace(BuildContext context, String path) {
    context.pushReplacement(path);
  }

  /// Replace with named route
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

  /// Go to route and clear navigation stack
  static void go(BuildContext context, String path) {
    context.go(path);
  }

  /// Go with named route
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

  /// Go back to previous screen
  static void pop(BuildContext context, [dynamic result]) {
    if (context.canPop()) {
      context.pop(result);
    }
  }

  /// Check if can navigate back
  static bool canPop(BuildContext context) {
    return context.canPop();
  }

  // =====================================
  // 🎯 ADVANCED NAVIGATION FEATURES
  // =====================================

  /// Navigate with confirmation dialog
  static Future<void> navigateWithConfirmation(
    BuildContext context,
    String routeName, {
    String? title,
    String? message,
    String? confirmText,
    String? cancelText,
    Map<String, dynamic>? extra,
  }) async {
    final shouldNavigate = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? 'Xác nhận'),
        content: Text(message ?? 'Bạn có muốn tiếp tục?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText ?? 'Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText ?? 'Xác nhận'),
          ),
        ],
      ),
    );

    if (shouldNavigate == true && context.mounted) {
      if (extra != null) {
        context.pushNamed(routeName, extra: extra);
      } else {
        context.pushNamed(routeName);
      }
    }
  }

  /// Navigate with loading indicator for async operations
  static Future<void> navigateWithLoading(
    BuildContext context,
    Future<void> Function() asyncOperation,
    String successRoute, {
    String? loadingMessage,
    String? errorMessage,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(loadingMessage ?? 'Đang xử lý...'),
          ],
        ),
      ),
    );

    try {
      await asyncOperation();
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        context.pushNamed(successRoute);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage ?? 'Có lỗi xảy ra: $e')),
        );
      }
    }
  }

  /// Safe navigate with comprehensive error handling
  static void safeNavigate(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? extra,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    try {
      context.pushNamed(
        routeName,
        extra: extra,
        pathParameters: pathParameters ?? {},
        queryParameters: queryParameters ?? {},
      );
    } catch (e) {
      LoggerService.instance.e('Navigation error to $routeName: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Không thể điều hướng: $e')));
      }
    }
  }

  /// Navigate back with result data
  static void popWithResult<T>(BuildContext context, T result) {
    if (context.canPop()) {
      context.pop(result);
    }
  }

  /// Navigate back multiple levels
  static void popToLevel(BuildContext context, int levels) {
    for (int i = 0; i < levels && context.canPop(); i++) {
      context.pop();
    }
  }

  /// Navigate to root of current navigation branch
  static void popToRoot(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  // =====================================
  // 🛠️ COMMON NAVIGATION PATTERNS
  // =====================================

  /// Navigate and clear entire navigation stack
  static void navigateAndClearStack(BuildContext context, String path) {
    context.go(path);
  }

  /// Navigate to page with query parameters
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

  /// Navigate with delay (useful after showing dialogs)
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

  /// Go back multiple times
  static void popMultiple(BuildContext context, int times) {
    for (int i = 0; i < times && context.canPop(); i++) {
      context.pop();
    }
  }

  // =====================================
  // 🎨 MODAL & OVERLAY NAVIGATION
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
  // 🔍 UTILITY METHODS
  // =====================================

  /// Check if user is authenticated (requires AuthService instance)
  // Note: These methods require an AuthService instance to be passed or accessed from context

  /// Check if can navigate back
  bool canGoBack(BuildContext context) {
    return context.canPop();
  }

  /// Safe navigation with error handling (async)
  Future<void> safeNavigateAsync(
    BuildContext context,
    Future<void> Function() navigationAction,
  ) async {
    try {
      await navigationAction();
    } catch (e) {
      LoggerService.instance.e('Navigation error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Navigation error: $e')));
      }
    }
  }

  // =====================================
  // 🔄 LEGACY METHODS (Keep for backward compatibility)
  // =====================================

  /// Legacy method - use goToPersonalOrders instead
  static void goToPersonalOrder(BuildContext context) {
    context.pushNamed('personal-orders-products');
  }

  /// Legacy method - use goToPersonalServiceOrders instead
  static void goToPersonalServiceBooking(BuildContext context) {
    context.pushNamed('personal-orders-services');
  }
}
