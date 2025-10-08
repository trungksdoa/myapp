// lib/features/auth/services/auth_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/core/network/dio_service_old.dart';
import 'package:myapp/core/utils/performance_monitor.dart';
import 'package:myapp/features/personal/interface/user.dart';
import 'package:myapp/shared/utils/jwt_utils.dart';
import 'interface/i_auth_service.dart';

class AuthService implements IAuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  late final DioClient _dioService;

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _userIdKey = 'user_id';
  static const String _userDataKey = 'user_data';
  static const String _isFirstTimeKey = 'is_first_time';

  String? _cachedUserId;
  Map<String, dynamic>? _cachedUserData;

  User? _cachedUser;

  bool _isInitialized = false;

  // ✅ Proper async initialization
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _dioService = DioClient();
      await _dioService.initialize("https://auth.devnest.io.vn");
      await _loadCachedUserData();
      _isInitialized = true;
    } catch (e) {
      print('[AuthService] Initialize failed: $e');
      _isInitialized = true;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    await _ensureInitialized();

    try {
      // ✅ API: POST /api/auth/login
      final response = await _dioService.post(
        '/api/auth/login',
        data: {'username': username, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;

      // ✅ API Response: LoginResponse { accessToken, refreshToken, username }
      await _dioService.saveTokens(
        accessToken: data['data']["accessToken"] as String,
        refreshToken: data['data']["refreshToken"] as String?,
        expiresIn: 24 * 60 * 60 * 7, // 1 week in seconds
      );

      final jwtUserId = extractUserIdFromJwt(data["data"]["accessToken"]);
      if (jwtUserId == null) {
        throw Exception('Invalid token received');
      }

      final jwtRole = extractRoleFromJwt(data["data"]["accessToken"]);
      final user = {
        "userId": jwtUserId,
        "role": jwtRole,
        "username": data["data"]["username"], // ✅ Use username from response
        "accessToken": data["data"]["accessToken"],
      };

      await _saveUserData(user);
      return data;
    } catch (e) {
      print('[AuthService] Login failed: $e');
      if (e is Exception) rethrow;
      throw Exception('Đăng nhập thất bại: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> register(Map<String, String> userData) async {
    await _ensureInitialized();

    try {
      // ✅ API: POST /api/accounts/register/customer
      final response = await _dioService.post(
        '/api/accounts/register/customer',
        data: userData,
      );
      final xKeyApt = response.headers.value('x-key-apt');

      // Return both status code and X-Key-APT header
      return {'statusCode': response?.statusCode ?? 500, 'xKeyApt': xKeyApt};
    } catch (e) {
      print('[AuthService] Register failed: $e');
      if (e is Exception) rethrow;
      throw Exception('Đăng ký thất bại: ${e.toString()}');
    }
  }

  @override
  Future<void> verifyRegisterOTP(
    String email,
    String otp,
    String xKeyApt,
  ) async {
    await _ensureInitialized();

    try {
      // ✅ API: POST /api/auth/registerVerifyToken
      final otpInt = int.parse(otp);
      await _dioService.post(
        '/api/auth/registerVerifyToken',
        data: {'email': email, 'otp': otpInt},
        options: Options(headers: {'X-Key-APT': xKeyApt}),
      );
    } catch (e) {
      print('[AuthService] Verify register OTP failed: $e');
      if (e is Exception) rethrow;
      throw Exception('Xác thực OTP thất bại: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await _ensureInitialized();

    try {
      // ✅ API: POST /api/auth/logout (requires Authorization header)
      await _dioService.post('/api/auth/logout');
    } catch (e) {
      print('[AuthService] Server logout failed: $e');
    } finally {
      await _clearAllUserData();
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    await _ensureInitialized();
    return await _dioService.hasValidToken();
  }

  @override
  String? get userId => _cachedUserId;

  @override
  Map<String, dynamic>? get userData => _cachedUserData;

  @override
  User? get user => _cachedUser;

  @override
  Future<void> sendPasswordResetOTP(String email) async {
    await _ensureInitialized();

    try {
      // ✅ API: POST /api/auth/forgot-password
      await _dioService.post(
        '/api/auth/forgot-password',
        data: {'email': email},
      );
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gửi mã OTP thất bại: ${e.toString()}');
    }
  }

  @override
  Future<void> verifyOTPAndResetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    await _ensureInitialized();

    try {
      Options headers = Options(headers: {'X-Key-APT': 'your-apt-key'});
      // Note: This returns a password reset token
      final verifyResponse = await _dioService.post(
        '/api/auth/verify/otp',
        data: {'email': email, 'otp': otp},
        options: headers,
      );

      final passwordResetToken = verifyResponse.data as String;
      Options headersRs = Options(
        headers: {
          'X-Key-APT': 'your-apt-key',
          'X-Password-Reset-Token': passwordResetToken,
        },
      );

      await _dioService.post(
        '/api/auth/newPassword',
        data: {
          'email': email,
          'password': newPassword,
          'reEnterPassword': newPassword,
        },
        options: headersRs,
      );
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Đặt lại mật khẩu thất bại: ${e.toString()}');
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _ensureInitialized();

    try {
      await _dioService.put(
        '/api/accounts/password',
        data: {
          'email': _cachedUserData?['email'], // Get from current user
          'password': newPassword,
          'reEnterPassword': newPassword,
        },
      );
    } catch (e) {
      print('[AuthService] Change password failed: $e');
      if (e is Exception) rethrow;
      throw Exception('Đổi mật khẩu thất bại: ${e.toString()}');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    await _ensureInitialized();

    try {
      // ✅ API: GET /api/auth/me
      final response = await _dioService.get('/api/auth/me');
      final serverResponse = response.data;
      logger.d('Get current user response: $serverResponse');
      final userData = serverResponse['data'] as Map<String, dynamic>;

      return User.fromJson(userData);
    } catch (e) {
      logger.e('Get current user failed: $e');
      return null;
    }
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    await _ensureInitialized();

    try {
      // ❌ NOT FOUND in API docs - keeping your original endpoint
      final response = await _dioService.put(
        '/api/auth/profile',
        data: profileData,
      );
      final updatedData = response.data as Map<String, dynamic>;
      await _saveUserData(updatedData);
    } catch (e) {
      print('[AuthService] Update profile failed: $e');
      if (e is Exception) rethrow;
      throw Exception('Cập nhật thông tin thất bại: ${e.toString()}');
    }
  }

  // First time app launch
  @override
  Future<bool> isFirstTime() async {
    final isFirstTime = await _secureStorage.read(key: _isFirstTimeKey);
    return isFirstTime == null;
  }

  @override
  Future<void> setNotFirstTime() async {
    await _secureStorage.write(key: _isFirstTimeKey, value: 'false');
  }

  // Private methods
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    try {
      _cachedUserData = userData;
      _cachedUserId = userData['userId']?.toString();

      if (_cachedUserId != null) {
        await _secureStorage.write(key: _userIdKey, value: _cachedUserId);
      }

      await _secureStorage.write(
        key: _userDataKey,
        value: jsonEncode(userData),
      );
    } catch (e) {
      print('[AuthService] Save user data failed: $e');
    }
  }

  Future<void> _loadCachedUserData() async {
    try {
      _cachedUserId = await _secureStorage.read(key: _userIdKey);

      final userDataStr = await _secureStorage.read(key: _userDataKey);
      if (userDataStr != null) {
        _cachedUserData = jsonDecode(userDataStr) as Map<String, dynamic>;
      }
    } catch (e) {
      print('[AuthService] Load cached data failed: $e');
      await _secureStorage.delete(key: _userDataKey);
      await _secureStorage.delete(key: _userIdKey);
    }
  }

  Future<void> _clearAllUserData() async {
    try {
      await _dioService.clearTokens();
      await _secureStorage.delete(key: _userIdKey);
      await _secureStorage.delete(key: _userDataKey);
      _cachedUserId = null;
      _cachedUserData = null;
    } catch (e) {
      print('[AuthService] Clear user data failed: $e');
    }
  }
}
