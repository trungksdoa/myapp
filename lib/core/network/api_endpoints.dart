/// API endpoints used by the app
class ApiEndpoints {
  // Base paths
  static const String _authBase = '/api/auth';
  static const String _userBase = '/api/users';
  static const String _petBase = '/api/pets';
  static const String _notificationBase = '/api/notifications';
  static const String _shopBase = '/api/shops';
  static const String _productBase = '/api/products';
  static const String _orderBase = '/api/orders';
  static const String _appointmentBase = '/api/appointments';

  // Auth endpoints
  static const String login = '$_authBase/login';
  static const String register = '/api/accounts/register/customer';
  static const String refreshToken = '$_authBase/refresh';
  static const String logout = '$_authBase/logout';
  static const String verifyEmail = '$_authBase/verify-email';
  static const String verifyOTP = '$_authBase/verify-otp';
  static const String passwordReset = '$_authBase/password-reset';
  static const String resetPassword = '$_authBase/reset-password';
  static const String forgotPassword = '$_authBase/forgot-password';
  static const String validateToken = '$_authBase/validate-token';

  // User endpoints
  static const String profile = '$_userBase/profile';
  static const String updateProfile = '$_userBase/profile/update';
  static const String changePassword = '$_userBase/change-password';
  static const String deleteAccount = '$_userBase/delete';

  // Pet endpoints
  static const String pets = _petBase;
  static String petById(String id) => '$_petBase/$id';
  static const String createPet = _petBase;
  static String updatePet(String id) => '$_petBase/$id';
  static String deletePet(String id) => '$_petBase/$id';

  // Shop endpoints
  static const String shops = _shopBase;
  static String shopById(String id) => '$_shopBase/$id';
  static String shopProducts(String shopId) => '$_shopBase/$shopId/products';
  static String shopServices(String shopId) => '$_shopBase/$shopId/services';

  // Product endpoints
  static const String products = _productBase;
  static String productById(String id) => '$_productBase/$id';
  static const String productCategories = '$_productBase/categories';
  static String productsByCategory(String category) =>
      '$_productBase/category/$category';

  // Order endpoints
  static const String orders = _orderBase;
  static String orderById(String id) => '$_orderBase/$id';
  static const String createOrder = _orderBase;
  static String updateOrderStatus(String id) => '$_orderBase/$id/status';

  // Appointment endpoints
  static const String appointments = _appointmentBase;
  static String appointmentById(String id) => '$_appointmentBase/$id';
  static const String createAppointment = _appointmentBase;
  static String updateAppointment(String id) => '$_appointmentBase/$id';
  static String cancelAppointment(String id) => '$_appointmentBase/$id/cancel';

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
