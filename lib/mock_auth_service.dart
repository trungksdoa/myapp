import 'package:myapp/service/interface/auth_repository.dart';

/// Mock implementation of AuthRepository for testing purposes
/// This allows testing without actual API calls or SharedPreferences
class MockAuthService extends AuthRepository {
  bool _isAuthenticated = false;
  String? _userId;
  String? _username;
  String? _email;
  String? _accessToken;
  String? _refreshToken;

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
  Future<void> initialize() async {
    await Future.delayed(apiDelay);
    notifyListeners();
  }

  @override
  Future<bool> login(String username, String password) async {
    await Future.delayed(apiDelay);

    if (shouldFailLogin) return false;

    if (username.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _userId = 'mock_user_123';
      _username = username;
      _email = '$username@mock.com';
      _accessToken = 'mock_access_token';
      _refreshToken = 'mock_refresh_token';
      notifyListeners();
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
      _isAuthenticated = true;
      _userId = 'mock_user_new';
      _username = username;
      _email = '$username@mock.com';
      _accessToken = 'mock_access_token_new';
      _refreshToken = 'mock_refresh_token_new';
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  Future<bool> loginWithGoogle() async {
    await Future.delayed(apiDelay);

    // Directly set authentication state without calling login method
    _isAuthenticated = true;
    _userId = 'mock_google_user_123';
    _username = 'Google User';
    _email = 'googleuser@gmail.com';
    _accessToken = 'mock_google_access_token';
    _refreshToken = 'mock_google_refresh_token';
    notifyListeners();
    return true;
  }

  @override
  Future<bool> loginWithFacebook() async {
    await Future.delayed(apiDelay);

    // Directly set authentication state without calling login method
    _isAuthenticated = true;
    _userId = 'mock_facebook_user_123';
    _username = 'Facebook User';
    _email = 'facebookuser@facebook.com';
    _accessToken = 'mock_facebook_access_token';
    _refreshToken = 'mock_facebook_refresh_token';
    notifyListeners();
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
    notifyListeners();
    return true;
  }

  @override
  Future<bool> updateProfile({String? username, String? email}) async {
    await Future.delayed(apiDelay);
    if (username != null) _username = username;
    if (email != null) _email = email;
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

  // Test helper methods
  void setAuthenticatedUser({
    required String userId,
    required String username,
    required String email,
  }) {
    _isAuthenticated = true;
    _userId = userId;
    _username = username;
    _email = email;
    _accessToken = 'mock_token';
    _refreshToken = 'mock_refresh';
    notifyListeners();
  }

  void reset() {
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
    print('=== MockAuthService State ===');
    print('isAuthenticated: $_isAuthenticated');
    print('userId: $_userId');
    print('username: $_username');
    print('email: $_email');
    print('accessToken: $_accessToken');
    print('shouldFailLogin: $shouldFailLogin');
    print('shouldFailRegistration: $shouldFailRegistration');
    print('shouldFailOTP: $shouldFailOTP');
    print('=============================');
  }
}
