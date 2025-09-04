import 'package:flutter/foundation.dart';
import 'package:myapp/core/utils/logger_service.dart';
import 'package:myapp/core/utils/security_storage.dart';
import 'package:myapp/service/interface/auth_repository.dart';

/// Concrete implementation of AuthRepository using SharedPreferences
/// for local storage and HTTP calls for API communication
class AuthService extends AuthRepository {
  static final AuthService _instance = AuthService._internal();
  final SecureStorageService storage = SecureStorageService();

  factory AuthService() => _instance;
  AuthService._internal();

  bool _isAuthenticated = false;
  String? _userId;
  String? _username;
  String? _email;
  String? _accessToken;
  String? _refreshToken;
  String? _role;

  // Getters - implementing interface
  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  String? get userId => _userId;

  @override
  String? get username => _username;

  @override
  String? get email => _email;

  @override
  String? get accessToken => _accessToken;

  @override
  String? get refreshToken => _refreshToken;

  @override
  String? get role => _role;

  // Keys for SharedPreferences
  static const String _keyIsAuthenticated = 'is_authenticated';
  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'username';
  static const String _keyEmail = 'email';
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyRole = 'role';

  static const String _keySecure = 'secure_data';

  @override
  Future<void> initialize() async {
    try {
      Map<String, dynamic>? secureValue = await SecureStorageService.getObject(
        _keySecure,
      );

      secureValue ??= {
        _keyIsAuthenticated: false,
        _keyUserId: null,
        _keyUsername: null,
        _keyEmail: null,
        _keyAccessToken: null,
        _keyRefreshToken: null,
        _keyRole: null,
      };

      _isAuthenticated = secureValue[_keyIsAuthenticated] ?? false;
      _userId = secureValue[_keyUserId];
      _username = secureValue[_keyUsername];
      _email = secureValue[_keyEmail];
      _accessToken = secureValue[_keyAccessToken];
      _refreshToken = secureValue[_keyRefreshToken];
      _role = secureValue[_keyRole];

      // Validate token if exists
      if (_isAuthenticated && _accessToken != null) {
        final isValid = await _validateToken(_accessToken!);
        if (!isValid) {
          await logout();
        }
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        LoggerService.instance.e('Error initializing auth service: $e');
      }
      await logout();
    }
  }

  @override
  Future<bool> login(String username, String password) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // Mock successful login
      if (username.isNotEmpty && password.isNotEmpty) {
        await _saveUserData(
          userId: 'user_123',
          username: username,
          email: '$username@carenest.com',
          accessToken: 'mock_access_token_123',
          refreshToken: 'mock_refresh_token_123',
        );
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        LoggerService.instance.e('Login error: $e');
      }
      return false;
    }
  }

  @override
  Future<bool> register({
    required String firstName,
    required String username,
    required String password,
  }) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // Mock successful registration
      if (username.isNotEmpty && password.isNotEmpty) {
        await _saveUserData(
          userId: 'user_new_${DateTime.now().millisecondsSinceEpoch}',
          username: username,
          email: '$username@carenest.com',
          accessToken: 'mock_access_token_new',
          refreshToken: 'mock_refresh_token_new',
        );
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        LoggerService.instance.e('Register error: $e');
      }
      return false;
    }
  }

  @override
  Future<bool> loginWithGoogle() async {
    try {
      // TODO: Implement Google login
      await Future.delayed(const Duration(seconds: 2));

      await _saveUserData(
        userId: 'google_user_123',
        username: 'Google User',
        email: 'googleuser@gmail.com',
        accessToken: 'google_access_token',
        refreshToken: 'google_refresh_token',
      );

      return true;
    } catch (e) {
      if (kDebugMode) {
        LoggerService.instance.e('Google login error: $e');
      }
      return false;
    }
  }

  @override
  Future<bool> loginWithFacebook() async {
    try {
      // TODO: Implement Facebook login
      await Future.delayed(const Duration(seconds: 2));

      await _saveUserData(
        userId: 'facebook_user_123',
        username: 'Facebook User',
        email: 'facebookuser@facebook.com',
        accessToken: 'facebook_access_token',
        refreshToken: 'facebook_refresh_token',
      );

      return true;
    } catch (e) {
      if (kDebugMode) {
        LoggerService.instance.e('Facebook login error: $e');
      }
      return false;
    }
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      if (kDebugMode) {
        LoggerService.instance.e('Send password reset error: $e');
      }
      return false;
    }
  }

  @override
  Future<bool> verifyOTP(String email, String otp) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));
      return otp == '1234'; // Mock OTP verification
    } catch (e) {
      if (kDebugMode) {
        LoggerService.instance.e('OTP verification error: $e');
      }
      return false;
    }
  }

  @override
  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      if (kDebugMode) {
        LoggerService.instance.e('Reset password error: $e');
      }
      return false;
    }
  }

  @override
  Future<void> logout() async {
    try {
      // TODO: Call logout API if needed

      // Clear local data
      await SecureStorageService.deleteKey(_keySecure);

      _isAuthenticated = false;
      _userId = null;
      _username = null;
      _email = null;
      _accessToken = null;
      _refreshToken = null;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        LoggerService.instance.e('Logout error: $e');
      }
    }
  }

  @override
  Future<bool> refreshAccessToken() async {
    try {
      if (_refreshToken == null) return false;

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock new access token
      _accessToken =
          'new_access_token_${DateTime.now().millisecondsSinceEpoch}';

      final storage = await SecureStorageService.getObject(_keySecure) ?? {};

      storage[_keyAccessToken] = _accessToken;
      await SecureStorageService.saveObject(_keySecure, storage);

      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        LoggerService.instance.e('Refresh token error: $e');
      }
      return false;
    }
  }

  @override
  Future<bool> updateProfile({String? username, String? email}) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final prefs = await SecureStorageService.getObject(_keySecure) ?? {};

      if (username != null) {
        _username = username;
        prefs[_keyUsername] = username;
      }

      if (email != null) {
        _email = email;
        prefs[_keyEmail] = email;
      }

      await SecureStorageService.saveObject(_keySecure, prefs);

      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        LoggerService.instance.e('Update profile error: $e');
      }
      return false;
    }
  }

  @override
  bool hasValidSession() {
    return _isAuthenticated && _accessToken != null && _accessToken!.isNotEmpty;
  }

  @override
  Map<String, String> get authHeaders {
    if (_accessToken != null) {
      return {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
      };
    }
    return {'Content-Type': 'application/json'};
  }

  // Private helper methods
  Future<void> _saveUserData({
    required String userId,
    required String username,
    required String email,
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SecureStorageService.getObject(_keySecure) ?? {};
    prefs[_keyIsAuthenticated] = true;
    prefs[_keyUserId] = userId;
    prefs[_keyUsername] = username;
    prefs[_keyEmail] = email;
    prefs[_keyAccessToken] = accessToken;
    prefs[_keyRefreshToken] = refreshToken;

    _isAuthenticated = true;
    _userId = userId;
    _username = username;
    _email = email;
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    notifyListeners();
  }

  Future<bool> _validateToken(String token) async {
    try {
      // TODO: Replace with actual API call to validate token
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock validation - check if token is not expired
      // In real app, this would call your API
      return token.isNotEmpty && !token.contains('expired');
    } catch (e) {
      if (kDebugMode) {
        LoggerService.instance.e('Token validation error: $e');
      }
      return false;
    }
  }
}
