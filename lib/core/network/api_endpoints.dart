/// API endpoints used by the app
class ApiEndpoints {
  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/accounts/register/customer';
  static const String refreshToken = '/api/auth/refresh';
  static const String logout = '/api/auth/logout';
  static const String verifyEmail = '/api/auth/verify-email';
  static const String resetPassword = '/api/auth/reset-password';
  static const String forgotPassword = '/api/auth/forgot-password';

  // User endpoints
  static const String profile = '/api/users/profile';
  static const String updateProfile = '/api/users/profile/update';
  static const String changePassword = '/api/users/change-password';

  // Pet endpoints
  static const String pets = '/api/pets';
  static const String petById = '/api/pets/'; // + id

  // Notifications
  static const String notifications = '/api/notifications';
  static const String notificationById = '/api/notifications/'; // + id
  static const String markNotificationRead =
      '/api/notifications/mark-read/'; // + id
  static const String markAllNotificationsRead =
      '/api/notifications/mark-all-read';

  // Consider adding:
  // - Search endpoints
  // - Payment endpoints
  // - Appointment endpoints
  // - Chat endpoints
  // etc.
}
