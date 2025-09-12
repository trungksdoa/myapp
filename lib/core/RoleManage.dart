import 'package:myapp/core/utils/security_storage.dart';

class RoleManager {
  static Future<bool> hasRole(String requiredRole) async {
    final userRole = await SecureStorageService.getUserRole();
    return userRole == requiredRole;
  }

  static Future<bool> hasPermission(String permission) async {
    final permissions = await SecureStorageService.getPermissions();
    return permissions.contains(permission);
  }

  static Future<bool> hasAnyRole(List<String> roles) async {
    final userRole = await SecureStorageService.getUserRole();
    return roles.contains(userRole);
  }
}
