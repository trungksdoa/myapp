// lib/features/auth/services/interfaces/i_auth_service.dart
abstract class IAuthService {
  // Authentication
  Future<Map<String, dynamic>> login(String username, String password);
  Future<Map<String, dynamic>> register(Map<String, String> userData);
  Future<void> logout();

  // User State
  Future<bool> isAuthenticated();
  String? get userId;
  Map<String, dynamic>? get userData;
  Future<Map<String, dynamic>?> getCurrentUser();
  Future<void> updateProfile(Map<String, dynamic> profileData);

  // Password Management
  Future<void> sendPasswordResetOTP(String email);
  Future<void> verifyOTPAndResetPassword(String email, String otp, String newPassword);
  Future<void> changePassword(String oldPassword, String newPassword);

  // App State
  Future<bool> isFirstTime();
  Future<void> setNotFirstTime();
}
