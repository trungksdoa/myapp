import 'package:myapp/core/utils/security_storage.dart';

/// Helper to build mock credential data used as a developer fallback
Map<String, String> buildMockCredentials(String username) {
  final ts = DateTime.now().millisecondsSinceEpoch;
  final userId = 'mock_${username}_$ts';
  return {
    'userId': userId,
    'username': username,
    'email': '$username@carenest.com',
    'accessToken': 'mock_access_token_$ts',
    'refreshToken': 'mock_refresh_token_$ts',
  };
}

/// Persist mock credentials directly to secure storage (for quick dev flows)
Future<void> persistMockCredentials(Map<String, String> creds) async {
  final prefs = await SecureStorageService.getObject('secure_data') ?? {};
  prefs['is_authenticated'] = true;
  prefs['user_id'] = creds['userId'];
  prefs['username'] = creds['username'];
  prefs['email'] = creds['email'];
  prefs['access_token'] = creds['accessToken'];
  prefs['refresh_token'] = creds['refreshToken'];
  await SecureStorageService.saveObject('secure_data', prefs);
}
