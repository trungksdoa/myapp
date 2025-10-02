import 'package:flutter/foundation.dart';
import 'package:myapp/service/mock_auth_service.dart';
import 'package:myapp/service/auth_service.dart';
import 'package:myapp/service/interface/auth_repository.dart';

/// Factory class for creating AuthRepository instances
/// Allows switching between real and mock implementations
class AuthFactory {
  static AuthRepository? _instance;

  /// Get the current auth repository instance
  static AuthRepository get instance {
    _instance ??= _createInstance();
    return _instance!;
  }

  /// Create auth repository based on environment
  static AuthRepository _createInstance() {
    // Use mock for testing
    if (kDebugMode && _isInTestEnvironment()) {
      return createMockInstance();
    }

    // Use real implementation for production
    return AuthService();
  }

  /// Set custom auth repository (useful for testing)
  static void setInstance(AuthRepository authRepository) {
    _instance = authRepository;
  }

  /// Reset to default instance
  static void reset() {
    _instance = null;
  }

  /// Check if running in test environment
  static bool _isInTestEnvironment() {
    // This can be customized based on your testing setup
    return false; // Set to true when testing
  }

  /// Create mock instance for testing
  static MockAuthService createMockInstance() {
    return MockAuthService();
  }
}
