import 'package:flutter/foundation.dart';

/// Abstract interface for authentication operations
/// This allows for easy testing and different implementations
abstract class AuthRepository extends ChangeNotifier {
  // Getters
  bool get isAuthenticated;
  String? get userId;
  String? get username;
  String? get email;
  String? get role;
  String? get accessToken;
  String? get refreshToken;

  /// Initialize auth service - check if user is already logged in
  Future<void> initialize();

  /// Login with username/email and password
  /// Returns true if login successful, false otherwise
  Future<bool> login(String username, String password);

  /// Register new user
  /// Returns true if registration successful, false otherwise
  Future<bool> register({
    required String firstName,
    required String username,
    required String password,
  });

  /// Login with Google OAuth
  /// Returns true if login successful, false otherwise
  Future<bool> loginWithGoogle();

  /// Login with Facebook OAuth
  /// Returns true if login successful, false otherwise
  Future<bool> loginWithFacebook();

  /// Send password reset email
  /// Returns true if email sent successfully, false otherwise
  Future<bool> sendPasswordResetEmail(String email);

  /// Verify OTP for password reset
  /// Returns true if OTP is valid, false otherwise
  Future<bool> verifyOTP(String email, String otp);

  /// Reset password with new password
  /// Returns true if password reset successful, false otherwise
  Future<bool> resetPassword(String email, String newPassword);

  /// Logout user and clear all stored data
  Future<void> logout();

  /// Refresh access token using refresh token
  /// Returns true if refresh successful, false otherwise
  Future<bool> refreshAccessToken();

  /// Update user profile information
  /// Returns true if update successful, false otherwise
  Future<bool> updateProfile({String? username, String? email});

  /// Check if user has valid session
  bool hasValidSession();

  /// Get authorization headers for API calls
  Map<String, String> get authHeaders;
}
