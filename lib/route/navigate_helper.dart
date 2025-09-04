import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/auth_factory.dart';
import 'package:myapp/core/utils/logger_service.dart';
import 'package:myapp/service/interface/auth_repository.dart';

class NavigateHelper {
  // Get auth service instance
  AuthRepository get _authService => AuthFactory.instance;

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
    String? groupSize,
    String? groupAvatar,
  }) {
    final params = <String, String>{};
    if (groupId != null) params['groupId'] = groupId;
    if (groupName != null) params['groupName'] = groupName;
    if (groupSize != null) params['groupSize'] = groupSize;
    if (groupAvatar != null) params['groupAvatar'] = groupAvatar;

    LoggerService.instance.d(
      'Sending params: $params',
    ); // Debug: In ra params trước khi gửi

    // Use push so user can go back; use go(uri) if you want to replace/clear
    context.goNamed('family-blog', extra: params);
  }

  static void goToBlogCreate(BuildContext context) {
    context.goNamed('blog-create');
  }

  static void goToSettingGroup(BuildContext context, String viewName) {
    context.pushNamed(viewName);
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

  /// Navigate to OTP verification screen
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

  /// Login and navigate to home
  Future<void> loginAndNavigateToHome(BuildContext context) async {
    await _authService.initialize();
    context.go('/home');
  }

  /// Logout and navigate to login
  Future<void> logoutAndNavigateToLogin(BuildContext context) async {
    _authService.logout();
    context.go('/auth/login');
  }

  /// Navigate after successful login
  static void navigateAfterLogin(BuildContext context, {String? redirectPath}) {
    if (redirectPath != null) {
      context.go(redirectPath);
    } else {
      context.go('/home'); // Default to home
    }
  }

  /// Navigate to login with from parameter
  static void navigateToLogin(BuildContext context, {String? fromPath}) {
    if (fromPath != null) {
      context.go('/auth/login?from=${Uri.encodeComponent(fromPath)}');
    } else {
      context.go('/auth/login');
    }
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

  // =====================================
  // UTILITY METHODS
  // =====================================

  /// Check if user is authenticated
  bool get isAuthenticated => _authService.isAuthenticated;

  /// Get current user info
  String? get currentUsername => _authService.username;
  String? get currentUserEmail => _authService.email;
  String? get currentUserId => _authService.userId;

  /// Check if can navigate back
  bool canGoBack(BuildContext context) {
    return context.canPop();
  }

  /// Safe navigation with error handling
  Future<void> safeNavigate(
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
}
