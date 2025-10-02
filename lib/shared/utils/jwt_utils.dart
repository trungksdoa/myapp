import 'dart:convert';

/// Decode JWT payload without validating signature.
/// Returns claims map or empty map when decoding fails.
Map<String, dynamic> decodeJwt(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return {};
    String payload = parts[1];
    // Fix padding
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    final Map<String, dynamic> claims = jsonDecode(decoded);
    return claims;
  } catch (_) {
    return {};
  }
}

String? extractUserIdFromJwt(String token) {
  final claims = decodeJwt(token);
  return claims['userId']?.toString() ?? claims['sub']?.toString();
}

String? extractRoleFromJwt(String token) {
  final claims = decodeJwt(token);
  // role may be a single role or list of roles
  final r = claims['role'] ?? claims['roles'] ?? claims['roleName'];
  if (r == null) return null;
  if (r is List && r.isNotEmpty) return r.first.toString();
  return r.toString();
}
