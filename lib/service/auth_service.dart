import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/core/network/api_endpoints.dart';
import 'package:myapp/core/network/api_service.dart';
import 'package:myapp/core/utils/logger_service.dart';
import 'package:myapp/core/utils/security_storage.dart';
import 'package:myapp/shared/model/response_model.dart';
import 'package:myapp/shared/utils/auth_fallback.dart';
import 'package:myapp/shared/utils/jwt_utils.dart';
import 'package:myapp/service/interface/auth_repository.dart';

// API configuration is provided by ApiClient singleton

/// Concrete implementation of AuthRepository using SharedPreferences
/// for local storage and HTTP calls for API communication
class AuthService extends AuthRepository {
  static AuthService? _instance;

  factory AuthService() => _instance ??= AuthService._internal();

  AuthService._internal() : _apiService = ApiService(Dio()) {
    // Configure Dio instance
    //
    _apiService.dio.options.baseUrl = kDebugMode
        ? 'https://b76f1fcc2428.ngrok-free.app/'
        : 'https://b76f1fcc2428.ngrok-free.app/';

    LoggerService.instance.e(
      'Error initializing auth service: ${_apiService.dio.options.baseUrl}',
    );
    _apiService.dio.options.connectTimeout = const Duration(seconds: 60);
    _apiService.dio.options.receiveTimeout = const Duration(seconds: 60);
    _apiService.dio.options.sendTimeout = const Duration(seconds: 60);
    _apiService.dio.options.contentType = Headers.jsonContentType;
    _apiService.dio.options.responseType = ResponseType.json;
    _apiService.dio.options.validateStatus = (status) =>
        status != null && status < 500;
    _apiService.dio.options.headers = {'Accept': 'application/json'};
  }

  // Use ApiService with DioClient instance
  final ApiService _apiService;

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

      // Add authorization header if we have a token
      if (_accessToken != null && _accessToken!.isNotEmpty) {
        _apiService.dio.options.headers['Authorization'] =
            'Bearer $_accessToken';
      }

      // Add token refresh interceptor
      _apiService.dio.interceptors.add(
        InterceptorsWrapper(
          onError: (error, handler) async {
            if (error.response?.statusCode == 401) {
              if (await refreshAccessToken()) {
                // Retry the original request
                return handler.resolve(
                  await _apiService.dio.fetch(error.requestOptions),
                );
              }
            }
            return handler.next(error);
          },
        ),
      ); // Validate token if exists
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
    // Try real API first, fall back to mock on network or server errors.
    try {
      final response = await _apiService.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );

      final loginResponse = BaseResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => LoginData.fromJson(json as Map<String, dynamic>),
      );

      if (loginResponse.isSuccess && loginResponse.data != null) {
        final data = loginResponse.data!;

        // Decode JWT to extract userId/role when available
        final jwtUserId = extractUserIdFromJwt(data.accessToken);
        final jwtRole = extractRoleFromJwt(data.accessToken);

        final resolvedUserId =
            jwtUserId ?? data.userId ?? 'user_${data.username ?? username}';

        await _saveUserData(
          userId: resolvedUserId,
          username: data.username ?? username,
          email: data.email ?? '$username@carenest.com',
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
        );

        if (jwtRole != null) {
          _role = jwtRole;
          final prefs = await SecureStorageService.getObject(_keySecure) ?? {};
          prefs[_keyRole] = jwtRole;
          await SecureStorageService.saveObject(_keySecure, prefs);
        }

        // Token will be automatically managed by DioClient interceptors
        return true;
      }

      // If server returned failure or no data, return false
      return false;
    } on DioException catch (e) {
      // Network / server error – fall back to mock behavior
      if (kDebugMode)
        LoggerService.instance.w('Login network error, using fallback: $e');
      // Previous mock behaviour for offline/dev mode
      if (username.isNotEmpty && password.isNotEmpty) {
        final mock = buildMockCredentials(username);
        await _saveUserData(
          userId: mock['userId']!,
          username: mock['username']!,
          email: mock['email']!,
          accessToken: mock['accessToken']!,
          refreshToken: mock['refreshToken']!,
        );
        // Token will be automatically managed by DioClient interceptors
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) LoggerService.instance.e('Login error: $e');
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
      final response = await _apiService.post(
        ApiEndpoints.register,
        data: {
          'username': username,
          'fullName': firstName,
          'password': password,
          'reEnterPassword': password,
        },
      );

      final registerResponse = BaseResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => RegisterData.fromJson(json as Map<String, dynamic>),
      );

      // If we get tokens, save them and setup auth
      if (registerResponse.isSuccess && registerResponse.data != null) {
        final data = registerResponse.data!;
        final jwtUserId = extractUserIdFromJwt(data.accessToken);
        final jwtRole = extractRoleFromJwt(data.accessToken);

        await _saveUserData(
          userId:
              jwtUserId ?? data.userId ?? 'user_${data.username ?? username}',
          username: data.username ?? username,
          email: data.email ?? '$username@carenest.com',
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
        );

        if (jwtRole != null) {
          _role = jwtRole;
          final prefs = await SecureStorageService.getObject(_keySecure) ?? {};
          prefs[_keyRole] = jwtRole;
          await SecureStorageService.saveObject(_keySecure, prefs);
        }

        // Token will be automatically managed by DioClient interceptors
        return true;
      }

      // If server returned 201 but no tokens, still consider success
      if (response.statusCode == 201) {
        return true;
      }

      return false;
    } on DioException catch (e) {
      if (kDebugMode)
        LoggerService.instance.w('Register network error, using fallback: $e');
      // Fallback: mimic previous mock register
      if (username.isNotEmpty && password.isNotEmpty) {
        final mock = buildMockCredentials(username);
        await _saveUserData(
          userId: mock['userId']!,
          username: mock['username']!,
          email: mock['email']!,
          accessToken: mock['accessToken']!,
          refreshToken: mock['refreshToken']!,
        );
        // Token will be automatically managed by DioClient interceptors
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) LoggerService.instance.e('Register error: $e');
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
      // Clear dedicated auth token key used by ApiClient
      await SecureStorageService.deleteKey(SecureStorageService.keyAuthToken);

      // Clear token from Dio headers
      _apiService.dio.options.headers.remove('Authorization');

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

      // Update token in Dio headers
      _apiService.dio.options.headers['Authorization'] = 'Bearer $_accessToken';

      // Persist dedicated auth key
      await SecureStorageService.saveAuthToken(_accessToken!);

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

    // Persist secure data before updating in-memory state
    await SecureStorageService.saveObject(_keySecure, prefs);

    // Also persist tokens in SharedPreferences for DioClient interceptors
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString('accessToken', accessToken);
    await sharedPrefs.setString('refreshToken', refreshToken);
    // Set expiration time for token (24 hours from now)
    final expiredTime = DateTime.now().add(const Duration(hours: 24));
    await sharedPrefs.setString('expiredTime', expiredTime.toIso8601String());

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
      return token.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        LoggerService.instance.e('Token validation error: $e');
      }
      return false;
    }
  }
}
