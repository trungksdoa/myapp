import 'package:myapp/core/utils/logger_service.dart';
import 'package:myapp/core/utils/security_storage.dart';
import 'package:myapp/service/interface/auth_repository.dart';

/// Mock implementation of AuthRepository for testing purposes
/// This allows testing without actual API calls or SharedPreferences
class MockAuthService extends AuthRepository {
  final logger = LoggerService.instance;
  final SecureStorageService storage = SecureStorageService();

  bool _isAuthenticated = false;
  String? _userId;
  String? _username;
  String? _email;
  String? _accessToken;
  String? _refreshToken;
  String? _role;

  // Keys for SecureStorage (same as AuthService)
  static const String _keyIsAuthenticated = 'is_authenticated';
  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'username';
  static const String _keyEmail = 'email';
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyRole = 'role';
  static const String _keySecure = 'secure_data';

  // Override behaviors for testing
  bool shouldFailLogin = false;
  bool shouldFailRegistration = false;
  bool shouldFailOTP = false;
  Duration apiDelay = const Duration(milliseconds: 100);

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

      _isAuthenticated = secureValue[_keyIsAuthenticated] ?? true;
      _userId = secureValue[_keyUserId] ?? "1";
      _username = secureValue[_keyUsername] ?? "Guest";
      _email = secureValue[_keyEmail] ?? "guest@example.com";
      _accessToken = secureValue[_keyAccessToken] ?? "guest_access_token";
      _refreshToken = secureValue[_keyRefreshToken] ?? "guest_refresh_token";
      _role = secureValue[_keyRole] ?? "user";

      notifyListeners();
    } catch (e) {
      logger.e('Error initializing mock auth service: $e');
      await logout();
    }
  }

  @override
  Future<bool> login(String username, String password) async {
    await Future.delayed(apiDelay);

    if (shouldFailLogin) return false;

    if (username.isNotEmpty && password.isNotEmpty) {
      await _saveUserData(
        userId: 'mock_user_123',
        username: username,
        email: '$username@mock.com',
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> register({
    required String firstName,
    required String username,
    required String password,
  }) async {
    await Future.delayed(apiDelay);

    if (shouldFailRegistration) return false;

    if (username.isNotEmpty && password.isNotEmpty) {
      await _saveUserData(
        userId: 'mock_user_new',
        username: username,
        email: '$username@mock.com',
        accessToken: 'mock_access_token_new',
        refreshToken: 'mock_refresh_token_new',
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> loginWithGoogle() async {
    await Future.delayed(apiDelay);

    await SecureStorageService.saveUserRole("BOSS");
    await SecureStorageService.savePermissions(["ALL_ACCESS"]);
    // Directly set authentication state without calling login method
    await _saveUserData(
      userId: 'mock_google_user_123',
      username: 'Google User',
      email: 'googleuser@gmail.com',
      accessToken: 'mock_google_access_token',
      refreshToken: 'mock_google_refresh_token',
    );
    return true;
  }

  @override
  Future<bool> loginWithFacebook() async {
    await Future.delayed(apiDelay);

    await SecureStorageService.saveUserRole("BOSS");
    await SecureStorageService.savePermissions(["ALL_ACCESS"]);
    // Directly set authentication state without calling login method
    await _saveUserData(
      userId: 'mock_facebook_user_123',
      username: 'Facebook User',
      email: 'facebookuser@facebook.com',
      accessToken: 'mock_facebook_access_token',
      refreshToken: 'mock_facebook_refresh_token',
    );
    return true;
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    await Future.delayed(apiDelay);
    return email.isNotEmpty && email.contains('@');
  }

  @override
  Future<bool> verifyOTP(String email, String otp) async {
    await Future.delayed(apiDelay);
    if (shouldFailOTP) return false;
    return otp == '1234'; // Mock OTP
  }

  @override
  Future<bool> resetPassword(String email, String newPassword) async {
    await Future.delayed(apiDelay);
    return email.isNotEmpty && newPassword.isNotEmpty;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(apiDelay);

    // Clear local data
    await SecureStorageService.deleteKey(_keySecure);

    _isAuthenticated = false;
    _userId = null;
    _username = null;
    _email = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  @override
  Future<bool> refreshAccessToken() async {
    await Future.delayed(apiDelay);
    if (_refreshToken == null) return false;

    _accessToken = 'new_mock_access_token';

    final storage = await SecureStorageService.getObject(_keySecure) ?? {};
    storage[_keyAccessToken] = _accessToken;
    await SecureStorageService.saveObject(_keySecure, storage);

    notifyListeners();
    return true;
  }

  @override
  Future<bool> updateProfile({String? username, String? email}) async {
    await Future.delayed(apiDelay);

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
  }

  @override
  bool hasValidSession() {
    return _isAuthenticated && _accessToken != null;
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

    await SecureStorageService.saveObject(_keySecure, prefs);

    _isAuthenticated = true;
    _userId = userId;
    _username = username;
    _email = email;
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    notifyListeners();
  }

  // Test helper methods
  Future<void> setAuthenticatedUser({
    required String userId,
    required String username,
    required String email,
  }) async {
    await _saveUserData(
      userId: userId,
      username: username,
      email: email,
      accessToken: 'mock_token',
      refreshToken: 'mock_refresh',
    );
  }

  Future<void> reset() async {
    // Clear local data
    await SecureStorageService.deleteKey(_keySecure);

    _isAuthenticated = false;
    _userId = null;
    _username = null;
    _email = null;
    _accessToken = null;
    _refreshToken = null;
    shouldFailLogin = false;
    shouldFailRegistration = false;
    shouldFailOTP = false;
    notifyListeners();
  }

  // ===============================
  // MOCK-SPECIFIC HELPER METHODS
  // ===============================

  /// Set authenticated user directly (for testing)

  /// Configure mock to fail login
  void setShouldFailLogin(bool shouldFail) {
    shouldFailLogin = shouldFail;
  }

  /// Configure mock to fail registration
  void setShouldFailRegistration(bool shouldFail) {
    shouldFailRegistration = shouldFail;
  }

  /// Configure mock to fail OTP
  void setShouldFailOTP(bool shouldFail) {
    shouldFailOTP = shouldFail;
  }

  /// Set custom API delay for testing
  void setApiDelay(Duration delay) {
    apiDelay = delay;
  }

  /// Get mock credentials for development
  static Map<String, String> get mockCredentials => {
    'username': 'demo_user',
    'password': 'password123',
    'email': 'demo@carenest.com',
    'otp': '1234',
  };

  /// Print current mock state (for debugging)
  void printState() {
    logger.d('=== MockAuthService State ===');
    logger.d('isAuthenticated: $_isAuthenticated');
    logger.d('userId: $_userId');
    logger.d('username: $_username');
    logger.d('email: $_email');
    logger.d('accessToken: $_accessToken');
    logger.d('shouldFailLogin: $shouldFailLogin');
    logger.d('shouldFailRegistration: $shouldFailRegistration');
    logger.d('shouldFailOTP: $shouldFailOTP');
    logger.d('=============================');
  }
}
