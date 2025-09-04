import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/core/utils/logger_service.dart';

class SecureStorageService {
  // Consistent storage instance với proper config
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'MyAppSecurePrefs',
      preferencesKeyPrefix: 'secure_',
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      groupId: 'group.com.careness.secure', // Optional: App Groups
    ),
  );

  // Generic method - lấy thông tin theo parameter
  static Future<String?> getValue(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      LoggerService.instance.e('Error reading key $key: $e');
      return null;
    }
  }

  // Generic method - lưu thông tin theo parameter
  static Future<void> setValue(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      LoggerService.instance.e('Error writing key $key: $e');
    }
  }

  // Lưu user role
  static Future<void> saveUserRole(String role) async {
    await setValue('user_role', role);
  }

  // Lấy user role
  static Future<String?> getUserRole() async {
    return await getValue('user_role');
  }

  // Lưu auth token
  static Future<void> saveAuthToken(String token) async {
    await setValue('auth_token', token);
  }

  // Lấy auth token
  static Future<String?> getAuthToken() async {
    return await getValue('auth_token');
  }

  // Lưu permissions (JSON)
  static Future<void> savePermissions(List<String> permissions) async {
    try {
      await setValue('user_permissions', jsonEncode(permissions));
    } catch (e) {
      LoggerService.instance.e('Error saving permissions: $e');
    }
  }

  // Lấy permissions
  static Future<List<String>> getPermissions() async {
    try {
      final permStr = await getValue('user_permissions');
      if (permStr != null) {
        return List<String>.from(jsonDecode(permStr));
      }
    } catch (e) {
      LoggerService.instance.e('Error parsing permissions: $e');
    }
    return [];
  }

  // Lưu object phức tạp (Map/JSON)
  static Future<void> saveObject(
    String key,
    Map<String, dynamic> object,
  ) async {
    try {
      await setValue(key, jsonEncode(object));
    } catch (e) {
      LoggerService.instance.e('Error saving object $key: $e');
    }
  }

  // Lấy object phức tạp
  static Future<Map<String, dynamic>?> getObject(String key) async {
    try {
      final jsonStr = await getValue(key);
      if (jsonStr != null) {
        return Map<String, dynamic>.from(jsonDecode(jsonStr));
      }
    } catch (e) {
      LoggerService.instance.e('Error parsing object $key: $e');
    }
    return null;
  }

  // Kiểm tra key có tồn tại không
  static Future<bool> containsKey(String key) async {
    try {
      final value = await getValue(key);
      return value != null;
    } catch (e) {
      return false;
    }
  }

  // Xoá key cụ thể
  static Future<void> deleteKey(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      LoggerService.instance.e('Error deleting key $key: $e');
    }
  }

  static Future<Map<String, String>> getAllValues() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      LoggerService.instance.e('Error reading all values: $e');
      return {};
    }
  }

  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      LoggerService.instance.i('All secure data cleared');
    } catch (e) {
      LoggerService.instance.e('Error clearing all data: $e');
    }
  }

  static const String keyUserRole = 'user_role';
  static const String keyAuthToken = 'auth_token';
  static const String keyUserPermissions = 'user_permissions';
  static const String keyUserProfile = 'user_profile';
  static const String keyLastLogin = 'last_login';
}
